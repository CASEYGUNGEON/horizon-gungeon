/datum/sprite_accessory/tails
	key = "tail"
	generic = "Tail"
	organ_type = /obj/item/organ/tail
	icon = 'icons/mob/sprite_accessory/tails.dmi'
	special_render_case = TRUE
	special_icon_case = TRUE
	special_colorize = TRUE
	relevent_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	/// A generalisation of the tail-type, e.g. lizard or feline, for hardsuit or other sprites
	var/general_type

/datum/sprite_accessory/tails/get_special_render_state(mob/living/carbon/human/H)
	// Hardsuit tail spriting
	if(general_type && H.wear_suit && istype(H.wear_suit, /obj/item/clothing/suit/space/hardsuit))
		var/obj/item/clothing/suit/space/hardsuit/HS = H.wear_suit
		if(HS.hardsuit_tail_colors)
			return "[general_type]_hardsuit"

	var/obj/item/organ/tail/T = H.getorganslot(ORGAN_SLOT_TAIL)
	if(T && T.wagging)
		return "[icon_state]_wagging"

	return icon_state

/datum/sprite_accessory/tails/get_special_icon(mob/living/carbon/human/H, passed_state)
	var/returned = icon
	if(passed_state == "[general_type]_hardsuit") //Guarantees we're wearing a hardsuit, skip checks
		var/obj/item/clothing/suit/space/hardsuit/HS = H.wear_suit
		if(HS.hardsuit_tail_colors)
			returned = 'icons/mob/sprite_accessory/tails_hardsuit.dmi'
	return returned

/datum/sprite_accessory/tails/get_special_render_colour(mob/living/carbon/human/H, passed_state)
	if(passed_state == "[general_type]_hardsuit") //Guarantees we're wearing a hardsuit, skip checks
		var/obj/item/clothing/suit/space/hardsuit/HS = H.wear_suit
		if(HS.hardsuit_tail_colors)
			//Currently this way, when I have more time I'll write a hex -> matrix converter to pre-bake them instead
			var/list/finished_list = list()
			finished_list += ReadRGB("[HS.hardsuit_tail_colors[1]]0")
			finished_list += ReadRGB("[HS.hardsuit_tail_colors[2]]0")
			finished_list += ReadRGB("[HS.hardsuit_tail_colors[3]]0")
			finished_list += list(0,0,0,255)
			for(var/index in 1 to finished_list.len)
				finished_list[index] /= 255
			return finished_list
	return null

/datum/sprite_accessory/tails/is_hidden(mob/living/carbon/human/H, obj/item/bodypart/HD)
	if(H.wear_suit)
		if(H.try_hide_mutant_parts)
			return TRUE
		if(H.wear_suit.flags_inv & HIDEJUMPSUIT)
			if(istype(H.wear_suit, /obj/item/clothing/suit/space/hardsuit))
				var/obj/item/clothing/suit/space/hardsuit/HS = H.wear_suit
				if(HS.hardsuit_tail_colors)
					return FALSE
			return TRUE
	return FALSE

// NO TAIL
/datum/sprite_accessory/tails/none
	name = "None"
	icon_state = "none"
	recommended_species = list("anthromorph", "human", "felinid", "humanoid", "synthetic", "insect", "aquatic")
	color_src = null
	factual = FALSE

// Human(oid) Category
/datum/sprite_accessory/tails/human
	recommended_species = list("humanoid", "felinid", "anthromorph")
	organ_type = /obj/item/organ/tail/cat

// Mammalian Category
/datum/sprite_accessory/tails/mammal
	icon_state = "none"
	recommended_species = list("anthromorph", "humanoid", "synthetic")
	organ_type = /obj/item/organ/tail/fluffy/no_wag
	color_src = USE_MATRIXED_COLORS

/datum/sprite_accessory/tails/mammal/wagging
	organ_type = /obj/item/organ/tail/fluffy

// Vulpkanin Species Category
/datum/sprite_accessory/tails/mammal/wagging/vulpkanin
	recommended_species = list("anthromorph", "vulpkanin", "humanoid", "synthetic")
	general_type = "vulpine"

// Tajaran Species Category
/datum/sprite_accessory/tails/mammal/wagging/tajaran
	recommended_species = list("anthromorph", "tajaran", "humanoid", "synthetic")
	general_type = "feline"

// Akulan Species Category
/datum/sprite_accessory/tails/mammal/wagging/akula
	recommended_species = list("anthromorph", "akula", "aquatic", "humanoid", "synthetic")
	general_type = "marine"

// Lizard Category
/datum/sprite_accessory/tails/lizard
	recommended_species = list("lizard", "lizard_silver", "lizard_ash", "unathi", "anthromorph", "synthetic")
	organ_type = /obj/item/organ/tail/lizard
	general_type = "lizard"

/datum/sprite_accessory/tails/mammal/wagging/axolotl
	recommended_species = list("anthromorph", "aquatic", "humanoid", "synthetic")
	name = "Aquatic, Axolotl"
	icon_state = "axolotl"
	general_type = "lizard"

