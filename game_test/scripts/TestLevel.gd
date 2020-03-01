extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var screen_height = get_viewport_rect().size.y
	$Camera2D.position.y = floor($Player.position.y / screen_height) * screen_height
