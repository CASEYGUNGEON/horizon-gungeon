#define LOCKER_FULL -1

/obj/structure/closet
	name = "closet"
	desc = "It's a basic storage unit."
	icon = 'icons/obj/closet.dmi'
	icon_state = "generic"
	density = TRUE
	drag_slowdown = 1.5 // Same as a prone mob
	max_integrity = 200
	integrity_failure = 0.25
	armor = list(MELEE = 20, BULLET = 10, LASER = 10, ENERGY = 0, BOMB = 10, BIO = 0, RAD = 0, FIRE = 70, ACID = 60)
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE

	/// Controls whether a door overlay should be applied using the icon_door value as the icon state
	var/enable_door_overlay = TRUE
	var/has_opened_overlay = TRUE
	var/has_closed_overlay = TRUE
	var/icon_door = null
	var/icon_door_override = FALSE //override to have open overlay use icon different to its base's
	var/secure = FALSE //secure locker or not, also used if overriding a non-secure locker with a secure door overlay to add fancy lights
	var/opened = FALSE
	var/welded = FALSE
	var/locked = FALSE
	var/large = TRUE
	var/wall_mounted = 0 //never solid (You can always pass over it)
	var/breakout_time = 1200
	var/message_cooldown
	var/can_weld_shut = TRUE
	var/horizontal = FALSE
	var/allow_objects = FALSE
	var/allow_dense = FALSE
	var/dense_when_open = FALSE //if it's dense when open or not
	var/max_mob_size = MOB_SIZE_HUMAN //Biggest mob_size accepted by the container
	var/mob_storage_capacity = 3 // how many human sized mob/living can fit together inside a closet.
	var/storage_capacity = 30 //This is so that someone can't pack hundreds of items in a locker/crate then open it in a populated area to crash clients.
	var/cutting_tool = /obj/item/weldingtool
	var/open_sound = 'sound/machines/closet_open.ogg'
	var/close_sound = 'sound/machines/closet_close.ogg'
	var/open_sound_volume = 35
	var/close_sound_volume = 50
	var/material_drop = /obj/item/stack/sheet/iron
	var/material_drop_amount = 2
	var/delivery_icon = "deliverycloset" //which icon to use when packagewrapped. null to be unwrappable.
	var/anchorable = TRUE
	var/icon_welded = "welded"
	/// Whether a skittish person can dive inside this closet. Disable if opening the closet causes "bad things" to happen or that it leads to a logical inconsistency.
	var/divable = TRUE
	/// true whenever someone with the strong pull component is dragging this, preventing opening
	var/strong_grab = FALSE
	/// If we are installed with a lock, this is the ID to the key that opens us
	var/key_id
	/// If we are locked by a physical lock
	var/lock_locked = FALSE

/obj/structure/closet/Initialize(mapload)
	if(mapload && !opened) // if closed, any item at the crate's loc is put in the contents
		addtimer(CALLBACK(src, PROC_REF(take_contents)), 0)
	//If we initialize with a lock, lock the closet
	if(key_id)
		lock_locked = TRUE
	. = ..()
	update_appearance()
	PopulateContents()

//USE THIS TO FILL IT, NOT INITIALIZE OR NEW
/obj/structure/closet/proc/PopulateContents()
	return

/obj/structure/closet/Destroy()
	dump_contents()
	return ..()

/obj/structure/closet/update_appearance(updates=ALL)
	. = ..()
	if(opened || broken || !secure)
		luminosity = 0
		return
	luminosity = 1

/obj/structure/closet/update_icon()
	. = ..()
	if(istype(src, /obj/structure/closet/supplypod))
		return

	layer = opened ? BELOW_OBJ_LAYER : OBJ_LAYER

/obj/structure/closet/update_overlays()
	. = ..()
	closet_update_overlays(.)

