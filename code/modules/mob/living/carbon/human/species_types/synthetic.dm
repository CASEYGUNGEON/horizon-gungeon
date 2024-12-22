/datum/species/synthetic
	name = "Synthetic"
	id = "synthetic"
	flavor_text = "A synthetic lifeform. Most sport a screen, instead of a humanoid face. Surface level damage is easy to repair, but they're sensitive to electronic disruptions."
	say_mod = "beeps"
	default_color = "0F0"
	inherent_biotypes = MOB_ROBOTIC|MOB_HUMANOID
	inherent_traits = list(
		TRAIT_ADVANCEDTOOLUSER,
		TRAIT_CAN_STRIP,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_NOCLONELOSS,
		TRAIT_GENELESS,
		TRAIT_STABLEHEART,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NO_HUSK,
		TRAIT_OXYIMMUNE,
	)
	species_traits = list(
		ROBOTIC_DNA_ORGANS,
		MUTCOLORS_PARTSONLY,
		EYECOLOR,
		LIPS,
		HAIR,
		ROBOTIC_LIMBS,
		NOTRANSSTING,
		REVIVES_BY_HEALING,
	)
	cultures = list(CULTURES_GENERIC, CULTURES_HUMAN, CULTURES_SYNTHETIC)
	locations = list(LOCATIONS_GENERIC, LOCATIONS_HUMAN, LOCATIONS_SYNTHETIC)
	factions = list(FACTIONS_GENERIC, FACTIONS_HUMAN, FACTIONS_SYNTHETIC)
	mutant_bodyparts = list()
	default_mutant_bodyparts = list(
		"antennaa" 		= ACC_RANDOM,
		"ipc_screen" 	= ACC_RANDOM,
		"chassis" 		= ACC_RANDOM,
		"legs"  		= ACC_RANDOM,
		"tail" 			= ACC_NONE, // As machines, these guys can bolt on whatever they want. Unified robotic species!
		"snout" 		= ACC_NONE,
		"taur" 			= ACC_NONE,
		"horns" 		= ACC_NONE,
		"ears" 			= ACC_NONE,
		"wings" 		= ACC_NONE,
		"neck" 			= ACC_NONE,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon = 'icons/mob/species/synthetic_parts.dmi'
	hair_alpha = 210 // TODO: MAKE THIS CHANGEABLE
	sexes = FALSE
	var/datum/action/innate/monitor_change/screen
	var/saved_screen = "Blank"
	var/datum/action/innate/bootsound_change/sound
	var/saved_bootsound = 'sound/machines/chime.ogg'
	reagent_flags = PROCESS_SYNTHETIC
	coldmod = 0.5
	burnmod = 1.1
	heatmod = 1.2
	brutemod = 1.1
	siemens_coeff = 1.2 //Not more because some shocks will outright crit you, which is very unfun
	mutant_organs = list(/obj/item/organ/cyberimp/arm/power_cord)
	mutantbrain   = /obj/item/organ/brain/ipc_positron
	mutantstomach = /obj/item/organ/stomach/robot_ipc
	mutantears    = /obj/item/organ/ears/robot_ipc
	mutanttongue  = /obj/item/organ/tongue/robot_ipc
	mutanteyes    = /obj/item/organ/eyes/robot_ipc
	mutantlungs   = /obj/item/organ/lungs/robot_ipc
	mutantheart   = /obj/item/organ/heart/robot_ipc
	mutantliver   = /obj/item/organ/liver/robot_ipc
	exotic_blood  = /datum/reagent/fuel/oil
	scream_sounds = list(
		NEUTER    = 'sound/voice/scream_silicon.ogg',
	)
	species_descriptors = list(
		/datum/descriptor/age/robot
	)

// Name generator
/* Don't you want to get your own special name?
 */
/datum/species/synthetic/random_name(gender,unique,lastname)
	var/randname = pick(GLOB.posibrain_names)
	randname = "[randname]-[rand(100, 99999)]"
	return randname

// Mortal machinery datum
/*
 * Otherwise known as a Salt PR, this feature permits IPCs to die if alive and in soft crit
 * No one is sure if the salt comes from the redtexted antag or the IPC player condemned to
 * purgatory when medical doesn't know they've gone missing.
 */
/datum/species/synthetic/spec_life(mob/living/carbon/human/H)
	// Deal damage when we're in crit because otherwise synthetics can't die (immune to oxyloss)
	if(H.stat == SOFT_CRIT || H.stat == HARD_CRIT)
		H.adjustFireLoss(1)
		if(prob(10))
			to_chat(H, SPAN_WARNING("Alert: Critical damage taken! Cooling systems failing!"))
			do_sparks(3, TRUE, H)

// Revival datums
/*
 * Hello world!
 */
/datum/species/synthetic/spec_revival(mob/living/carbon/human/H)
	. = ..()
	H.dna.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME] = "BSOD"
	to_chat(H, SPAN_DANGER("You are booting up..."))
	H.Unconscious(rand(15, 45))
	playsound(H.loc, 'sound/machines/chime.ogg', 50, 1, -1)
	H.visible_message(SPAN_WARNING("[H]'s indicator lights flicker."), SPAN_NOTICE("All systems nominal. You're back online!"))
	//TODO: fix this
	H.dna.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME] = saved_screen

