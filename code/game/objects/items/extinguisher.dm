/obj/item/extinguisher
	name = "fire extinguisher"
	desc = "A traditional red fire extinguisher."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "fire_extinguisher0"
	inhand_icon_state = "fire_extinguisher"
	hitsound = 'sound/weapons/smash.ogg'
	flags_1 = CONDUCT_1
	throwforce = 10
	w_class = WEIGHT_CLASS_NORMAL
	throw_speed = 2
	throw_range = 7
	force = 10
	custom_materials = list(/datum/material/iron = 90)
	attack_verb_continuous = list("slams", "whacks", "bashes", "thunks", "batters", "bludgeons", "thrashes")
	attack_verb_simple = list("slam", "whack", "bash", "thunk", "batter", "bludgeon", "thrash")
	dog_fashion = /datum/dog_fashion/back
	resistance_flags = FIRE_PROOF
	var/max_water = 50
	var/last_use = 1
	var/chem = /datum/reagent/water
	var/safety = TRUE
	var/refilling = FALSE
	var/tanktype = /obj/structure/reagent_dispensers/watertank
	var/sprite_name = "fire_extinguisher"
	var/power = 5 //Maximum distance launched water will travel
	var/precision = FALSE //By default, turfs picked from a spray are random, set to 1 to make it always have at least one water effect per row
	var/cooling_power = 2 //Sets the cooling_temperature of the water reagent datum inside of the extinguisher when it is refilled
	/// Icon state when inside a tank holder
	var/tank_holder_icon_state = "holder_extinguisher"

/obj/item/extinguisher/mini
	name = "pocket fire extinguisher"
	desc = "A light and compact fibreglass-framed model fire extinguisher."
	icon_state = "miniFE0"
	inhand_icon_state = "miniFE"
	hitsound = null //it is much lighter, after all.
	flags_1 = null //doesn't CONDUCT_1
	throwforce = 2
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	custom_materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	max_water = 30
	sprite_name = "miniFE"
	dog_fashion = null

/obj/item/extinguisher/crafted
	name = "Improvised cooling spray"
	desc = "Spraycan turned coolant dipsenser. Can be sprayed on containers to cool them. Refll using water."
	icon_state = "coolant0"
	inhand_icon_state = "miniFE"
	hitsound = null	//it is much lighter, after all.
	flags_1 = null //doesn't CONDUCT_1
	throwforce = 1
	w_class = WEIGHT_CLASS_SMALL
	force = 3
	custom_materials = list(/datum/material/iron = 50, /datum/material/glass = 40)
	max_water = 30
	sprite_name = "coolant"
	dog_fashion = null
	cooling_power = 1.5
	power = 3

/obj/item/extinguisher/crafted/attack_self(mob/user)
	safety = !safety
	icon_state = "[sprite_name][!safety]"
	to_chat(user, "[safety ? "You remove the straw and put it on the side of the cool canister" : "You insert the straw, readying it for use"].")

/obj/item/extinguisher/proc/refill()
	if(!chem)
		return
	create_reagents(max_water, AMOUNT_VISIBLE)
	reagents.add_reagent(chem, max_water)

/obj/item/extinguisher/Initialize()
	. = ..()
	refill()

/obj/item/extinguisher/ComponentInitialize()
	. = ..()
	if(tank_holder_icon_state)
		AddComponent(/datum/component/container_item/tank_holder, tank_holder_icon_state)

/obj/item/extinguisher/advanced
	name = "advanced fire extinguisher"
	desc = "Used to stop thermonuclear fires from spreading inside your engine."
	icon_state = "foam_extinguisher0"
	inhand_icon_state = "foam_extinguisher"
	tank_holder_icon_state = "holder_foam_extinguisher"
	dog_fashion = null
	chem = /datum/reagent/firefighting_foam
	tanktype = /obj/structure/reagent_dispensers/foamtank
	sprite_name = "foam_extinguisher"
	precision = TRUE

/obj/item/extinguisher/suicide_act(mob/living/carbon/user)
	if (!safety && (reagents.total_volume >= 1))
		user.visible_message(SPAN_SUICIDE("[user] puts the nozzle to [user.p_their()] mouth. It looks like [user.p_theyre()] trying to extinguish the spark of life!"))
		afterattack(user,user)
		return OXYLOSS
	else if (safety && (reagents.total_volume >= 1))
		user.visible_message(SPAN_WARNING("[user] puts the nozzle to [user.p_their()] mouth... The safety's still on!"))
		return SHAME
	else
		user.visible_message(SPAN_WARNING("[user] puts the nozzle to [user.p_their()] mouth... [src] is empty!"))
		return SHAME

/obj/item/extinguisher/attack_self(mob/user)
	safety = !safety
	src.icon_state = "[sprite_name][!safety]"
	to_chat(user, SPAN_INFOPLAIN("The safety is [safety ? "on" : "off"]."))
	return

/obj/item/extinguisher/attack(mob/M, mob/living/user)
	if(!user.combat_mode && !safety) //If we're on help intent and going to spray people, don't bash them.
		return FALSE
	else
		return ..()

/obj/item/extinguisher/attack_obj(obj/O, mob/living/user, params)
	if(AttemptRefill(O, user))
		refilling = TRUE
		return FALSE
	else
		return ..()

/obj/item/extinguisher/examine(mob/user)
	. = ..()
	. += "The safety is [safety ? "on" : "off"]."

	if(reagents.total_volume)
		. += SPAN_NOTICE("Alt-click to empty it.")

