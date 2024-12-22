/datum/sprite_accessory/snouts
	key = "snout"
	generic = "Snout"
	icon = 'icons/mob/sprite_accessory/snouts.dmi'
	var/use_muzzled_sprites = TRUE
	relevent_layers = list(BODY_ADJ_LAYER, BODY_FRONT_LAYER)

/datum/sprite_accessory/snouts/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if((H.wear_mask && (H.wear_mask.flags_inv & HIDESNOUT)) || (H.head && (H.head.flags_inv & HIDESNOUT)) || !HD)
		return TRUE
	return FALSE

/datum/sprite_accessory/snouts/none
	name = "None"
	icon_state = "none"
	use_muzzled_sprites = FALSE
	factual = FALSE

// One Color

/datum/sprite_accessory/snouts/one
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/snouts/one/anthro
	recommended_species = list("anthromorph")

/datum/sprite_accessory/snouts/one/anthro/avian
	icon = 'icons/mob/sprite_accessory/snouts_avian.dmi'

/datum/sprite_accessory/snouts/one/lizard
	icon = 'icons/mob/sprite_accessory/snouts_lizard.dmi'
	recommended_species = list("lizard", "silverlizard", "unathi", "ashlizard", "anthromorph")

/datum/sprite_accessory/snouts/one/synthetic
	icon = 'icons/mob/sprite_accessory/snouts_synthetic.dmi'
	recommended_species = list("synthetic")
	default_color = null

/datum/sprite_accessory/snouts/one/tajaran
	recommended_species = list("anthromorph", "tajaran")

// Matrix Color

/datum/sprite_accessory/snouts/matrix
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/snouts/matrix/akula
	recommended_species = list("anthromorph", "akula", "aquatic")

/datum/sprite_accessory/snouts/matrix/anthro
	recommended_species = list("anthromorph")

/datum/sprite_accessory/snouts/matrix/anthro/avian
	icon = 'icons/mob/sprite_accessory/snouts_avian.dmi'

/datum/sprite_accessory/snouts/matrix/synthetic
	icon = 'icons/mob/sprite_accessory/snouts_synthetic.dmi'
	recommended_species = list("synthetic")

/datum/sprite_accessory/snouts/matrix/tajaran
	recommended_species = list("anthromorph", "tajaran")

/datum/sprite_accessory/snouts/matrix/vulpkanin
	recommended_species = list("anthromorph", "vulpkanin")

// LIST
/// ALPHABETIZE, DO NOT STICK AT THE END

/datum/sprite_accessory/snouts/matrix/anthro/hanubus
	name = "Anubus"
	icon_state = "hanubus"

/datum/sprite_accessory/snouts/matrix/anthro/avian/bird
	name = "Avian"
	icon_state = "bird"

/datum/sprite_accessory/snouts/matrix/anthro/avian/fbird
	name = "Avian, Top"
	icon_state = "fbird"

/datum/sprite_accessory/snouts/matrix/anthro/avian/bigbeak
	name = "Avian, Big"
	icon_state = "bigbeak"

/datum/sprite_accessory/snouts/matrix/anthro/avian/fbigbeak
	name = "Avian, Big, Top"
	icon_state = "fbigbeak"

/datum/sprite_accessory/snouts/matrix/anthro/avian/bigbeakshort
	name = "Avian, Big, Short"
	icon_state = "bigbeakshort"

/datum/sprite_accessory/snouts/one/anthro/avian/corvid
	name = "Avian, Corvid"
	icon_state = "corvid"

/datum/sprite_accessory/snouts/matrix/anthro/avian/hookbeak
	name = "Avian, Hook"
	icon_state = "hookbeak"

/datum/sprite_accessory/snouts/matrix/anthro/avian/hookbeakbig
	name = "Avian, Hook, Big"
	icon_state = "hookbeakbig"

/datum/sprite_accessory/snouts/matrix/anthro/avian/slimbeak
	name = "Avian, Slim"
	icon_state = "slimbeak"

/datum/sprite_accessory/snouts/matrix/anthro/avian/slimbeakshort
	name = "Avian, Slim, Short"
	icon_state = "slimbeakshort"

/datum/sprite_accessory/snouts/matrix/anthro/avian/slimbeakalt
	name = "Avian, Slim, Alternate"
	icon_state = "slimbeakalt"

/datum/sprite_accessory/snouts/matrix/anthro/avian/toucan
	name = "Avian, Toucan"
	icon_state = "toucan"

/datum/sprite_accessory/snouts/matrix/anthro/avian/ftoucan
	name = "Avian, Toucan, Top"
	icon_state = "ftoucan"

/datum/sprite_accessory/snouts/one/anthro/bug
	name = "Bug"
	icon_state = "bug"
	extra2 = TRUE
	extra2_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/matrix/anthro/elephant
	name = "Elephant"
	icon_state = "elephant"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/matrix/anthro/felephant
	name = "Elephant, Top"
	icon_state = "felephant"
	extra = TRUE
	extra_color_src = MUTCOLORS3

