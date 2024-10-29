/obj/item/melee/baton
	name = "stun baton"
	desc = "A stun baton for incapacitating people with. Left click to stun, right click to harm."

	icon_state = "stunbaton"
	inhand_icon_state = "baton"
	worn_icon_state = "baton"
	lefthand_file = 'icons/mob/inhands/equipment/security_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/security_righthand.dmi'

	force = 10
	attack_verb_continuous = list("beats")
	attack_verb_simple = list("beat")

	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_BELT
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 50, BIO = 0, RAD = 0, FIRE = 80, ACID = 80)

	throwforce = 7
	var/throw_stun_chance = 35

	var/obj/item/stock_parts/cell/cell
	var/preload_cell_type //if not empty the baton starts with this type of cell
	var/cell_hit_cost = 1000
	var/can_remove_cell = TRUE

	var/turned_on = FALSE
	var/activate_sound = "sparks"

	var/attack_cooldown_check = 0 SECONDS
	var/attack_cooldown = 2.5 SECONDS
	var/stun_sound = 'sound/weapons/egloves.ogg'

	var/confusion_amt = 10
	var/stamina_loss_amt = 60
	var/apply_stun_delay = 2 SECONDS
	var/stun_time = 5 SECONDS

	var/convertible = TRUE //if it can be converted with a conversion kit

/obj/item/melee/baton/get_cell()
	return cell

/obj/item/melee/baton/suicide_act(mob/user)
	if(cell?.charge && turned_on)
		user.visible_message(SPAN_SUICIDE("[user] is putting the live [name] in [user.p_their()] mouth! It looks like [user.p_theyre()] trying to commit suicide!"))
		. = (FIRELOSS)
		attack(user,user)
	else
		user.visible_message(SPAN_SUICIDE("[user] is shoving the [name] down their throat! It looks like [user.p_theyre()] trying to commit suicide!"))
		. = (OXYLOSS)

/obj/item/melee/baton/Initialize()
	. = ..()
	if(preload_cell_type)
		if(!ispath(preload_cell_type,/obj/item/stock_parts/cell))
			log_mapping("[src] at [AREACOORD(src)] had an invalid preload_cell_type: [preload_cell_type].")
		else
			cell = new preload_cell_type(src)
	update_appearance()
	RegisterSignal(src, COMSIG_PARENT_ATTACKBY, PROC_REF(convert))


/obj/item/melee/baton/Destroy()
	if(cell)
		QDEL_NULL(cell)
	UnregisterSignal(src, COMSIG_PARENT_ATTACKBY)
	return ..()

/obj/item/melee/baton/proc/convert(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER

	if(istype(I,/obj/item/conversion_kit) && convertible)
		var/turf/T = get_turf(src)
		var/obj/item/melee/classic_baton/B = new /obj/item/melee/classic_baton (T)
		B.alpha = 20
		playsound(T, 'sound/items/drill_use.ogg', 80, TRUE, -1)
		animate(src, alpha = 0, time = 10)
		animate(B, alpha = 255, time = 10)
		qdel(I)
		qdel(src)

/obj/item/melee/baton/handle_atom_del(atom/A)
	if(A == cell)
		cell = null
		turned_on = FALSE
		update_appearance()
	return ..()

/obj/item/melee/baton/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	//Only mob/living types have stun handling
	if(turned_on && prob(throw_stun_chance) && isliving(hit_atom) && !iscyborg(hit_atom))
		baton_effect(hit_atom)

/obj/item/melee/baton/loaded //this one starts with a cell pre-installed.
	preload_cell_type = /obj/item/stock_parts/cell/high

/obj/item/melee/baton/proc/deductcharge(chrgdeductamt)
	if(cell)
		//Note this value returned is significant, as it will determine
		//if a stun is applied or not
		. = cell.use(chrgdeductamt)
		if(turned_on && cell.charge < cell_hit_cost)
			//we're below minimum, turn off
			turned_on = FALSE
			update_appearance()
			playsound(src, activate_sound, 75, TRUE, -1)


/obj/item/melee/baton/update_icon_state()
	if(turned_on)
		icon_state = "[initial(icon_state)]_active"
		return ..()
	if(!cell)
		icon_state = "[initial(icon_state)]_nocell"
		return ..()
	icon_state = "[initial(icon_state)]"
	return ..()

/obj/item/melee/baton/examine(mob/user)
	. = ..()
	if(cell)
		. += SPAN_NOTICE("\The [src] is [round(cell.percent())]% charged.")
	else
		. += SPAN_WARNING("\The [src] does not have a power source installed.")

/obj/item/melee/baton/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/stock_parts/cell))
		var/obj/item/stock_parts/cell/C = W
		if(cell)
			to_chat(user, SPAN_WARNING("[src] already has a cell!"))
		else
			if(C.maxcharge < cell_hit_cost)
				to_chat(user, SPAN_NOTICE("[src] requires a higher capacity cell."))
				return
			if(!user.transferItemToLoc(W, src))
				return
			cell = W
			to_chat(user, SPAN_NOTICE("You install a cell in [src]."))
			update_appearance()

	else if(W.tool_behaviour == TOOL_SCREWDRIVER)
		tryremovecell(user)
	else
		return ..()

