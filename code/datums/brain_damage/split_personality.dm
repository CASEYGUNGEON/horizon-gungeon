#define OWNER 0
#define STRANGER 1

/datum/brain_trauma/severe/split_personality
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = "complete lobe separation"
	gain_text = SPAN_WARNING("You feel like your mind was split in two.")
	lose_text = SPAN_NOTICE("You feel alone again.")
	var/current_controller = OWNER
	var/initialized = FALSE //to prevent personalities deleting themselves while we wait for ghosts
	var/mob/living/split_personality/stranger_backseat //there's two so they can swap without overwriting
	var/mob/living/split_personality/owner_backseat

/datum/brain_trauma/severe/split_personality/on_gain()
	var/mob/living/M = owner
	if(M.stat == DEAD || !M.client) //No use assigning people to a corpse or braindead
		qdel(src)
		return
	..()
	make_backseats()
	get_ghost()

/datum/brain_trauma/severe/split_personality/proc/make_backseats()
	stranger_backseat = new(owner, src)
	var/obj/effect/proc_holder/spell/targeted/personality_commune/stranger_spell = new(src)
	stranger_backseat.AddSpell(stranger_spell)

	owner_backseat = new(owner, src)
	var/obj/effect/proc_holder/spell/targeted/personality_commune/owner_spell = new(src)
	owner_backseat.AddSpell(owner_spell)


/datum/brain_trauma/severe/split_personality/proc/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner.real_name]'s split personality?", ROLE_PAI, null, 75, stranger_backseat, POLL_IGNORE_SPLITPERSONALITY)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		stranger_backseat.key = C.key
		log_game("[key_name(stranger_backseat)] became [key_name(owner)]'s split personality.")
		message_admins("[ADMIN_LOOKUPFLW(stranger_backseat)] became [ADMIN_LOOKUPFLW(owner)]'s split personality.")
	else
		qdel(src)

/datum/brain_trauma/severe/split_personality/on_life(delta_time, times_fired)
	if(owner.stat == DEAD)
		if(current_controller != OWNER)
			switch_personalities(TRUE)
		qdel(src)
	else if(DT_PROB(1.5, delta_time))
		switch_personalities()
	..()

/datum/brain_trauma/severe/split_personality/on_lose()
	if(current_controller != OWNER) //it would be funny to cure a guy only to be left with the other personality, but it seems too cruel
		switch_personalities(TRUE)
	QDEL_NULL(stranger_backseat)
	QDEL_NULL(owner_backseat)
	..()

/datum/brain_trauma/severe/split_personality/proc/switch_personalities(reset_to_owner = FALSE)
	if(QDELETED(owner) || QDELETED(stranger_backseat) || QDELETED(owner_backseat))
		return

	var/mob/living/split_personality/current_backseat
	var/mob/living/split_personality/new_backseat
	if(current_controller == STRANGER || reset_to_owner)
		current_backseat = owner_backseat
		new_backseat = stranger_backseat
	else
		current_backseat = stranger_backseat
		new_backseat = owner_backseat

	if(!current_backseat.client) //Make sure we never switch to a logged off mob.
		return

	log_game("[key_name(current_backseat)] assumed control of [key_name(owner)] due to [src]. (Original owner: [current_controller == OWNER ? owner.key : current_backseat.key])")
	to_chat(owner, SPAN_USERDANGER("You feel your control being taken away... your other personality is in charge now!"))
	to_chat(current_backseat, SPAN_USERDANGER("You manage to take control of your body!"))

	//Body to backseat

	var/h2b_id = owner.computer_id
	var/h2b_ip= owner.lastKnownIP
	owner.computer_id = null
	owner.lastKnownIP = null

	new_backseat.ckey = owner.ckey

	new_backseat.name = owner.name

	if(owner.mind)
		new_backseat.mind = owner.mind

	if(!new_backseat.computer_id)
		new_backseat.computer_id = h2b_id

	if(!new_backseat.lastKnownIP)
		new_backseat.lastKnownIP = h2b_ip

	if(reset_to_owner && new_backseat.mind)
		new_backseat.ghostize(FALSE)

	//Backseat to body

	var/s2h_id = current_backseat.computer_id
	var/s2h_ip= current_backseat.lastKnownIP
	current_backseat.computer_id = null
	current_backseat.lastKnownIP = null

	owner.ckey = current_backseat.ckey
	owner.mind = current_backseat.mind

	if(!owner.computer_id)
		owner.computer_id = s2h_id

	if(!owner.lastKnownIP)
		owner.lastKnownIP = s2h_ip

	current_controller = !current_controller


/mob/living/split_personality
	name = "split personality"
	real_name = "unknown conscience"
	var/mob/living/carbon/body
	var/datum/brain_trauma/severe/split_personality/trauma