/datum/sprite_accessory/tails/mammal/wagging/fish
	recommended_species = list("anthromorph", "aquatic", "humanoid", "synthetic")
	name = "Aquatic, Fish"
	icon_state = "fish"
	general_type = "marine"

/datum/sprite_accessory/tails/mammal/wagging/orca
	recommended_species = list("anthromorph", "aquatic", "humanoid", "synthetic")
	name = "Aquatic, Orca"
	icon_state = "orca"
	general_type = "marine"

/datum/sprite_accessory/tails/mammal/wagging/akula/shark
	name = "Aquatic, Shark"
	icon_state = "shark"
	general_type = "marine"

/datum/sprite_accessory/tails/mammal/wagging/akula/sharknofin
	name = "Aquatic, Shark, Dorsal Finless"
	icon_state = "sharknofin"
	general_type = "marine"

/datum/sprite_accessory/tails/mammal/corvid
	name = "Avian, Corvid"
	icon_state = "crow"
	general_type = "avian"

/datum/sprite_accessory/tails/mammal/hawk
	name = "Avian, Hawk"
	icon_state = "hawk"
	general_type = "avian"

/datum/sprite_accessory/tails/mammal/wagging/batl
	name = "Bat, Long"
	icon_state = "batl"
	general_type = "feline"

/datum/sprite_accessory/tails/mammal/wagging/bats
	name = "Bat, Short"
	icon_state = "bats"
	general_type = "feline"

/datum/sprite_accessory/tails/mammal/wagging/lab
	name = "Canine, Lab"
	icon_state = "lab"

/datum/sprite_accessory/tails/mammal/wagging/husky
	name = "Canine, Husky"
	icon_state = "husky"
	general_type = "shepherdlike"

/datum/sprite_accessory/tails/mammal/wagging/shepherd
	name = "Canine, Shepherd"
	icon_state = "shepherd"
	general_type = "shepherdlike"

/datum/sprite_accessory/tails/mammal/wagging/wolf
	name = "Canine, Wolf"
	icon_state = "wolf"
	color_src = USE_ONE_COLOR
	general_type = "shepherdlike"

/datum/sprite_accessory/tails/mammal/wagging/cow
	name = "Cow"
	icon_state = "cow"

/datum/sprite_accessory/tails/mammal/wagging/deer
	name = "Deer"
	icon_state = "deer"

/datum/sprite_accessory/tails/human/cat
	recommended_species = list("anthromorph", "tajaran", "humanoid", "synthetic")
	name = "Feline"
	icon_state = "cat"
	color_src = HAIR

/datum/sprite_accessory/tails/mammal/wagging/tajaran/catbig
	name = "Feline, Big"
	icon_state = "catbig"
	color_src = USE_ONE_COLOR
	general_type = "feline"

/datum/sprite_accessory/tails/mammal/wagging/tiger
	name = "Feline, Leopard Spot"
	icon_state = "leopard"
	general_type = "feline"

/datum/sprite_accessory/tails/mammal/wagging/tiger
	name = "Feline, Tiger Stripe"
	icon_state = "tiger"
	general_type = "feline"

/datum/sprite_accessory/tails/mammal/wagging/twocat
	recommended_species = list("anthromorph", "tajaran", "humanoid", "synthetic")
	name = "Feline, Twin Tails"
	icon_state = "twocat"

/datum/sprite_accessory/tails/mammal/wagging/eevee
	name = "Fox, Eevee"
	icon_state = "eevee"
	general_type = "vulpine"

/datum/sprite_accessory/tails/mammal/wagging/fennec
	recommended_species = list("anthromorph", "vulpkanin", "humanoid", "synthetic")
	name = "Fox, Fennec"
	icon_state = "fennec"
	general_type = "vulpine"

/datum/sprite_accessory/tails/mammal/wagging/vulpkanin/fox
	name = "Fox"
	icon_state = "fox"
	general_type = "vulpine"

/datum/sprite_accessory/tails/mammal/wagging/vulpkanin/fox2
	name = "Fox, Alternate"
	icon_state = "fox2"
	general_type = "vulpine"

/datum/sprite_accessory/tails/mammal/wagging/kitsune
	name = "Fox, Kitsune"
	icon_state = "kitsune"
	general_type = "vulpine"

/datum/sprite_accessory/tails/mammal/wagging/tamamo_kitsune
	name = "Fox, Kitsune, Tamamo"
	icon_state = "sabresune" //"9sune" is just an inferiorly shaded version of this, could prob be removed

/datum/sprite_accessory/tails/mammal/wagging/lunasune
	name = "Fox, Lunasune"
	icon_state = "lunasune"
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/tails/mammal/horse
	name = "Horse"
	icon_state = "horse"
	color_src = USE_ONE_COLOR
	default_color = HAIR

/datum/sprite_accessory/tails/mammal/wagging/insect
	recommended_species = list("anthromorph", "synthetic", "insect")
	name = "Insect"
	icon_state = "insect"

