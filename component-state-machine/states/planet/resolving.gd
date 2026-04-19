extends State

@export var Idle : State

@onready var GameManager = StateMachine.controlled_object.GameManager

var time_passed : int = 0
var duration : int
var current_vessel_id : int
var current_planet_id : int
var vessel_sent : bool = false

func _enter_state() -> void:
	time_passed = 0
	state_name = "Resolving"
	StateMachine.AnimPlayer.play("resolving")
	vessel_sent = false

func _state_process(_delta : float) -> void:
	if time_passed == duration - 3 and !vessel_sent:
		vessel_sent = true
		var current_planet = GameManager.get_planet_by_id(current_planet_id)
		GameManager.create_moving_vessel(current_vessel_id, current_planet.global_position + current_planet.size, GameManager.station_center_position)
	if time_passed >= duration:
		GameManager.show_upgrade_popup(current_vessel_id)
		StateMachine.set_state(Idle)