/obj/structure/closet/proc/closet_update_overlays(list/new_overlays)
	. = new_overlays
	if(enable_door_overlay)
		if(opened && has_opened_overlay)
			var/mutable_appearance/door_overlay = mutable_appearance(icon, "[icon_door_override ? icon_door : icon_state]_open", alpha = src.alpha)
			. += door_overlay
			door_overlay.overlays += emissive_blocker(door_overlay.icon, door_overlay.icon_state, alpha = door_overlay.alpha) // If we don't do this the door doesn't block emissives and it looks weird.
		else if(has_closed_overlay)
			. += "[icon_door || icon_state]_door"

	if(opened)
		return

	if(key_id) //We have a lock
		. += "lock"

	if(welded)
		. += icon_welded

	if(broken || !secure)
		return
	//Overlay is similar enough for both that we can use the same mask for both
	. += emissive_appearance(icon, "locked", alpha = src.alpha)
	. += locked ? "locked" : "unlocked"

/obj/structure/closet/examine(mob/user)
	. = ..()
	if(welded)
		. += SPAN_NOTICE("It's welded shut.")
	if(anchored)
		. += SPAN_NOTICE("It is <b>bolted</b> to the ground.")
	if(opened)
		. += SPAN_NOTICE("The parts are <b>welded</b> together.")
	else if(secure && !opened)
		. += SPAN_NOTICE("Right-click to [locked ? "unlock" : "lock"].")

	if(HAS_TRAIT(user, TRAIT_SKITTISH) && divable)
		. += SPAN_NOTICE("If you bump into [p_them()] while running, you will jump inside.")

/obj/structure/closet/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(wall_mounted)
		return TRUE

/obj/structure/closet/proc/can_open(mob/living/user, force = FALSE)
	if(force)
		return TRUE
	if(lock_locked)
		playsound(src, 'sound/misc/knuckles.ogg', 50, TRUE)
		to_chat(user, SPAN_WARNING("\The [src] is locked!"))
		return FALSE
	if(welded || locked)
		return FALSE
	if(strong_grab)
		to_chat(user, SPAN_DANGER("[pulledby] has an incredibly strong grip on [src], preventing it from opening."))
		return FALSE
	var/turf/T = get_turf(src)
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > MOB_SIZE_TINY && L.density)
			if(user)
				to_chat(user, SPAN_DANGER("There's something large on top of [src], preventing it from opening."))
			return FALSE
	return TRUE

/obj/structure/closet/proc/can_close(mob/living/user)
	var/turf/T = get_turf(src)
	for(var/obj/structure/closet/closet in T)
		if(closet != src && !closet.wall_mounted)
			return FALSE
	for(var/mob/living/L in T)
		if(L.anchored || horizontal && L.mob_size > MOB_SIZE_TINY && L.density)
			if(user)
				to_chat(user, SPAN_DANGER("There's something too large in [src], preventing it from closing."))
			return FALSE
	return TRUE

/obj/structure/closet/dump_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in src)
		AM.forceMove(L)
		if(throwing) // you keep some momentum when getting out of a thrown closet
			step(AM, dir)
	if(throwing)
		throwing.finalize(FALSE)

/obj/structure/closet/proc/take_contents()
	var/atom/L = drop_location()
	for(var/atom/movable/AM in L)
		if(AM != src && insert(AM) == LOCKER_FULL) // limit reached
			break
	for(var/i in reverseRange(L.GetAllContents()))
		var/atom/movable/thing = i
		SEND_SIGNAL(thing, COMSIG_TRY_STORAGE_HIDE_ALL)

/obj/structure/closet/proc/open(mob/living/user, force = FALSE)
	if(!can_open(user, force))
		return
	if(opened)
		return
	welded = FALSE
	locked = FALSE
	playsound(loc, open_sound, open_sound_volume, TRUE, -3)
	opened = TRUE
	if(!dense_when_open)
		set_density(FALSE)
	dump_contents()
	update_appearance()
	after_open(user, force)
	return TRUE

