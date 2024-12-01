extends Node2D

@export var main_game_scene: PackedScene

func _ready() -> void:
	$Button.connect("pressed", Callable(self, "_on_StartGameButton_pressed"))
	
func _on_StartGameButton_pressed() -> void:
	get_tree().change_scene_to_packed(main_game_scene)
