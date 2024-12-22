/datum/species/skrell
	name = "Skrell"
	id = "skrell"
	flavor_text = "A species often found near large or reliable water sources, \
	Skrell have a sensitive immune system dependent upon their skin retaining \
	moisture. Their headtails are loosely prehensile, and can hold objects for \
	extended periods of time. Their neurons possess a unique insulator, making \
	their thoughts slightly more efficient than most other sapient species; this \
	makes them excellent negotiatiors, tacticians, and mathematicians. They \
	possess a curious affinity for sugary foods and the pineapple; they cannot \
	handle alcohol, or a heavily meat diet."
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT

	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	species_traits = list(
		MUTCOLORS,
		EYECOLOR,
		LIPS,
		HAS_FLESH,
		HAS_BONE,
	)
	default_color = "444"
	default_mutant_bodyparts = list(
		"headtails" = ACC_RANDOM,
	)
	bodytype = BODYTYPE_SKRELL
	limbs_icon = 'icons/mob/species/skrell_parts_greyscale.dmi'
	eyes_icon = 'icons/mob/species/skrell_eyes.dmi'

	cultures = list(CULTURES_GENERIC, CULTURES_HUMAN, CULTURES_AQUATIC)
	locations = list(LOCATIONS_GENERIC, LOCATIONS_HUMAN, LOCATIONS_AQUATIC)
	factions = list(FACTIONS_GENERIC, FACTIONS_HUMAN, FACTIONS_AQUATIC)
	say_mod = "bubbles"
	liked_food = PINEAPPLE | SUGAR
	disliked_food = ALCOHOL | MEAT

/datum/species/skrell/get_random_features()
	var/list/returned = MANDATORY_FEATURE_LIST
	var/main_color
	var/random = rand(1,6)
	//Choose from a range of green-blue colors
	switch(random)
		if(1)
			main_color = "44FF77"
		if(2)
			main_color = "22FF88"
		if(3)
			main_color = "22FFBB"
		if(4)
			main_color = "22FFFF"
		if(5)
			main_color = "22BBFF"
		if(6)
			main_color = "2266FF"
	returned["mcolor"] = main_color
	returned["mcolor2"] = main_color
	returned["mcolor3"] = main_color
	return returned
