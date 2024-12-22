/************************************
 ************* Antennae *************
 ***********************************/

/datum/sprite_accessory/antennae
	icon = null
	color_src = null
	recommended_species = list("synthetic", "insect", "moth")
	key = "antennae"
	generic = "Antennae"
	relevent_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/antenna/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)) || !HD)
		return TRUE
	return FALSE

/datum/sprite_accessory/antennae/none
	name = "None"
	icon_state = "None"
	recommended_species = null