/mob/living/split_personality/Initialize(mapload, _trauma)
	if(iscarbon(loc))
		body = loc
		name = body.real_name
		real_name = body.real_name
		trauma = _trauma
	return ..()

/mob/living/split_personality/Life(delta_time = SSMOBS_DT, times_fired)
	if(QDELETED(body))
		qdel(src) //in case trauma deletion doesn't already do it

	if((body.stat == DEAD && trauma.owner_backseat == src))
		trauma.switch_personalities()
		qdel(trauma)

	//if one of the two ghosts, the other one stays permanently
	if(!body.client && trauma.initialized)
		trauma.switch_personalities()
		qdel(trauma)

	..()

/mob/living/split_personality/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, SPAN_NOTICE("As a split personality, you cannot do anything but observe. However, you will eventually gain control of your body, switching places with the current personality."))
	to_chat(src, SPAN_WARNING("<b>Do not commit suicide or put the body in a deadly position. Behave like you care about it as much as the owner.</b>"))

/mob/living/split_personality/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	to_chat(src, SPAN_WARNING("You cannot speak, your other self is controlling your body!"))
	return FALSE

/mob/living/split_personality/emote(act, m_type = null, message = null, intentional = FALSE, force_silence = FALSE)
	return FALSE

///////////////BRAINWASHING////////////////////

/datum/brain_trauma/severe/split_personality/brainwashing
	name = "Split Personality"
	desc = "Patient's brain is split into two personalities, which randomly switch control of the body."
	scan_desc = "complete lobe separation"
	gain_text = ""
	lose_text = SPAN_NOTICE("You are free of your brainwashing.")
	can_gain = FALSE
	var/codeword
	var/objective

/datum/brain_trauma/severe/split_personality/brainwashing/New(obj/item/organ/brain/B, _permanent, _codeword, _objective)
	..()
	if(_codeword)
		codeword = _codeword
	else
		codeword = pick(strings("ion_laws.json", "ionabstract")\
			| strings("ion_laws.json", "ionobjects")\
			| strings("ion_laws.json", "ionadjectives")\
			| strings("ion_laws.json", "ionthreats")\
			| strings("ion_laws.json", "ionfood")\
			| strings("ion_laws.json", "iondrinks"))

/datum/brain_trauma/severe/split_personality/brainwashing/on_gain()
	..()
	var/mob/living/split_personality/traitor/traitor_backseat = stranger_backseat
	traitor_backseat.codeword = codeword
	traitor_backseat.objective = objective

/datum/brain_trauma/severe/split_personality/brainwashing/make_backseats()
	stranger_backseat = new /mob/living/split_personality/traitor(owner, src, codeword, objective)
	owner_backseat = new(owner, src)

/datum/brain_trauma/severe/split_personality/brainwashing/get_ghost()
	set waitfor = FALSE
	var/list/mob/dead/observer/candidates = pollCandidatesForMob("Do you want to play as [owner.real_name]'s brainwashed mind?", null, null, 75, stranger_backseat)
	if(LAZYLEN(candidates))
		var/mob/dead/observer/C = pick(candidates)
		stranger_backseat.key = C.key
	else
		qdel(src)

/datum/brain_trauma/severe/split_personality/brainwashing/on_life(delta_time, times_fired)
	return //no random switching

/datum/brain_trauma/severe/split_personality/brainwashing/handle_hearing(datum/source, list/hearing_args)
	if(HAS_TRAIT(owner, TRAIT_DEAF) || owner == hearing_args[HEARING_SPEAKER])
		return
	var/message = hearing_args[HEARING_RAW_MESSAGE]
	if(findtext(message, codeword))
		hearing_args[HEARING_RAW_MESSAGE] = replacetext(message, codeword, SPAN_WARNING("[codeword]"))
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum/brain_trauma/severe/split_personality, switch_personalities)), 10)

/datum/brain_trauma/severe/split_personality/brainwashing/handle_speech(datum/source, list/speech_args)
	if(findtext(speech_args[SPEECH_MESSAGE], codeword))
		speech_args[SPEECH_MESSAGE] = "" //oh hey did you want to tell people about the secret word to bring you back?

/mob/living/split_personality/traitor
	name = "split personality"
	real_name = "unknown conscience"
	var/objective
	var/codeword

/mob/living/split_personality/traitor/Login()
	. = ..()
	if(!. || !client)
		return FALSE
	to_chat(src, SPAN_NOTICE("As a brainwashed personality, you cannot do anything yet but observe. However, you may gain control of your body if you hear the special codeword, switching places with the current personality."))
	to_chat(src, SPAN_NOTICE("Your activation codeword is: <b>[codeword]</b>"))
	if(objective)
		to_chat(src, SPAN_NOTICE("Your master left you an objective: <b>[objective]</b>. Follow it at all costs when in control."))

#undef OWNER
#undef STRANGER