/obj/item/melee/baton/proc/tryremovecell(mob/user)
	if(cell && can_remove_cell)
		cell.update_appearance()
		cell.forceMove(get_turf(src))
		cell = null
		to_chat(user, SPAN_NOTICE("You remove the cell from [src]."))
		turned_on = FALSE
		update_appearance()

/obj/item/melee/baton/attack_self(mob/user)
	toggle_on(user)

/obj/item/melee/baton/proc/toggle_on(mob/user)
	if(cell && cell.charge >= cell_hit_cost)
		turned_on = !turned_on
		to_chat(user, SPAN_NOTICE("[src] is now [turned_on ? "on" : "off"]."))
		playsound(src, activate_sound, 75, TRUE, -1)
	else
		turned_on = FALSE
		if(!cell)
			to_chat(user, SPAN_WARNING("[src] does not have a power source!"))
		else
			to_chat(user, SPAN_WARNING("[src] is out of charge."))
	update_appearance()
	add_fingerprint(user)

/obj/item/melee/baton/proc/clumsy_check(mob/living/carbon/human/user)
	if(turned_on && HAS_TRAIT(user, TRAIT_CLUMSY) && prob(50))
		playsound(src, stun_sound, 75, TRUE, -1)
		user.visible_message(SPAN_DANGER("[user] accidentally hits [user.p_them()]self with [src]!"), \
							SPAN_USERDANGER("You accidentally hit yourself with [src]!"))
		user.Knockdown(stun_time*3) //should really be an equivalent to attack(user,user)
		deductcharge(cell_hit_cost)
		return TRUE
	return FALSE

/obj/item/melee/baton/attack(mob/M, mob/living/carbon/human/user, params)
	if(clumsy_check(user))
		return FALSE

	if(iscyborg(M))
		..()
		return


	if(ishuman(M))
		var/mob/living/carbon/human/L = M
		if(check_martial_counter(L, user))
			return

	var/list/modifiers = params2list(params)
	if(LAZYACCESS(modifiers, RIGHT_CLICK))
		if(turned_on)
			if(attack_cooldown_check <= world.time)
				baton_effect(M, user)
		..()
		return
	else if(turned_on)
		if(attack_cooldown_check <= world.time)
			if(baton_effect(M, user))
				user.do_attack_animation(M)
				return
		else
			to_chat(user, SPAN_DANGER("The baton is still charging!"))
			return
	else
		M.visible_message(SPAN_WARNING("[user] prods [M] with [src]. Luckily it was off."), \
					SPAN_WARNING("[user] prods you with [src]. Luckily it was off."))
		return

/obj/item/melee/baton/proc/baton_effect(mob/living/L, mob/user)
	if(shields_blocked(L, user))
		return FALSE
	if(HAS_TRAIT_FROM(L, TRAIT_IWASBATONED, user)) //no doublebaton abuse anon!
		to_chat(user, SPAN_DANGER("[L] manages to avoid the attack!"))
		return FALSE
	if(iscyborg(loc))
		var/mob/living/silicon/robot/R = loc
		if(!R || !R.cell || !R.cell.use(cell_hit_cost))
			return FALSE
	else
		if(!deductcharge(cell_hit_cost))
			return FALSE
	/// After a target is hit, we do a chunk of stamina damage, along with other effects.
	/// After a period of time, we then check to see what stun duration we give.
	L.Jitter(20)
	L.set_confusion(max(confusion_amt, L.get_confusion()))
	L.stuttering = max(8, L.stuttering)
	L.apply_damage(stamina_loss_amt, STAMINA, BODY_ZONE_CHEST)

	SEND_SIGNAL(L, COMSIG_LIVING_MINOR_SHOCK)
	addtimer(CALLBACK(src, PROC_REF(apply_stun_effect_end), L), apply_stun_delay)

	if(user)
		L.lastattacker = user.real_name
		L.lastattackerckey = user.ckey
		L.visible_message(SPAN_DANGER("[user] stuns [L] with [src]!"), \
								SPAN_USERDANGER("[user] stuns you with [src]!"))
		log_combat(user, L, "stunned")

	playsound(src, stun_sound, 50, TRUE, -1)

	attack_cooldown_check = world.time + attack_cooldown

	ADD_TRAIT(L, TRAIT_IWASBATONED, STATUS_EFFECT_TRAIT)
	addtimer(TRAIT_CALLBACK_REMOVE(L, TRAIT_IWASBATONED, STATUS_EFFECT_TRAIT), attack_cooldown)

	return 1