// Appendix Removotron 8300
/*
 * Appendix Inspection Day is now in effect
 * Conveniently also bestows our screen and chassis. How kind!
 */
/datum/species/synthetic/on_species_gain(mob/living/carbon/human/C)
	. = ..()
	if(!screen)
		screen = new
		screen.Grant(C)
	var/chassis = C.dna.mutant_bodyparts["chassis"]
	if(!chassis)
		return
	var/datum/sprite_accessory/chassis/chassis_of_choice = GLOB.sprite_accessories["chassis"][chassis[MUTANT_INDEX_NAME]]
	if(chassis_of_choice)
		limbs_id = chassis_of_choice.icon_state
		if(chassis_of_choice.color_src)
			species_traits += MUTCOLORS
		C.update_body()
	var/obj/item/organ/appendix/appendix = C.getorganslot(ORGAN_SLOT_APPENDIX)
	if(appendix)
		appendix.Remove(C)
		qdel(appendix)

// Screen removal datum
/*
 * Removes IPC screen in the event species changes
 */
/datum/species/synthetic/on_species_loss(mob/living/carbon/human/C)
	. = ..()
	if(screen)
		screen.Remove(C)
	..()

// Screen removal during gib
/*
 * We would not want our screen to persist afterwards now would we?
 */
/datum/species/synthetic/spec_death(gibbed, mob/living/carbon/human/H)
	. = ..()
	saved_screen = H.dna.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME]
	//TODO: fix this
	H.dna.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME] = "BSOD"
	sleep(30)
	H.dna.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME] = "Blank"



// Monitor Change action
/*
 * Lets us change our screensaver
 */
/datum/action/innate/monitor_change
	name = "Screen Change"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "drone_vision"

/datum/action/innate/monitor_change/Activate()
	var/mob/living/carbon/human/H = owner
	var/new_ipc_screen = input(usr, "Choose screen:", "Screen Display") as null|anything in GLOB.sprite_accessories["ipc_screen"]
	if(!new_ipc_screen)
		return
	H.dna.species.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME] = new_ipc_screen
	H.update_body()

// Bootup Sound Change action
/*
 * Lets us pick our bootup sound
 */
/datum/action/innate/bootsound_change
	name = "Boot-Up Sound Change"
	check_flags = AB_CHECK_CONSCIOUS
	icon_icon = 'icons/mob/actions/actions_silicon.dmi'
	button_icon_state = "monkey_up" // TODO: SOUND ICON

/datum/action/innate/bootsound_change/Activate()
	var/mob/living/carbon/human/H = owner
	var/new_ipc_boot_sound = input(usr, "Choose boot-up sound:", "Sound Library") as null|anything in GLOB.sprite_accessories["ipc_screen"]
	if(!new_ipc_boot_sound)
		return
	H.dna.species.mutant_bodyparts["ipc_screen"][MUTANT_INDEX_NAME] = new_ipc_boot_sound
	H.update_body()

/datum/species/synthetic/get_random_body_markings(list/passed_features)
	var/name = pick("Synth Pecs Lights", "Synth Scutes", "Synth Pecs")
	var/datum/body_marking_set/BMS = GLOB.body_marking_sets[name]
	var/list/markings = list()
	if(BMS)
		markings = assemble_body_markings_from_set(BMS, passed_features, src)
	return markings

// Somewhat of a paste from the mammal's random features, because they're supposed to mimick them in appearance.
/datum/species/synthetic/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/second_color
	var/third_color
	var/random = rand(1,6)
	switch(random)
		if(1)
			main_color = "FFFFFF"
			second_color = "333333"
			third_color = "333333"
		if(2)
			main_color = "FFFFDD"
			second_color = "DD6611"
			third_color = "AA5522"
		if(3)
			main_color = "DD6611"
			second_color = "FFFFFF"
			third_color = "DD6611"
		if(4)
			main_color = "CCCCCC"
			second_color = "FFFFFF"
			third_color = "FFFFFF"
		if(5)
			main_color = "AA5522"
			second_color = "CC8833"
			third_color = "FFFFFF"
		if(6)
			main_color = "FFFFDD"
			second_color = "FFEECC"
			third_color = "FFDDBB"
	returned["mcolor"] = main_color
	returned["mcolor2"] = second_color
	returned["mcolor3"] = third_color
	return returned