///Proc to override for effects after opening a door
/obj/structure/closet/proc/after_open(mob/living/user, force = FALSE)
	return

/obj/structure/closet/proc/insert(atom/movable/inserted)
	if(length(contents) >= storage_capacity)
		return LOCKER_FULL
	if(!insertion_allowed(inserted))
		return FALSE
	if(SEND_SIGNAL(src, COMSIG_CLOSET_INSERT, inserted) & COMPONENT_CLOSET_INSERT_INTERRUPT)
		return TRUE
	inserted.forceMove(src)
	return TRUE

/obj/structure/closet/proc/insertion_allowed(atom/movable/AM)
	if(ismob(AM))
		if(!isliving(AM)) //let's not put ghosts or camera mobs inside closets...
			return FALSE
		var/mob/living/L = AM
		if(L.anchored || L.buckled || L.incorporeal_move || L.has_buckled_mobs())
			return FALSE
		if(L.mob_size > MOB_SIZE_TINY) // Tiny mobs are treated as items.
			if(horizontal && L.density)
				return FALSE
			if(L.mob_size > max_mob_size)
				return FALSE
			var/mobs_stored = 0
			for(var/mob/living/M in contents)
				if(++mobs_stored >= mob_storage_capacity)
					return FALSE
		L.stop_pulling()

	else if(istype(AM, /obj/structure/closet))
		return FALSE
	else if(isobj(AM))
		if((!allow_dense && AM.density) || AM.anchored || AM.has_buckled_mobs())
			return FALSE
		else if(isitem(AM) && !HAS_TRAIT(AM, TRAIT_NODROP))
			return TRUE
		else if(!allow_objects && !istype(AM, /obj/effect/dummy/chameleon))
			return FALSE
	else
		return FALSE

	return TRUE

/obj/structure/closet/proc/close(mob/living/user)
	if(!opened || !can_close(user))
		return FALSE
	take_contents()
	playsound(loc, close_sound, close_sound_volume, TRUE, -3)
	opened = FALSE
	set_density(TRUE)
	update_appearance()
	after_close(user)
	return TRUE

///Proc to override for effects after closing a door
/obj/structure/closet/proc/after_close(mob/living/user)
	return


/obj/structure/closet/proc/toggle(mob/living/user)
	if(opened)
		return close(user)
	else
		return open(user)

/obj/structure/closet/deconstruct(disassembled = TRUE)
	if(ispath(material_drop) && material_drop_amount && !(flags_1 & NODECONSTRUCT_1))
		new material_drop(loc, material_drop_amount)
	qdel(src)

/obj/structure/closet/obj_break(damage_flag)
	. = ..()
	if(!broken && !(flags_1 & NODECONSTRUCT_1))
		bust_open()

