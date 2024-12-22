/datum/sprite_accessory/headtails
	icon = 'icons/mob/sprite_accessory/headtails.dmi'
	generic = "Skrell Headtails"
	key = "headtails"
	color_src = USE_ONE_COLOR
	relevent_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/headtails/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.head && (H.head.flags_inv & HIDEHAIR) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEHAIR)))
		return TRUE
	return FALSE

/datum/sprite_accessory/headtails/long
	name = "Female"
	icon_state = "long"

/datum/sprite_accessory/headtails/short
	name = "Male"
	icon_state = "short"
