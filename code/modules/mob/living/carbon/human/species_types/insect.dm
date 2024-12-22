/datum/species/insect
	name = "Anthromorphic Insect"
	id = "insect"
	flavor_text = "A generalized term used for most insectoid species. They don't have any specific diets to note, as they all vary greatly."
	default_color = "444"
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAS_FLESH,
		HAS_BONE,
		HAIR,
		FACEHAIR,
	)
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID|MOB_BUG
	default_mutant_bodyparts = list(
		"tail" 		= ACC_NONE,
		"snout" 	= ACC_NONE,
		"horns" 	= ACC_NONE,
		"ears" 		= ACC_NONE,
		"taur" 		= ACC_NONE,
		"wings" 	= "Bee",
		"antennae" 	= "Insect",
	)
	cultures = list(CULTURES_GENERIC, CULTURES_HUMAN, CULTURES_INSECT)
	locations = list(LOCATIONS_GENERIC, LOCATIONS_HUMAN, LOCATIONS_INSECT)
	factions = list(FACTIONS_GENERIC, FACTIONS_HUMAN, FACTIONS_INSECT)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_icon = 'icons/mob/species/insect_parts_greyscale.dmi'
	eyes_icon = 'icons/mob/species/insect_eyes.dmi'

/datum/species/insect/space_move(mob/living/carbon/human/H)
	. = ..()
	if(H.loc && !isspaceturf(H.loc) && H.dna.features["moth_wings"] != "Burnt Off" && !flying_species) //"flying_species" is exclusive to the potion of flight, which has its flying mechanics. If they want to fly they can use that instead
		var/datum/gas_mixture/current = H.loc.return_air()
		if(current && (current.return_pressure() >= ONE_ATMOSPHERE*0.85)) //as long as there's reasonable pressure and no gravity, flight is possible
			return TRUE

/datum/species/insect/randomize_main_appearance_element(mob/living/carbon/human/human_mob)
	var/wings = pick(GLOB.moth_wings_list)
	mutant_bodyparts["wings"] = wings
	mutant_bodyparts["moth_wings"] = wings
	human_mob.dna.features["wings"] = wings
	human_mob.dna.features["moth_wings"] = wings
	human_mob.update_body()
