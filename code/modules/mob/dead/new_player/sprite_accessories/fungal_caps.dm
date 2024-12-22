////////////////////////////
// MutantCaps Definitions //
////////////////////////////

/datum/sprite_accessory/caps
	recommended_species = list("mush", "diona")
	icon = 'icons/mob/sprite_accessory/mushroom_caps.dmi'
	color_src = HAIR
	key = "caps"
	generic = "Fungal Cap"

/datum/sprite_accessory/caps/none
	name = "None"
	icon_state = "None"
	factual = FALSE

/datum/sprite_accessory/caps/round
	name = "Round"
	icon_state = "round"
	relevent_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/caps/diona
	color_src = null
	relevent_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/caps/diona/mellowcap
	name = "Mellow Cap"
	icon_state = "mellowcap"

/datum/sprite_accessory/caps/diona/redcap
	name = "Red Cap"
	icon_state = "redcap"

/datum/sprite_accessory/caps/diona/purplecap
	name = "Purple Cap"
	icon_state = "purplecap"