/datum/sprite_accessory/snouts/matrix/anthro/husky
	name = "Husky"
	icon_state = "husky"

/datum/sprite_accessory/snouts/matrix/anthro/fhusky
	name = "Husky, Top"
	icon_state = "fhusky"

/datum/sprite_accessory/snouts/matrix/anthro/rhino
	name = "Horn"
	icon_state = "rhino"
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/snouts/matrix/anthro/frhino
	name = "Horn, Top"
	icon_state = "frhino"
	extra = TRUE
	extra = MUTCOLORS3

/datum/sprite_accessory/snouts/matrix/anthro/hhorse
	name = "Horse"
	icon_state = "hhorse"

/datum/sprite_accessory/snouts/matrix/anthro/hspots
	name = "Hyena"
	icon_state = "hspots"

/datum/sprite_accessory/snouts/matrix/anthro/hjackal
	name = "Jackal"
	icon_state = "hjackal"

/datum/sprite_accessory/snouts/one/lizard/round
	name = "Lizard, Round"
	icon_state = "round"

/datum/sprite_accessory/snouts/one/lizard/fround
	name = "Lizard, Round, Top"
	icon_state = "fround"

/datum/sprite_accessory/snouts/one/lizard/round/light
	name = "Lizard, Round, Light"
	icon_state = "roundlight"

/datum/sprite_accessory/snouts/one/lizard/froundlight
	name = "Lizard, Round, Light, Top"
	icon_state = "froundlight"

/datum/sprite_accessory/snouts/one/lizard/sharp
	name = "Lizard, Sharp"
	icon_state = "sharp"

/datum/sprite_accessory/snouts/one/lizard/fsharp
	name = "Lizard, Sharp, Top"
	icon_state = "fsharp"

/datum/sprite_accessory/snouts/one/lizard/sharp/light
	name = "Lizard, Sharp, Light"
	icon_state = "sharplight"

/datum/sprite_accessory/snouts/one/lizard/fsharplight
	name = "Lizard, Sharp, Light, Top"
	icon_state = "fsharplight"

/datum/sprite_accessory/snouts/one/alienlizard
	name = "Lizard, Strange" 	// near as i can tell, this is a
	icon_state = "alienlizard" 	// Risk of Rain reference, so don't
								// put this in the lizard parent type
/datum/sprite_accessory/snouts/one/alienlizardteeth
	name = "Lizard, Strange, Teeth"
	icon_state = "alienlizardteeth"
	extra = TRUE

/datum/sprite_accessory/snouts/matrix/vulpkanin/lcanid
	name = "Mammal, Long"
	icon_state = "lcanid"

/datum/sprite_accessory/snouts/matrix/vulpkanin/flcanid
	name = "Mammal, Long, Top"
	icon_state = "flcanid"

/datum/sprite_accessory/snouts/matrix/anthro/lcanidalt
	name = "Mammal, Long, Alternate"
	icon_state = "lcanidalt"

/datum/sprite_accessory/snouts/matrix/anthro/flcanidalt
	name = "Mammal, Long, Alternate, Top"
	icon_state = "flcanidalt"

/datum/sprite_accessory/snouts/matrix/vulpkanin/lcanidstriped
	name = "Mammal, Long, Striped"
	icon_state = "lcanidstripe"

/datum/sprite_accessory/snouts/matrix/vulpkanin/flcanidstriped
	name = "Mammal, Long, Striped, Top"
	icon_state = "flcanidstripe"

/datum/sprite_accessory/snouts/matrix/anthro/lcanidstripedalt
	name = "Mammal, Long, Striped, Alternate"
	icon_state = "lcanidstripealt"

/datum/sprite_accessory/snouts/matrix/anthro/flcanidstripedalt
	name = "Mammal, Long, Striped, Alternate, Top"
	icon_state = "flcanidstripealt"

/datum/sprite_accessory/snouts/matrix/tajaran/scanid
	name = "Mammal, Short"
	icon_state = "scanid"

/datum/sprite_accessory/snouts/matrix/tajaran/fscanid
	name = "Mammal, Short, Top"
	icon_state = "fscanid"

/datum/sprite_accessory/snouts/matrix/tajaran/scanidalt
	name = "Mammal, Short, Alternate"
	icon_state = "scanidalt"

/datum/sprite_accessory/snouts/matrix/tajaran/fscanidalt
	name = "Mammal, Short, Alternate, Top"
	icon_state = "fscanidalt"

/datum/sprite_accessory/snouts/matrix/tajaran/scanidalt2
	name = "Mammal, Short, Alternate 2"
	icon_state = "scanidalt2"

/datum/sprite_accessory/snouts/matrix/tajaran/fscanidalt2
	name = "Mammal, Short, Alternate 2, Top"
	icon_state = "fscanidalt2"

/datum/sprite_accessory/snouts/matrix/tajaran/scanidalt3
	name = "Mammal, Short, Alternate 3"
	icon_state = "scanidalt3"

