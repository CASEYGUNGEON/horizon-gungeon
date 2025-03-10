/obj/machinery/meter
	name = "gas flow meter"
	desc = "It measures something."
	icon = 'icons/obj/atmospherics/pipes/meter.dmi'
	icon_state = "meterX"
	layer = HIGH_PIPE_LAYER
	power_channel = AREA_USAGE_ENVIRON
	use_power = IDLE_POWER_USE
	idle_power_usage = 2
	active_power_usage = 4
	max_integrity = 150
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 100, BOMB = 0, BIO = 100, RAD = 100, FIRE = 40, ACID = 0)
	var/frequency = 0
	var/atom/target
	var/target_layer = PIPING_LAYER_DEFAULT

/obj/machinery/meter/atmos
	frequency = FREQ_ATMOS_STORAGE

/obj/machinery/meter/atmos/layer2
	target_layer = 2

/obj/machinery/meter/atmos/layer4
	target_layer = 4

/obj/machinery/meter/atmos/atmos_waste_loop
	name = "waste loop gas flow meter"
	id_tag = ATMOS_GAS_MONITOR_LOOP_ATMOS_WASTE

/obj/machinery/meter/atmos/distro_loop
	name = "distribution loop gas flow meter"
	id_tag = ATMOS_GAS_MONITOR_LOOP_DISTRIBUTION

/obj/machinery/meter/Destroy()
	SSair.stop_processing_machine(src)
	target = null
	return ..()

/obj/machinery/meter/Initialize(mapload, new_piping_layer)
	. = ..()
	if(!isnull(new_piping_layer))
		target_layer = new_piping_layer
	AddComponent(/datum/component/usb_port, list(
		/obj/item/circuit_component/atmos_meter,
	))
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/meter/LateInitialize()
	. = ..()
	SSair.start_processing_machine(src)
	if(!target)
		reattach_to_layer()

/obj/machinery/meter/proc/reattach_to_layer()
	var/obj/machinery/atmospherics/candidate
	for(var/obj/machinery/atmospherics/pipe/pipe in loc)
		if(pipe.piping_layer == target_layer)
			candidate = pipe
	if(candidate)
		target = candidate
		setAttachLayer(candidate.piping_layer)

/obj/machinery/meter/proc/setAttachLayer(new_layer)
	target_layer = new_layer
	PIPING_LAYER_DOUBLE_SHIFT(src, target_layer)

/obj/machinery/meter/process_atmos()
	if(!(target?.flags_1 & INITIALIZED_1))
		icon_state = "meterX"
		return FALSE

	if(machine_stat & (BROKEN|NOPOWER))
		icon_state = "meter0"
		return FALSE

	use_power(5)

	var/datum/gas_mixture/environment = target.return_air()
	if(!environment)
		icon_state = "meterX"
		return FALSE

	var/env_pressure = environment.return_pressure()
	if(env_pressure <= 0.15*ONE_ATMOSPHERE)
		icon_state = "meter0"
	else if(env_pressure <= 1.8*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*0.3) + 0.5)
		icon_state = "meter1_[val]"
	else if(env_pressure <= 30*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5)-0.35) + 1
		icon_state = "meter2_[val]"
	else if(env_pressure <= 59*ONE_ATMOSPHERE)
		var/val = round(env_pressure/(ONE_ATMOSPHERE*5) - 6) + 1
		icon_state = "meter3_[val]"
	else
		icon_state = "meter4"

	if(frequency)
		var/datum/radio_frequency/radio_connection = SSradio.return_frequency(frequency)

		if(!radio_connection)
			return

		var/datum/signal/signal = new(list(
			"id_tag" = id_tag,
			"device" = "AM",
			"pressure" = round(env_pressure),
			"sigtype" = "status"
		))
		radio_connection.post_signal(src, signal)

/obj/machinery/meter/proc/status()
	if (target)
		var/datum/gas_mixture/environment = target.return_air()
		if(environment)
			. = "The pressure gauge reads [round(environment.return_pressure(), 0.01)] kPa; [round(environment.temperature,0.01)] K ([round(environment.temperature-T0C,0.01)]&deg;C)."
		else
			. = "The sensor error light is blinking."
	else
		. = "The connect error light is blinking."

/obj/machinery/meter/examine(mob/user)
	. = ..()
	. += status()

/obj/machinery/meter/wrench_act(mob/user, obj/item/I)
	..()
	to_chat(user, SPAN_NOTICE("You begin to unfasten \the [src]..."))
	if (I.use_tool(src, user, 40, volume=50))
		user.visible_message(
			"[user] unfastens \the [src].",
			SPAN_NOTICE("You unfasten \the [src]."),
			SPAN_HEAR("You hear ratchet."))
		deconstruct()
	return TRUE

/obj/machinery/meter/deconstruct(disassembled = TRUE)
	if(!(flags_1 & NODECONSTRUCT_1))
		new /obj/item/pipe_meter(loc)
	qdel(src)

/obj/machinery/meter/interact(mob/user)
	if(machine_stat & (NOPOWER|BROKEN))
		return
	else
		to_chat(user, status())

/obj/machinery/meter/singularity_pull(S, current_size)
	..()
	if(current_size >= STAGE_FIVE)
		deconstruct()

/obj/item/circuit_component/atmos_meter
	display_name = "Atmospheric Meter"
	desc = "Allows to read the pressure and temperature of the pipenet."

	///Signals the circuit to retrieve the pipenet's current pressure and temperature
	var/datum/port/input/request_data

	///Pressure of the pipenet
	var/datum/port/output/pressure
	///Temperature of the pipenet
	var/datum/port/output/temperature

	///The component parent object
	var/obj/machinery/meter/connected_meter

/obj/item/circuit_component/atmos_meter/populate_ports()
	request_data = add_input_port("Request Meter Data", PORT_TYPE_SIGNAL, trigger = PROC_REF(request_meter_data))

	pressure = add_output_port("Pressure", PORT_TYPE_NUMBER)
	temperature = add_output_port("Temperature", PORT_TYPE_NUMBER)

/obj/item/circuit_component/atmos_meter/register_usb_parent(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/meter))
		connected_meter = shell

/obj/item/circuit_component/atmos_meter/unregister_usb_parent(atom/movable/shell)
	connected_meter = null
	return ..()

/obj/item/circuit_component/atmos_meter/proc/request_meter_data()
	CIRCUIT_TRIGGER
	if(!connected_meter)
		return
	var/datum/gas_mixture/environment = connected_meter.target.return_air()
	pressure.set_output(environment.return_pressure())
	temperature.set_output(environment.temperature)

// TURF METER - REPORTS A TILE'S AIR CONTENTS
// why are you yelling?
/obj/machinery/meter/turf

/obj/machinery/meter/turf/reattach_to_layer()
	target = loc
