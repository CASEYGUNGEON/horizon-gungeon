/datum/species/humanoid
	name = "Humanoid"
	id = "humanoid"
	flavor_text = "A term used for most sentient bipedal creatures, but most often used to classify those more human-like in nature. Genemodders, or humans with body mods, are often labelled as such."
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
	inherent_biotypes = MOB_ORGANIC|MOB_HUMANOID
	default_mutant_bodyparts = list(
		"tail" = ACC_NONE,
		"ears" = ACC_NONE,
		"legs" = "Normal Legs",
		"wings" = ACC_NONE,
		"taur" = ACC_NONE,
		"horns" = ACC_NONE,
		"neck" = ACC_NONE,
	)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | ERT_SPAWN | RACE_SWAP | SLIME_EXTRACT
	limbs_id = "human"
