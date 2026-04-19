extends Control

@export var GameManager : Node
@export var ChaosBar : ProgressBar
@export var TimeLabel : Label

func update_ui() -> void:
	ChaosBar.value = GameManager.chaos
	TimeLabel.text = "Time Left: " + str(floor(GameManager.time_left))
