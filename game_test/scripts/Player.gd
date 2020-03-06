extends KinematicBody2D

const MAX_THROW_CHARGES = 1

var throw_charges = MAX_THROW_CHARGES
var has_knife
var velocity
var knife

# Called when the node enters the scene tree for the first time.
func _ready():
	has_knife = true
	velocity = Vector2()
	$AnimatedSprite.play("has_knife")

func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if has_knife and throw_charges > 0:
			throw_knife()
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if not has_knife:
			teleport_to_knife()

func _process(delta):
	# face the mouse
	var direction = get_global_mouse_position() - position
	$AnimatedSprite.flip_h = direction.x > 0
	
	# display throw charges
	$Label.text = str(throw_charges)
	
#	var screen_height = get_viewport_rect().size.y
#	$Camera2D.position.y = -(floor(position.y / screen_height) * screen_height)

func _physics_process(delta):
	# gravity
	velocity.y += delta * Global.GRAVITY
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info and has_knife:
		# the player hits the ground, needs throw charges
		throw_charges = MAX_THROW_CHARGES

func throw_knife():
	# spawn knife
	knife = preload("res://scenes/Knife.tscn").instance()
	knife.position = position
	get_parent().add_child(knife) #don't want bullet to move with me, so add it as child of parent

	# lose knife
	has_knife = false
	throw_charges -= 1
	$AnimatedSprite.play("no_knife")
	
	$AudioStreamPlayer2D.play()
	
func teleport_to_knife():
	# regain charges if knife is on wall or player
	if knife and knife.state != knife.FLYING:
			throw_charges = MAX_THROW_CHARGES
	
	# kill stabbed enemy
	if knife.state == knife.STABBED_IN_ENEMY:
		knife.get_stabbed_enemy().queue_free() # kill
	
	# move to knife
	position = knife.get_position()
	velocity = Vector2()
	knife.queue_free()
	
	# regain knife
	has_knife = true
	$AnimatedSprite.play("has_knife")