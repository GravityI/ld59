extends State

const ATTRIBUTES = ["combat", "mobility", "diplomacy", "science"]

@export var Resolving : State
@export var distress_signal_player : AudioStreamPlayer

var distress_attributes

func _enter_state() -> void:
	state_name = "Distress"
	StateMachine.AnimPlayer.play("distress")
	distress_attributes = ATTRIBUTES.duplicate()
	distress_attributes.shuffle()
	distress_attributes = distress_attributes.slice(0, 2)
	distress_signal_player.play()
