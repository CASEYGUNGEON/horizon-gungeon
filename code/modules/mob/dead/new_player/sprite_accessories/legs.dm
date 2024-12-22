////////////////////////////
// MutantLegs Definitions //
////////////////////////////

/datum/sprite_accessory/legs //legs are a special case, they aren't actually sprite_accessories but are updated with them.
	icon = null //These datums exist for selecting legs on preference, and little else
	key = "legs"
	generic = "Leg Type"
	color_src = null

/datum/sprite_accessory/legs/none
	name = "Normal Legs"

/datum/sprite_accessory/legs/digitigrade_lizard
	name = "Digitigrade Legs"