/// After the initial stun period, we check to see if the target needs to have the stun applied.
/obj/item/melee/baton/proc/apply_stun_effect_end(mob/living/target)
	var/trait_check = HAS_TRAIT(target, TRAIT_STUNRESISTANCE) //var since we check it in out to_chat as well as determine stun duration
	if(!target.IsKnockdown())
		to_chat(target, SPAN_WARNING("Your muscles seize, making you collapse[trait_check ? ", but your body quickly recovers..." : "!"]"))

	if(trait_check)
		target.Knockdown(stun_time * 0.1)
	else
		target.Knockdown(stun_time)

/obj/item/melee/baton/emp_act(severity)
	. = ..()
	if (!(. & EMP_PROTECT_SELF))
		deductcharge(1000 / severity)

/obj/item/melee/baton/proc/shields_blocked(mob/living/L, mob/user)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(H.check_shields(src, 0, "[user]'s [name]", MELEE_ATTACK)) //No message; check_shields() handles that
			playsound(H, 'sound/weapons/genhit.ogg', 50, TRUE)
			return TRUE
	return FALSE

//Makeshift stun baton. Replacement for stun gloves.
/obj/item/melee/baton/cattleprod
	name = "stunprod"
	desc = "An improvised stun baton. Left click to stun, right click to harm."
	icon_state = "stunprod"
	inhand_icon_state = "prod"
	worn_icon_state = null
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	force = 3
	throwforce = 5
	stun_time = 5 SECONDS
	cell_hit_cost = 2000
	throw_stun_chance = 10
	slot_flags = ITEM_SLOT_BACK
	convertible = FALSE
	var/obj/item/assembly/igniter/sparkler = 0

/obj/item/melee/baton/cattleprod/Initialize()
	. = ..()
	sparkler = new (src)

/obj/item/melee/baton/cattleprod/baton_effect()
	if(sparkler.activate())
		..()

/obj/item/melee/baton/cattleprod/Destroy()
	if(sparkler)
		QDEL_NULL(sparkler)
	return ..()

/obj/item/melee/baton/boomerang
	name = "\improper OZtek Boomerang"
	desc = "A device invented in 2486 for the great Space Emu War by the confederacy of Australicus, these high-tech boomerangs also work exceptionally well at stunning crewmembers. Just be careful to catch it when thrown!"
	throw_speed = 1
	icon_state = "boomerang"
	inhand_icon_state = "boomerang"
	force = 5
	throwforce = 5
	throw_range = 5
	cell_hit_cost = 2000
	throw_stun_chance = 99  //Have you prayed today?
	convertible = FALSE
	custom_materials = list(/datum/material/iron = 10000, /datum/material/glass = 4000, /datum/material/silver = 10000, /datum/material/gold = 2000)

/obj/item/melee/baton/boomerang/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force, gentle = FALSE, quickstart = TRUE)
	if(turned_on)
		if(ishuman(thrower))
			var/mob/living/carbon/human/H = thrower
			H.throw_mode_off(THROW_MODE_TOGGLE) //so they can catch it on the return.
	return ..()

/obj/item/melee/baton/boomerang/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(turned_on)
		var/caught = hit_atom.hitby(src, FALSE, FALSE, throwingdatum=throwingdatum)
		if(isliving(hit_atom) && !iscyborg(hit_atom) && !caught && prob(throw_stun_chance))//if they are a living creature and they didn't catch it
			baton_effect(hit_atom)
		var/mob/thrown_by = thrownby?.resolve()
		if(thrown_by && !caught)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/atom/movable, throw_at), thrown_by, throw_range+2, throw_speed, null, TRUE), 1)
	else
		return ..()

/obj/item/melee/baton/boomerang/loaded //Same as above, comes with a cell.
	preload_cell_type = /obj/item/stock_parts/cell/high
