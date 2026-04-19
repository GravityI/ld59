extends Control

#Generic Main Menu Script

#Scene that the "Play" Button changes to 
@export var PlayScene : PackedScene

#Scene that the "Credits" Button changes to 
@export var CreditsScene : PackedScene

func _on_play_button_down() -> void:
	get_tree().change_scene_to_packed(PlayScene)

func _on_credits_button_down() -> void:
	get_tree().change_scene_to_packed(CreditsScene)

func _on_quit_button_down() -> void:
	get_tree().quit()

#Game Specific Logic

@export var ControlsLabel : Label
@export var ControlsButton : Button

func _on_controls_button_button_down() -> void:
	ControlsLabel.show()
	ControlsButton.hide()
