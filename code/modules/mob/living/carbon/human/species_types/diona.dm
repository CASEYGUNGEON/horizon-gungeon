/datum/species/diona
	name = "Diona"
	id = "diona"
	flavor_text = "The Dionae are plant-like creatures made up of a gestalt colony of smaller Nymphs. As a gestalt entity, \
	each nymph possesses an individual personality, yet they communicate collectively. Consequently, a Diona will often \
	speak in a unique blend of first and third person, using 'We' and 'I' to reflect their internal dialogue."
	sexes = FALSE // dionae are collectives, there are a multitude of nymphs with their own biological sexes in each
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | ERT_SPAWN | SLIME_EXTRACT
	var/pod = FALSE //did they come from a pod? If so, they're stronger than normal Diona.

	inherent_biotypes = MOB_ORGANIC | MOB_HUMANOID | MOB_PLANT
	inherent_traits   = list(
		TRAIT_CAN_STRIP,
		TRAIT_RADIMMUNE,
		TRAIT_VIRUSIMMUNE,
		TRAIT_STABLEHEART,
		TRAIT_LIMBATTACHMENT,
		TRAIT_NO_HUSK,
	)
	species_traits = list(
		AGENDER,
		HAIR, // only hair/diona
		FACEHAIR, // only diona
		LIPS,
		HAS_FLESH,
		MUTCOLORS_PARTSONLY,
		DRINKSBLOOD, // nymphs need it to grow, so technically dionae can too
		NOBLOODOVERLAY, // dionae absorb blood that gets on their hands or feet
	)
	fixed_mut_color = "000"
	default_mutant_bodyparts = list(
		"eyes" = ACC_RANDOM,
		"caps" = ACC_NONE,
	)
	mutantliver	   = /obj/item/organ/liver/diona
	mutantlungs	   = /obj/item/organ/lungs/diona
	mutantheart	   = /obj/item/organ/heart/diona
	mutanteyes	   = /obj/item/organ/eyes/night_vision/diona //Default darksight of 2.
	mutanttongue   = /obj/item/organ/tongue/diona
	mutantbrain    = /obj/item/organ/brain/diona
	mutantappendix = /obj/item/organ/appendix/diona
	mutant_organs  = list(
		/obj/item/organ/eyes/night_vision/diona/alt,
		/obj/item/organ/eyes/night_vision/diona/alt/alt,
		/obj/item/organ/heart/diona/alt,
		/obj/item/organ/tongue/diona/alt,
	)
	mutant_bodyparts  = list()
	bodypart_overides = list(
		BODY_ZONE_HEAD  = /obj/item/bodypart/head/diona,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/diona,
		BODY_ZONE_L_ARM = /obj/item/bodypart/l_arm/diona,
		BODY_ZONE_R_ARM = /obj/item/bodypart/r_arm/diona,
		BODY_ZONE_L_LEG = /obj/item/bodypart/l_leg/diona,
		BODY_ZONE_R_LEG = /obj/item/bodypart/r_leg/diona,
	)
	bodytype = BODYTYPE_DIONA
	meat = /obj/item/food/meat/slab/human/mutant/plant
	skinned_type = /obj/item/stack/sheet/mineral/wood
	exotic_blood = /datum/reagent/medicine/salglu_solution
	exotic_bloodtype = "D"
	breathid   = "co2" // plants breathe co2!
	limbs_icon = 'icons/mob/species/diona_parts.dmi'
	eyes_icon  = 'icons/mob/species/diona_eyes.dmi'
	always_customizable = TRUE
	brutemod = 0.9
	burnmod  = 1.25
	heatmod  = 1.5
	speedmod = 1.2
	scream_sounds = list(
		NEUTER = 'sound/voice/scream_diona.ogg',
	)

	cultures  = list(CULTURES_GENERIC, CULTURES_HUMAN, CULTURES_PLANT)
	locations = list(LOCATIONS_GENERIC, LOCATIONS_HUMAN, LOCATIONS_PLANT)
	factions  = list(FACTIONS_GENERIC, FACTIONS_HUMAN, FACTIONS_PLANT)
	species_language_holder = /datum/language_holder/plant
	say_mod = "oscillates"
	liked_food = VEGETABLES | FRUIT | GRAIN
	disliked_food = ALCOHOL
	toxic_food = MEAT

	//ass_image = "icons/ass/assdiona.png"

