extends Node2D

@export var obstacle_scene: PackedScene
@onready var obstacle_timer= $Timer
@onready var button= $Button
@onready var player= $Player
@onready var label= $Label

var score: int= 0
var obstacles: Array = []

func _ready() -> void:
	obstacle_timer.timeout.connect(spawn_obstacle)
	player.hit_obstacle.connect(Callable(self, "_on_Player_hit_obstacle"))
	button.pressed.connect(Callable(self, "_on_Button_pressed"))
	
func spawn_obstacle() -> void:
	var obstacle_instance =  obstacle_scene.instantiate()
	obstacle_instance.directionUp= randf() < 0.5
	obstacle_instance.position= Vector2(900,0)
	add_child(obstacle_instance)
	obstacles.append(obstacle_instance) 
	obstacle_instance.connect("obstacle_passed", Callable(self, "_on_obstacle_passed"))

func _on_obstacle_passed() -> void:
	score += 1
	label.text= "Score: " + str(score)
	
func _on_Player_hit_obstacle() -> void:
	obstacle_timer.stop()
	button.visible= true
	button.disabled= false
	disable_obstacle_signals()
	
func disable_obstacle_signals() -> void:
	for obstacle in obstacles: #iterate over obstacles
		if is_instance_valid(obstacle):  # Ensure the obstacle exists
			if obstacle.is_connected("obstacle_passed", self, "_on_obstacle_passed"):  # Check connection
				obstacle.disconnect("obstacle_passed", self, "_on_obstacle_passed")

	
func _on_Button_pressed() -> void:
	get_tree().reload_current_scene()
