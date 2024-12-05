extends Node2D
 
@export var obstacle_scene: PackedScene 
@onready var obstacle_timer = $Timer
@onready var button = $Button
@onready var player = $Player
@onready var label = $Label
 
var score: int = 0 
var obstacles: Array = []
 
func _ready() -> void:
	# Connect signals and start obstacle timer
	obstacle_timer.timeout.connect(spawn_obstacle)
	player.hit_obstacle.connect(Callable(self, "_on_player_hit_obstacle"))
	button.pressed.connect(Callable(self, "_on_button_pressed"))
	obstacle_timer.start()

func spawn_obstacle() -> void:
	# Instantiate the obstacle
	var obstacle_instance = obstacle_scene.instantiate()

	# Randomize whether the obstacle spawns at the top or bottom
	obstacle_instance.directionUp = randf() < 0.5
	if obstacle_instance.directionUp:
		# Spawn from the top
		obstacle_instance.position = Vector2(900, 0)
	else:
		# Spawn from the bottom
		obstacle_instance.position = Vector2(900, get_viewport().size.y)
		obstacle_instance.scale.y = -1  # Flip vertically for bottom obstacles

	# Add the obstacle to the scene and connect signals
	add_child(obstacle_instance)
	obstacles.append(obstacle_instance)
	obstacle_instance.connect("obstacle_passed", Callable(self, "_on_obstacle_passed"))

func _on_obstacle_passed() -> void:
	# Increment score and update UI
	score += 1
	label.text = "Score: " + str(score)
 
func _on_player_hit_obstacle() -> void:
	# Stop spawning obstacles and show restart button
	print("Player hit an obstacle!")
	obstacle_timer.stop()
	button.visible = true
	button.disabled = false
	disable_obstacle_signals()

func disable_obstacle_signals() -> void:
	# Disconnect signals from obstacles
	for obstacle in obstacles:
		if obstacle and is_instance_valid(obstacle):
			obstacle.disconnect("obstacle_passed", Callable(self, "_on_obstacle_passed"))

func _on_button_pressed() -> void:
	# Reload the current scene
	print("Restarting scene...")
	get_tree().reload_current_scene()