/obj/item/extinguisher/proc/AttemptRefill(atom/target, mob/user)
	if(istype(target, tanktype) && target.Adjacent(user))
		if(reagents.total_volume == reagents.maximum_volume)
			to_chat(user, SPAN_WARNING("\The [src] is already full!"))
			return TRUE
		var/obj/structure/reagent_dispensers/W = target //will it work?
		var/transferred = W.reagents.trans_to(src, max_water, transfered_by = user)
		if(transferred > 0)
			to_chat(user, SPAN_NOTICE("\The [src] has been refilled by [transferred] units."))
			playsound(src.loc, 'sound/effects/refill.ogg', 50, TRUE, -6)
			for(var/datum/reagent/water/R in reagents.reagent_list)
				R.cooling_temperature = cooling_power
		else
			to_chat(user, SPAN_WARNING("\The [W] is empty!"))
		return TRUE
	else
		return FALSE

/obj/item/extinguisher/afterattack(atom/target, mob/user , flag)
	. = ..()
	// Make it so the extinguisher doesn't spray yourself when you click your inventory items
	if (target.loc == user)
		return
	//TODO; Add support for reagents in water.

	if(refilling)
		refilling = FALSE
		return
	if (!safety)


		if (src.reagents.total_volume < 1)
			to_chat(usr, SPAN_WARNING("\The [src] is empty!"))
			return

		if (world.time < src.last_use + 12)
			return

		src.last_use = world.time

		playsound(src.loc, 'sound/effects/extinguish.ogg', 75, TRUE, -3)

		var/direction = get_dir(src,target)

		if(user.buckled && isobj(user.buckled) && !user.buckled.anchored)
			var/obj/B = user.buckled
			var/movementdirection = turn(direction,180)
			addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/extinguisher, move_chair), B, movementdirection), 1)

		else user.newtonian_move(turn(direction, 180))

		//Get all the turfs that can be shot at
		var/turf/T = get_turf(target)
		var/turf/T1 = get_step(T,turn(direction, 90))
		var/turf/T2 = get_step(T,turn(direction, -90))
		var/list/the_targets = list(T,T1,T2)
		if(precision)
			var/turf/T3 = get_step(T1, turn(direction, 90))
			var/turf/T4 = get_step(T2,turn(direction, -90))
			the_targets.Add(T3,T4)

		var/list/water_particles=list()
		for(var/a=0, a<5, a++)
			var/obj/effect/particle_effect/water/W = new /obj/effect/particle_effect/water(get_turf(src))
			var/my_target = pick(the_targets)
			water_particles[W] = my_target
			// If precise, remove turf from targets so it won't be picked more than once
			if(precision)
				the_targets -= my_target
			var/datum/reagents/R = new/datum/reagents(5)
			W.reagents = R
			R.my_atom = W
			reagents.trans_to(W,1, transfered_by = user)

		//Make em move dat ass, hun
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/extinguisher, move_particles), water_particles), 2)

//Particle movement loop
/obj/item/extinguisher/proc/move_particles(list/particles, repetition=0)
	//Check if there's anything in here first
	if(!particles || particles.len == 0)
		return
	// Second loop: Get all the water particles and make them move to their target
	for(var/obj/effect/particle_effect/water/W in particles)
		var/turf/my_target = particles[W]
		if(!W)
			continue
		step_towards(W,my_target)
		if(!W.reagents)
			continue
		W.reagents.expose(get_turf(W))
		for(var/A in get_turf(W))
			W.reagents.expose(A)
		if(W.loc == my_target)
			particles -= W
	if(repetition < power)
		repetition++
		addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/extinguisher, move_particles), particles, repetition), 2)

//Chair movement loop
/obj/item/extinguisher/proc/move_chair(obj/B, movementdirection, repetition=0)
	step(B, movementdirection)

	var/timer_seconds
	switch(repetition)
		if(0 to 2)
			timer_seconds = 1
		if(3 to 4)
			timer_seconds = 2
		if(5 to 8)
			timer_seconds = 3
		else
			return

	repetition++
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/item/extinguisher, move_chair), B, movementdirection, repetition), timer_seconds)

/obj/item/extinguisher/AltClick(mob/user)
	if(!user.canUseTopic(src, BE_CLOSE, NO_DEXTERITY, FALSE, TRUE))
		return
	if(!user.is_holding(src))
		to_chat(user, SPAN_NOTICE("You must be holding the [src] in your hands do this!"))
		return
	EmptyExtinguisher(user)

/obj/item/extinguisher/proc/EmptyExtinguisher(mob/user)
	if(loc == user && reagents.total_volume)
		reagents.clear_reagents()

		var/turf/T = get_turf(loc)
		if(isopenturf(T))
			var/turf/open/theturf = T
			theturf.MakeSlippery(TURF_WET_WATER, min_wet_time = 10 SECONDS, wet_time_to_add = 5 SECONDS)

		user.visible_message(SPAN_NOTICE("[user] empties out \the [src] onto the floor using the release valve."), SPAN_INFO("You quietly empty out \the [src] using its release valve."))

//firebot assembly
/obj/item/extinguisher/attackby(obj/O, mob/user, params)
	if(istype(O, /obj/item/bodypart/l_arm/robot) || istype(O, /obj/item/bodypart/r_arm/robot))
		to_chat(user, SPAN_NOTICE("You add [O] to [src]."))
		qdel(O)
		qdel(src)
		user.put_in_hands(new /obj/item/bot_assembly/firebot)
	else
		..()