/*
 *	TODO:
 *	 note - not all of this is currently possible in this codebase, so it is shelved here.
 *  name_plural = "Dionae"
 *	max_age = 300
 *	flesh_color = "#907E4A"
 *	blood_color = "#004400"
 *	remains_type = /obj/effect/decal/cleanable/ash
 */

/datum/species/diona/random_name(gender,unique,lastname)
	if(unique)
		return random_unique_diona_name()

	var/randname = diona_name()
	return randname

/datum/species/diona/can_understand(mob/other)
	if(isnymph(other))
		return TRUE
	return FALSE

/datum/species/diona/on_species_gain(mob/living/carbon/human/Diona)
	..()
	Diona.gender = NEUTER

/datum/species/diona/on_species_loss(mob/living/carbon/human/Diona)
	. = ..()
	Diona.clear_alert("nolight")

	for(var/mob/living/simple_animal/diona/Nymphs in Diona.contents) // Let nymphs wiggle out
		Nymphs.split()

/datum/species/diona/handle_chemicals(datum/reagent/chem, mob/living/carbon/human/Diona, delta_time, times_fired)
	if(chem.type == /datum/reagent/toxin/plantbgone || chem.type == /datum/reagent/toxin/plantbgone/weedkiller)
		Diona.adjustToxLoss(3 * REAGENTS_EFFECT_MULTIPLIER * delta_time)
		Diona.reagents.remove_reagent(chem.type, REAGENTS_METABOLISM * delta_time)
		return TRUE

/datum/species/diona/spec_life(mob/living/carbon/human/Diona, delta_time, times_fired)
	if(Diona.stat == DEAD)
		return

	var/light_amount = 0 //how much light there is in the place, affects receiving nutrition and healing
	if(isturf(Diona.loc)) //else, there's considered to be no light
		var/turf/T = Diona.loc
		light_amount = min(1, T.get_lumcount()) - 0.5
		Diona.adjust_nutrition(5 * light_amount * delta_time)
		if(Diona.nutrition > NUTRITION_LEVEL_ALMOST_FULL)
			Diona.set_nutrition(NUTRITION_LEVEL_ALMOST_FULL)
		if(light_amount > 0.2 && !Diona.suiciding || pod == TRUE) //if there's enough light OR this is a podgrown diona, heal
			Diona.heal_overall_damage(0.5 * delta_time, 0.5 * delta_time, 0, BODYPART_ORGANIC)
			Diona.adjustToxLoss(-0.5 * delta_time)
			Diona.adjustOxyLoss(-0.5 * delta_time)

	if(Diona.nutrition < NUTRITION_LEVEL_STARVING + 50)
		Diona.adjustBruteLoss(2)

/datum/species/diona/bullet_act(obj/projectile/P, mob/living/carbon/human/Diona, def_zone)
	if(istype(P, /obj/projectile/energy/floramut))
		P.nodamage = TRUE
		Diona.Stun(1 SECONDS)
		if(prob(80))
			Diona.easy_randmut(NEGATIVE+MINOR_NEGATIVE)
		else
			Diona.easy_randmut(POSITIVE)
		Diona.visible_message("[Diona] writhes for a moment as [Diona.p_their()] nymphs squirm and mutate.", "All of you squirm uncomfortably for a moment as you feel your genes changing.")
	else if(istype(P, /obj/projectile/energy/florayield))
		P.nodamage = TRUE
		var/obj/item/bodypart/organ = Diona.getorgan(check_zone(def_zone))
		if(!organ)
			organ = Diona.getorgan("chest")
		organ.heal_damage(5, 5)
		Diona.visible_message("[Diona] seems invogorated as [P] hits [Diona.p_their()] [organ.name].", "Your [organ.name] greedily absorbs [P].")
	return TRUE

/// Same name and everything; we want the same limitations on them; we just want their regeneration to kick in at all times and them to have special factions
/datum/species/diona/pod
	name = "Podgrown Diona"
	id = "diona_pod"
	pod = TRUE // meets Or condition in spec_life()
	inherent_factions = list(
		"plants",
		"vines",
	)
