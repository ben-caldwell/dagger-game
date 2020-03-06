extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var screen_height = get_viewport_rect().size.y
	$Camera2D.position.y = floor($Player.position.y / screen_height) * screen_height