/obj/structure/closet/attackby(obj/item/W, mob/user, params)
	if(user in src)
		return
	if(istype(W, /obj/item/lockpick))
		var/obj/item/lockpick/lockpick_item = W
		if(!key_id)
			to_chat(user, SPAN_WARNING("\The [src] does not have a lock!"))
			return
		if(!lock_locked)
			to_chat(user, SPAN_WARNING("\The [src] is unlocked!"))
			return
		user.visible_message(SPAN_NOTICE("[user] begins lockpicking \the [src]."), SPAN_NOTICE("You begin lockpicking \the [src]."))
		user.changeNext_move(CLICK_CD_MELEE)
		playsound(src, 'sound/misc/knuckles.ogg', 50, TRUE)
		if(do_after(user, LOCKPICK_TIME, target = src))
			if(!lock_locked)
				return
			if(prob(LOCKPICK_BREAK_CHANCE))
				to_chat(user, SPAN_WARNING("\The [lockpick_item] breaks!"))
				qdel(lockpick_item)
				return
			if(prob(LOCKPICK_SUCCESS_CHANCE))
				to_chat(user, SPAN_NOTICE("You unlock \the [src]!"))
				lock_locked = FALSE
			else
				to_chat(user, SPAN_WARNING("You fail to unlock \the [src]!"))
			playsound(src, 'sound/misc/knuckles.ogg', 50, TRUE)
		return
	if(istype(W, /obj/item/lock))
		var/obj/item/lock/lock_item = W
		if(secure)
			to_chat(user, SPAN_WARNING("\The [src] can't have a lock installed!"))
			return
		if(key_id)
			to_chat(user, SPAN_WARNING("\The [src] already has a lock!"))
			return
		to_chat(user, SPAN_NOTICE("You install \the [lock_item] on \the [src]."))
		key_id = lock_item.key_id
		update_appearance()
		qdel(lock_item)
		return
	if(istype(W, /obj/item/key))
		var/obj/item/key/key_item = W
		if(!key_id)
			to_chat(user, SPAN_WARNING("\The [src] does not have a lock!"))
			return
		if(opened)
			to_chat(user, SPAN_WARNING("Close \the [src] first!"))
			return
		if(key_item.key_id != key_id)
			to_chat(user, SPAN_WARNING("\The [key_item] does not fit \the [src]!"))
			return
		if(lock_locked)
			to_chat(user, SPAN_NOTICE("You unlock \the [src]."))
		else
			to_chat(user, SPAN_NOTICE("You lock \the [src]."))
		lock_locked = !lock_locked
		playsound(src, 'sound/misc/knuckles.ogg', 50, TRUE)
		return
	if(src.tool_interact(W,user))
		return 1 // No afterattack
	else
		return ..()

/obj/structure/closet/proc/tool_interact(obj/item/W, mob/living/user)//returns TRUE if attackBy call shouldn't be continued (because tool was used/closet was of wrong type), FALSE if otherwise
	. = TRUE
	if(opened)
		if(istype(W, cutting_tool))
			if(W.tool_behaviour == TOOL_WELDER)
				if(!W.tool_start_check(user, amount=0))
					return

				to_chat(user, SPAN_NOTICE("You begin cutting \the [src] apart..."))
				if(W.use_tool(src, user, 40, volume=50))
					if(!opened)
						return
					user.visible_message(SPAN_NOTICE("[user] slices apart \the [src]."),
									SPAN_NOTICE("You cut \the [src] apart with \the [W]."),
									SPAN_HEAR("You hear welding."))
					deconstruct(TRUE)
				return
			else // for example cardboard box is cut with wirecutters
				user.visible_message(SPAN_NOTICE("[user] cut apart \the [src]."), \
									SPAN_NOTICE("You cut \the [src] apart with \the [W]."))
				deconstruct(TRUE)
				return
		if(user.transferItemToLoc(W, drop_location())) // so we put in unlit welder too
			return
	else if(W.tool_behaviour == TOOL_WELDER && can_weld_shut)
		if(!W.tool_start_check(user, amount=0))
			return

		to_chat(user, SPAN_NOTICE("You begin [welded ? "unwelding":"welding"] \the [src]..."))
		if(W.use_tool(src, user, 40, volume=50))
			if(opened)
				return
			welded = !welded
			after_weld(welded)
			user.visible_message(SPAN_NOTICE("[user] [welded ? "welds shut" : "unwelded"] \the [src]."),
							SPAN_NOTICE("You [welded ? "weld" : "unwelded"] \the [src] with \the [W]."),
							SPAN_HEAR("You hear welding."))
			log_game("[key_name(user)] [welded ? "welded":"unwelded"] closet [src] with [W] at [AREACOORD(src)]")
			update_appearance()
	else if(W.tool_behaviour == TOOL_WRENCH && anchorable)
		if(isinspace() && !anchored)
			return
		set_anchored(!anchored)
		W.play_tool_sound(src, 75)
		user.visible_message(SPAN_NOTICE("[user] [anchored ? "anchored" : "unanchored"] \the [src] [anchored ? "to" : "from"] the ground."), \
						SPAN_NOTICE("You [anchored ? "anchored" : "unanchored"] \the [src] [anchored ? "to" : "from"] the ground."), \
						SPAN_HEAR("You hear a ratchet."))
	else if(!user.combat_mode)
		var/item_is_id = W.GetID()
		if(!item_is_id)
			return FALSE
		if(item_is_id || !toggle(user))
			togglelock(user)
	else
		return FALSE