/datum/sprite_accessory/snouts/matrix/tajaran/fscanidalt3
	name = "Mammal, Short, Alternate 3, Top"
	icon_state = "fscanidalt3"

/datum/sprite_accessory/snouts/one/tajaran/normal
	name = "Mammal, Tajaran, Normal"
	icon_state = "ntajaran"

/datum/sprite_accessory/snouts/matrix/anthro/wolf
	name = "Mammal, Thick"
	icon_state = "wolf"

/datum/sprite_accessory/snouts/matrix/anthro/fwolf
	name = "Mammal, Thick, Top"
	icon_state = "fwolf"

/datum/sprite_accessory/snouts/matrix/anthro/wolfalt
	name = "Mammal, Thick, Alternate"
	icon_state = "wolfalt"

/datum/sprite_accessory/snouts/matrix/anthro/fwolfalt
	name = "Mammal, Thick, Alternate, Top"
	icon_state = "fwolfalt"

/datum/sprite_accessory/snouts/matrix/anthro/otie
	name = "Otie"
	icon_state = "otie"

/datum/sprite_accessory/snouts/matrix/anthro/fotie
	name = "Otie, Top"
	icon_state = "fotie"

/datum/sprite_accessory/snouts/matrix/anthro/otiesmile
	name = "Otie, Smile"
	icon_state = "otiesmile"

/datum/sprite_accessory/snouts/matrix/anthro/fotiesmile
	name = "Otie, Smile, Top"
	icon_state = "fotiesmile"

/datum/sprite_accessory/snouts/matrix/anthro/hpanda
	name = "Panda"
	icon_state = "hpanda"

/datum/sprite_accessory/snouts/matrix/synthetic/protogen
	name = "Protogen"
	icon_state = "protogen"

/datum/sprite_accessory/snouts/matrix/synthetic/protogen_frame
	name = "Protogen, Frame"
	icon_state = "protogenframe"

/datum/sprite_accessory/snouts/matrix/synthetic/protogen_bolt
	name = "Protogen, Bolt"
	icon_state = "protogenbolt"

/datum/sprite_accessory/snouts/matrix/rat
	name = "Rat"
	icon_state = "rat"

/datum/sprite_accessory/snouts/matrix/anthro/rodent
	name = "Rodent"
	icon_state = "rodent"

/datum/sprite_accessory/snouts/matrix/anthro/frodent
	name = "Rodent, Top"
	icon_state = "frodent"

/datum/sprite_accessory/snouts/matrix/anthro/pede
	name = "Scolipede"
	icon_state = "pede"

/datum/sprite_accessory/snouts/matrix/anthro/fpede
	name = "Scolipede, Top"
	icon_state = "fpede"

/datum/sprite_accessory/snouts/matrix/anthro/sergal
	name = "Sergal"
	icon_state = "sergal"

/datum/sprite_accessory/snouts/matrix/anthro/fsergal
	name = "Sergal, Top"
	icon_state = "fsergal"

/datum/sprite_accessory/snouts/matrix/akula/shark
	name = "Shark"
	icon_state = "shark"

/datum/sprite_accessory/snouts/matrix/akula/shark_light
	name = "Shark, Light"
	icon_state = "sharkblubber"

/datum/sprite_accessory/snouts/matrix/akula/fshark
	name = "Shark, Top"
	icon_state = "fshark"

/datum/sprite_accessory/snouts/matrix/akula/hshark
	name = "Shark, Alternate"
	icon_state = "hshark"

/datum/sprite_accessory/snouts/matrix/skulldog
	name = "Skulldog"
	icon_state = "skulldog"
	extra = TRUE

/datum/sprite_accessory/snouts/matrix/stubby
	name = "Stubby"
	icon_state = "stubby"
	use_muzzled_sprites = FALSE

/datum/sprite_accessory/snouts/matrix/synthetic/basic
	name = "Synthetic"
	icon_state = "basic"

/datum/sprite_accessory/snouts/matrix/synthetic/visor
	name = "Synthetic, Visor, Under"
	icon_state = "visor"

/datum/sprite_accessory/snouts/matrix/synthetic/long
	name = "Synthetic, Long"
	icon_state = "long"

/datum/sprite_accessory/snouts/matrix/synthetic/longthick
	name = "Synthetic, Long, Thick"
	icon_state = "thicklong"

/datum/sprite_accessory/snouts/matrix/anthro/redpanda
	name = "WahCoon"
	icon_state = "wah"

/datum/sprite_accessory/snouts/matrix/anthro/fredpanda
	name = "WahCoon, Top"
	icon_state = "fwah"

/datum/sprite_accessory/snouts/matrix/anthro/redpandaalt
	name = "WahCoon, Alternate"
	icon_state = "wahalt"

/datum/sprite_accessory/snouts/matrix/anthro/hzebra
	name = "Zebra"
	icon_state = "hzebra"
