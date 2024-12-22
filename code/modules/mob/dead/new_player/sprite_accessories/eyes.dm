/datum/sprite_accessory/eyes
	key = "eyes"
	generic = "Eyes"
	organ_type = /obj/item/organ/eyes
	relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/eyes/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.head && (H.head.flags_inv & HIDEEYES) || (H.wear_mask && (H.wear_mask.flags_inv & HIDEEYES)) || !HD)
		return TRUE
	return FALSE

/datum/sprite_accessory/eyes/diona
	organ_type = /obj/item/organ/eyes/night_vision/diona
	icon = 'icons/mob/species/diona_eyes.dmi'
	icon_state = "blinkinghelmethead"
	color_src = null // no recolor (for now)
	recommended_species = list("diona")
	bodytypes = BODYTYPE_DIONA
	special = TRUE
	relevent_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/eyes/diona/none
	name = "None"
	icon_state = "none"
	factual = FALSE

/datum/sprite_accessory/eyes/diona/monoeye
	name = "Monoptic"
	icon_state = "monoeye"

/datum/sprite_accessory/eyes/diona/helmethead
	name = "Monoptic, Large"
	icon_state = "helmethead"

/datum/sprite_accessory/eyes/diona/blinkinghelmethead
	name = "Monoptic, Large, Blinking"
	icon_state = "blinkinghelmethead"

/datum/sprite_accessory/eyes/diona/eyestalk
	name = "Monoptic Stalk"
	icon_state = "eyestalk"

/datum/sprite_accessory/eyes/diona/periscope
	name = "Periscopic"
	icon_state = "periscope"

/datum/sprite_accessory/eyes/diona/eyebrow
	name = "Wide Field Monoptic"
	icon_state = "eyebrow"

/datum/sprite_accessory/eyes/diona/lopsided
	name = "Lopsided Bioptics"
	icon_state = "lopsided"

/datum/sprite_accessory/eyes/diona/insect
	name = "Insect-ish Optic Cluster"
	icon_state = "insect"

/datum/sprite_accessory/eyes/diona/human
	name = "Human-ish Bioptics"
	icon_state = "human"

/datum/sprite_accessory/eyes/diona/skrell
	name = "Skrell-ish Bioptics"
	icon_state = "skrell"

/datum/sprite_accessory/eyes/diona/trioptics
	name = "Trioptics"
	icon_state = "trioptics"

/datum/sprite_accessory/eyes/diona/trioptics_lopsided
	name = "Asymmetric Trioptics"
	icon_state = "shroom"

/datum/sprite_accessory/eyes/diona/glorp
	name = "Glorp"
	icon_state = "glorp"

/datum/sprite_accessory/eyes/diona/pentoptics
	name = "Pentoptics"
	icon_state = "spinner"

/datum/sprite_accessory/eyes/diona/colony
	name = "Colony"
	icon_state = "sprout"