/obj/structure/closet/proc/after_weld(weld_state)
	return

/obj/structure/closet/MouseDrop_T(atom/movable/O, mob/living/user)
	if(!istype(O) || O.anchored || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated() || user.body_position == LYING_DOWN)
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb onto it
		return ..()
	if(!opened)
		return
	if(!isturf(O.loc))
		return

	var/actuallyismob = 0
	if(isliving(O))
		actuallyismob = 1
	else if(!isitem(O))
		return
	var/turf/T = get_turf(src)
	var/list/targets = list(O, src)
	add_fingerprint(user)
	user.visible_message(SPAN_WARNING("[user] [actuallyismob ? "tries to ":""]stuff [O] into [src]."), \
		SPAN_WARNING("You [actuallyismob ? "try to ":""]stuff [O] into [src]."), \
		SPAN_HEAR("You hear clanging."))
	if(actuallyismob)
		if(do_after_mob(user, targets, 40))
			user.visible_message(SPAN_NOTICE("[user] stuffs [O] into [src]."), \
				SPAN_NOTICE("You stuff [O] into [src]."), \
				SPAN_HEAR("You hear a loud metal bang."))
			var/mob/living/L = O
			if(!issilicon(L))
				L.Paralyze(40)
			if(istype(src, /obj/structure/closet/supplypod/extractionpod))
				O.forceMove(src)
			else
				O.forceMove(T)
				close()
	else
		O.forceMove(T)
	return 1

/obj/structure/closet/relaymove(mob/living/user, direction)
	if(user.stat || !isturf(loc))
		return
	if(locked)
		if(message_cooldown <= world.time)
			message_cooldown = world.time + 50
			to_chat(user, SPAN_WARNING("[src]'s door won't budge!"))
		return
	container_resist_act(user)


/obj/structure/closet/attack_hand(mob/living/user, list/modifiers)
	. = ..()
	if(.)
		return
	if(user.body_position == LYING_DOWN && get_dist(src, user) > 0)
		return

	if(!toggle(user))
		togglelock(user)


/obj/structure/closet/attack_paw(mob/user, list/modifiers)
	return attack_hand(user, modifiers)

/obj/structure/closet/attack_robot(mob/user)
	if(user.Adjacent(src))
		return attack_hand(user)

// tk grab then use on self
/obj/structure/closet/attack_self_tk(mob/user)
	if(attack_hand(user))
		return COMPONENT_CANCEL_ATTACK_CHAIN

