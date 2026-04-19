extends State

const starting_distress_chance : float = 0.1

@export var Distress : State

var time_passed : int = 0
var distress_chance : float = starting_distress_chance

func _enter_state() -> void:
	state_name = "Idle"
	StateMachine.AnimPlayer.play("RESET")

func _state_process(_delta : float) -> void:
	if time_passed >= 3:
		time_passed = 0
		var rng = randf()
		#if rng < 0.1:
		if rng < distress_chance:
			distress_chance = starting_distress_chance
			StateMachine.set_state(Distress)
		else:
			distress_chance += starting_distress_chance/2
