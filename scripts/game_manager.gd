extends Node

const BASE_MISSION_DURATION = 22
const MovingVessel = preload("uid://cy48rox3kykxy")
const station_center_position = Vector2(592, 324)

@export var VesselManager : Node
@export var UIManager : Control
@export var Galaxy : Control
@export var DistressPopup : PopupPanel
@export var AttributeLabel1 : Label
@export var AttributeLabel2 : Label
@export var HangarContainer : HBoxContainer
@export var UpgradePopup : PopupPanel
@export var StatUpgradeContainer : HBoxContainer
@export var AudioLibrary : Node

var chaos : int = 0
var time_left : int = 300
var selected_planet_id : int
var selected_vessel_id : int
var distress_attributes : Array
var upgrade_selected : bool = false

func get_planets_in_state(state_name : String) -> Array[Node]:
	var planet_array : Array[Node] = []
	for entity in Galaxy.get_children():
		if entity.is_in_group("planet"):
			if entity.StateMachine.current_state_name() == state_name:
				planet_array.append(entity)
	return planet_array

func get_planet_by_id(planet_id : int) -> Node:
	for entity in Galaxy.get_children():
		if entity.is_in_group("planet"):
			if entity.planet_id == planet_id:
				return entity
	return null

func get_vessel_by_id(vessel_id : int) -> Vessel:
	for vessel in VesselManager.vessels:
		if vessel.vessel_id == vessel_id:
			return vessel
	return null

func create_moving_vessel(vessel_id : int, starting_position : Vector2, target_position : Vector2) -> void:
	var new_moving_vessel = MovingVessel.instantiate()
	new_moving_vessel.texture = get_vessel_by_id(vessel_id).vessel_texture
	new_moving_vessel.global_position = starting_position
	new_moving_vessel.target_global_position = target_position
	new_moving_vessel.look_at(target_position)
	new_moving_vessel.rotate(-PI/2)
	add_child(new_moving_vessel)
	play_sound("vessel_departed")

func get_resolution_duration(vessel_id : int, tested_attributes : Array) -> int:
	var duration = BASE_MISSION_DURATION
	var vessel = get_vessel_by_id(vessel_id)
	for attribute in tested_attributes:
		match attribute:
			"combat":
				duration -= vessel.COMBAT
			"mobility":
				duration -= vessel.MOBILITY
			"diplomacy":
				duration -= vessel.DIPLOMACY
			"science":
				duration -= vessel.SCIENCE
	return clamp(duration, 8, BASE_MISSION_DURATION)

func show_distress_popup(planet_id) -> void:
	selected_planet_id = planet_id
	distress_attributes = get_planet_by_id(planet_id).StateMachine.current_state.distress_attributes
	AttributeLabel1.text = distress_attributes[0]
	AttributeLabel2.text = distress_attributes[1]
	for vessel_id in range(1, 5):
		var vessel = get_vessel_by_id(vessel_id)
		var VesselContainer = HangarContainer.get_node("VesselContainer" + str(vessel_id))
		VesselContainer.get_node("VesselTexture").icon = vessel.vessel_texture
		if vessel.on_resolution:
			VesselContainer.get_node("VesselTexture").disabled = true
			VesselContainer.get_node("TimeNeededLabel").text = "AWAY" #Polish: Change Color
			VesselContainer.get_node("DurationLabel").hide()
		else:
			VesselContainer.get_node("VesselTexture").disabled = false
			VesselContainer.get_node("TimeNeededLabel").text = "DURATION"
			VesselContainer.get_node("DurationLabel").show()
			VesselContainer.get_node("DurationLabel").text = str(get_resolution_duration(vessel_id, distress_attributes))
	DistressPopup.popup_centered()
	play_sound("distress_popup")

