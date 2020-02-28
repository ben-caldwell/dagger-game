extends KinematicBody2D

var has_knife
var velocity = Vector2(0, 0)
var throw_charges = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	has_knife = true
	$AnimatedSprite.play("has_knife")

func _input(event):
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if has_knife and throw_charges > 0:
			throw_knife()
	
	if Input.is_mouse_button_pressed(BUTTON_RIGHT):
		if not has_knife:
			teleport_to_knife()

func _process(delta):
	var direction = get_viewport().get_mouse_position() - position
	$AnimatedSprite.flip_h = direction.x > 0
	$Label.text = str(throw_charges)

func _physics_process(delta):
	# gravity
	velocity.y += delta * Global.GRAVITY
	
	var collision_info = move_and_collide(velocity * delta)
	if collision_info:
		throw_charges = 3

func throw_knife():
	throw_charges -= 1
	has_knife = false
	$AnimatedSprite.play("no_knife")
	
	var knife = preload("res://scenes/Knife.tscn").instance()
	knife.position = position #$AnimatedSprite/bullet_shoot.global_position #use node for shoot position
#	knife.get_node("CollisionShape2D").add_collision_exception_with(self) # don't want player to collide with bullet
	get_parent().add_child(knife) #don't want bullet to move with me, so add it as child of parent
#	$sound_shoot.play()
#	shoot_time = 0
	

func teleport_to_knife():
	has_knife = true
	position = get_parent().get_node("Knife").position
	get_parent().remove_child(get_parent().get_node("Knife"))
	$AnimatedSprite.play("has_knife")
	velocity = Vector2()