/datum/sprite_accessory/tails/mammal/wagging/bee
	recommended_species = list("anthromorph", "synthetic", "insect")
	name = "Insect, Bee"
	icon_state = "bee"

/datum/sprite_accessory/tails/mammal/wagging/pede
	name = "Insect, Scolipede"
	icon_state = "pede"

/datum/sprite_accessory/tails/mammal/wagging/kangaroo
	name = "Kangaroo"
	icon_state = "kangaroo"
	general_type = "straighttail"

/*/datum/sprite_accessory/tails/mammal/wagging/dtiger //icon = 'icons/mob/mutant_bodyparts.dmi'
	name = "Dark Tiger"
	icon_state = "dtiger"
	color_src = USE_ONE_COLOR
	default_color = DEFAULT_PRIMARY
*/

/datum/sprite_accessory/tails/lizard/dtiger
	name = "Lizard, Tiger Stripe, Dark"
	icon_state = "dtiger"

/*/datum/sprite_accessory/tails/mammal/wagging/ltiger //icon = 'icons/mob/mutant_bodyparts.dmi'
	name = "Light Tiger"
	icon_state = "ltiger"
	color_src = USE_ONE_COLOR
	default_color = DEFAULT_PRIMARY
*/

/datum/sprite_accessory/tails/lizard/ltiger
	name = "Lizard, Tiger Stripe, Light"
	icon_state = "ltiger"

/datum/sprite_accessory/tails/mammal/wagging/guilmon
	name = "Lizard, Guilmon"
	icon_state = "guilmon"
	general_type = "lizard"

/datum/sprite_accessory/tails/lizard/smooth
	name = "Lizard, Smooth"
	icon_state = "smooth"

/datum/sprite_accessory/tails/lizard/spikes
	name = "Lizard, Spikes"
	icon_state = "spikes"

/datum/sprite_accessory/tails/monkey/default
	recommended_species = list("humanoid", "anthromorph", "monkey")
	name = "Monkey"
	icon_state = "monkey"
	color_src = FALSE
	organ_type = /obj/item/organ/tail/monkey

/datum/sprite_accessory/tails/mammal/wagging/murid
	name = "Murid"
	icon_state = "murid"

/datum/sprite_accessory/tails/mammal/wagging/otie
	name = "Otusian"
	icon_state = "otie"
	general_type = "straighttail"

/datum/sprite_accessory/tails/mammal/wagging/rabbit
	name = "Rabbit"
	icon_state = "rabbit"

/datum/sprite_accessory/tails/mammal/raptor
	name = "Raptor"
	icon_state = "raptor"

/datum/sprite_accessory/tails/mammal/wagging/ailurus
	name = "Red Panda"
	icon_state = "wah"
	extra = TRUE

/datum/sprite_accessory/tails/mammal/wagging/sergal
	name = "Sergal"
	icon_state = "sergal"
	general_type = "shepherdlike"

/datum/sprite_accessory/tails/mammal/wagging/skunk
	name = "Skunk"
	icon_state = "skunk"
	general_type = "vulpine"

/datum/sprite_accessory/tails/mammal/wagging/squirrel
	name = "Squirrel"
	icon_state = "squirrel"
	color_src = USE_ONE_COLOR

/datum/sprite_accessory/tails/mammal/wagging/stripe
	name = "Striped"
	icon_state = "stripe"

/datum/sprite_accessory/tails/mammal/wagging/straighttail
	name = "Straight"
	icon_state = "straighttail"
	general_type = "straighttail"

/datum/sprite_accessory/tails/mammal/spade
	name = "Succubus Spade"
	icon_state = "spade"

/datum/sprite_accessory/tails/mammal/wagging/tentacle
	recommended_species = list("anthromorph", "aquatic", "humanoid", "synthetic", "jelly", "jelly_slime", "slimeperson", "jelly_luminescent", "jelly_stargazer")
	name = "Tentacles"
	icon_state = "tentacle"

// Synthetic tails

/datum/sprite_accessory/tails/synthliz
	recommended_species = list("synthetic")
	icon = 'icons/mob/sprite_accessory/tails_synthetic.dmi'
	color_src = USE_ONE_COLOR
	name = "Synthetic Lizard"
	icon_state = "synthliz"
	general_type = "lizard"

// Teshari tails

/datum/sprite_accessory/tails/mammal/teshari
	icon = 'icons/mob/sprite_accessory/tails_teshari.dmi'
	recommended_species = list("teshari")
	general_type = "teshari"
	bodytypes = BODYTYPE_TESHARI

/datum/sprite_accessory/tails/mammal/teshari/default
	name = "Teshari Default Tail"
	icon_state = "teshari_default"

/datum/sprite_accessory/tails/mammal/teshari/fluffy
	name = "Teshari Fluffy Tail"
	icon_state = "teshari_fluffy"

/datum/sprite_accessory/tails/mammal/teshari/thin
	name = "Teshari Thin Tail"
	icon_state = "teshari_thin"