func show_upgrade_popup(vessel_id) -> void:
	var vessel = get_vessel_by_id(vessel_id)
	upgrade_selected = false
	selected_vessel_id = vessel_id
	get_tree().paused = true
	UpgradePopup.get_node("VBoxContainer/VesselTexture").texture = vessel.vessel_texture
	if vessel.COMBAT == 10:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer1/UpgradeButton").hide()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer1/CurrentStatNumber").text = "MAX(10)"
	else:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer1/UpgradeButton").show()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer1/CurrentStatNumber").text = str(vessel.COMBAT)
	if vessel.MOBILITY == 10:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer2/UpgradeButton").hide()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer2/CurrentStatNumber").text = "MAX(10)"
	else:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer2/UpgradeButton").show()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer2/CurrentStatNumber").text = str(vessel.MOBILITY)
	if vessel.DIPLOMACY == 10:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer3/UpgradeButton").hide()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer3/CurrentStatNumber").text = "MAX(10)"
	else:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer3/UpgradeButton").show()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer3/CurrentStatNumber").text = str(vessel.DIPLOMACY)
	if vessel.SCIENCE == 10:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer4/UpgradeButton").hide()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer4/CurrentStatNumber").text = "MAX(10)"
	else:
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer4/UpgradeButton").show()
		UpgradePopup.get_node("VBoxContainer/StatUpgradeContainer/StatsContainer4/CurrentStatNumber").text = str(vessel.SCIENCE)
	
	UpgradePopup.popup_centered()
	play_sound("upgrade_popup")

func play_sound(sound_name : String) -> void:
	AudioLibrary.get_node(sound_name).play()

func _on_game_timer_timeout() -> void:
	time_left -= 1
	if time_left <= 0:
		get_tree().change_scene_to_packed(load("uid://dtgn1ktyj061o"))
	
	var distressed_planets = get_planets_in_state("Distress")
	if distressed_planets.size() > 0:
		chaos += distressed_planets.size()
		if chaos > 100:
			get_tree().change_scene_to_packed(load("uid://bn0su5gbv54gq"))
	
	var idle_planets = get_planets_in_state("Idle")
	if idle_planets.size() > 0:
		for planet in idle_planets:
			planet.StateMachine.current_state.time_passed += 1
		if idle_planets.size() == 6 and chaos > 0:
			chaos -= 1
	
	var resolving_planets = get_planets_in_state("Resolving")
	if resolving_planets.size() > 0:
		for planet in resolving_planets:
			planet.StateMachine.current_state.time_passed += 1
	
	UIManager.update_ui()

func _dispatch_vessel(vessel_id : int, planet_id : int) -> void:
	var target_planet = get_planet_by_id(planet_id)
	create_moving_vessel(vessel_id, station_center_position, target_planet.global_position + target_planet.size)
	get_vessel_by_id(vessel_id).on_resolution = true
	var planet_state_machine = target_planet.StateMachine
	planet_state_machine.set_state(planet_state_machine.current_state.Resolving)
	planet_state_machine.current_state.current_vessel_id = vessel_id
	planet_state_machine.current_state.current_planet_id = planet_id
	planet_state_machine.current_state.duration = get_resolution_duration(vessel_id, distress_attributes)

func _on_distress_popup_popup_hide() -> void:
	get_tree().paused = false
	selected_planet_id = -1

func _on_vessel_texture_button_down(vessel_id : int) -> void:
	_dispatch_vessel(vessel_id, selected_planet_id)
	DistressPopup.hide()
	play_sound("button_click")

func _on_upgrade_button_button_down(stat_id : int) -> void:
	var vessel = get_vessel_by_id(selected_vessel_id)
	vessel.on_resolution = false
	upgrade_selected = true
	match stat_id:
		1:
			vessel.COMBAT += 1
		2:
			vessel.MOBILITY += 1
		3:
			vessel.DIPLOMACY += 1
		4:
			vessel.SCIENCE += 1
	UpgradePopup.hide()
	get_tree().paused = false
	play_sound("button_click")

func _on_upgrade_popup_popup_hide() -> void:
	if !upgrade_selected:
		UpgradePopup.show()
