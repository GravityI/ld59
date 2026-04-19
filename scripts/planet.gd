extends TextureRect

@export var PlanetTexture : Texture2D
@export var StateMachine : Node
@export var planet_id : int
@export var GameManager : Node

func _ready() -> void:
	get_node("PlanetTexture").texture = PlanetTexture
	get_node("StateLabel").global_position = global_position + Vector2(-32, 30)

func _on_distress_button_down() -> void:
	GameManager.show_distress_popup(planet_id)
	get_tree().paused = true
	GameManager.play_sound("button_click")