/obj/structure/closet/verb/verb_toggleopen()
	set src in view(1)
	set category = "Object"
	set name = "Toggle Open"

	if(!usr.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return

	if(iscarbon(usr) || issilicon(usr) || isdrone(usr))
		return toggle(usr)
	else
		to_chat(usr, SPAN_WARNING("This mob type can't use this verb."))

// Objects that try to exit a locker by stepping were doing so successfully,
// and due to an oversight in turf/Enter() were going through walls.  That
// should be independently resolved, but this is also an interesting twist.
/obj/structure/closet/Exit(atom/movable/leaving, direction)
	open()
	if(leaving.loc == src)
		return FALSE
	return TRUE

/obj/structure/closet/container_resist_act(mob/living/user)
	if(opened)
		return
	if(ismovable(loc))
		user.changeNext_move(CLICK_CD_BREAKOUT)
		user.last_special = world.time + CLICK_CD_BREAKOUT
		var/atom/movable/AM = loc
		AM.relay_container_resist_act(user, src)
		return
	if(!welded && !locked)
		open()
		return

	//okay, so the closet is either welded or locked... resist!!!
	user.changeNext_move(CLICK_CD_BREAKOUT)
	user.last_special = world.time + CLICK_CD_BREAKOUT
	user.visible_message(SPAN_WARNING("[src] begins to shake violently!"), \
		SPAN_NOTICE("You lean on the back of [src] and start pushing the door open... (this will take about [DisplayTimeText(breakout_time)].)"), \
		SPAN_HEAR("You hear banging from [src]."))
	if(do_after(user,(breakout_time), target = src))
		if(!user || user.stat != CONSCIOUS || user.loc != src || opened || (!locked && !welded) )
			return
		//we check after a while whether there is a point of resisting anymore and whether the user is capable of resisting
		user.visible_message(SPAN_DANGER("[user] successfully broke out of [src]!"),
							SPAN_NOTICE("You successfully break out of [src]!"))
		bust_open()
	else
		if(user.loc == src) //so we don't get the message if we resisted multiple times and succeeded.
			to_chat(user, SPAN_WARNING("You fail to break out of [src]!"))

/obj/structure/closet/proc/bust_open()
	SIGNAL_HANDLER
	welded = FALSE //applies to all lockers
	locked = FALSE //applies to critter crates and secure lockers only
	broken = TRUE //applies to secure lockers only
	open()

/obj/structure/closet/RightClick(mob/user, modifiers)
	if(!user.canUseTopic(src, BE_CLOSE) || !isturf(loc))
		return
	if(!opened && secure)
		togglelock(user)
	return TRUE

/obj/structure/closet/proc/togglelock(mob/living/user, silent)
	if(secure && !broken)
		if(allowed(user))
			if(iscarbon(user))
				add_fingerprint(user)
			locked = !locked
			user.visible_message(SPAN_NOTICE("[user] [locked ? null : "un"]locks [src]."),
							SPAN_NOTICE("You [locked ? null : "un"]lock [src]."))
			update_appearance()
		else if(!silent)
			to_chat(user, SPAN_ALERT("Access Denied."))
	else if(secure && broken)
		to_chat(user, SPAN_WARNING("\The [src] is broken!"))

/obj/structure/closet/emag_act(mob/user)
	if(secure && !broken)
		if(user)
			user.visible_message(SPAN_WARNING("Sparks fly from [src]!"),
							SPAN_WARNING("You scramble [src]'s lock, breaking it open!"),
							SPAN_HEAR("You hear a faint electrical spark."))
		playsound(src, "sparks", 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
		broken = TRUE
		locked = FALSE
		update_appearance()

/obj/structure/closet/get_remote_view_fullscreens(mob/user)
	if(user.stat == DEAD || !(user.sight & (SEEOBJS|SEEMOBS)))
		user.overlay_fullscreen("remote_view", /atom/movable/screen/fullscreen/impaired, HUD_IMPAIRMENT_HALF_BLIND)

/obj/structure/closet/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	if (!(. & EMP_PROTECT_CONTENTS))
		for(var/obj/O in src)
			O.emp_act(severity)
	if(secure && !broken && !(. & EMP_PROTECT_SELF))
		if(prob(50 / severity))
			locked = !locked
			update_appearance()
		if(prob(20 / severity) && !opened)
			if(!locked)
				open()
			else
				req_access = list()
				req_access += pick(SSid_access.get_region_access_list(list(REGION_ALL_STATION)))

/obj/structure/closet/contents_explosion(severity, target)
	switch(severity)
		if(EXPLODE_DEVASTATE)
			SSexplosions.high_mov_atom += contents
		if(EXPLODE_HEAVY)
			SSexplosions.med_mov_atom += contents
		if(EXPLODE_LIGHT)
			SSexplosions.low_mov_atom += contents

/obj/structure/closet/singularity_act()
	dump_contents()
	..()

/obj/structure/closet/AllowDrop()
	return TRUE

/obj/structure/closet/return_temperature()
	return

#undef LOCKER_FULL
