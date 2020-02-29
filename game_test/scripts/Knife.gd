extends KinematicBody2D

const INIT_SPEED = 1000
const RESISTANCE = 0.000005
var ROTATION_SPEED = 20 # not const on purpose

# states
const FLYING = 0
const STUCK_IN_WALL = 1
const STABBED_IN_ENEMY = 2

var state = FLYING
var stabbed_enemy
var velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("spinning")
	# for sprite rotation
	$AnimatedSprite.play("single_spin")
	
	# throw the knife towards the mouse
	velocity = get_global_mouse_position() - position
	velocity = velocity.normalized() * INIT_SPEED
	
	# spin in the correct direction
	$AnimatedSprite.set_flip_h(velocity.x > 0)
	
	# for sprite rotation, can leave uncommented
	if velocity.x < 0:
		ROTATION_SPEED *= -1

func _process(delta):
	if state == STABBED_IN_ENEMY:
		position = stabbed_enemy.get_position()
	
	# for sprite rotation instead of animation
	if state == FLYING:
		$AnimatedSprite.rotate(ROTATION_SPEED * delta)
		$CollisionShape2D.rotate(ROTATION_SPEED * delta)

func _physics_process(delta):
	if state == FLYING:
		# gravity
		velocity.y += delta * Global.GRAVITY
		# air resistence
		velocity -= RESISTANCE * velocity.length() * velocity.length() * velocity.normalized()
		
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			# collided with wall
			stick_in_wall(collision_info)

# Called when the knife hits a wall
func stick_in_wall(collision_info):
	state = STUCK_IN_WALL
	
	# change sprite
	$AnimatedSprite.play("stuck_in_wall")
	$AnimatedSprite.set_flip_h(false)
	$AnimatedSprite.set_rotation(PI)
	
	# stick out at the correct angle
	var collision_vector = collision_info.position - position
	$AnimatedSprite.rotate(collision_vector.angle())
	# uncomment for collison at velocity angle instead of straight out
#	$AnimatedSprite.rotate(velocity.angle())

# Called when the knife hits an enemy
func stick_in_enemy(enemy):
	state = STABBED_IN_ENEMY
	
	# change sprite
	$AnimatedSprite.play("stuck_in_wall")
	$AnimatedSprite.set_flip_h(false)
	$AnimatedSprite.set_rotation(PI)
	$AnimatedSprite.rotate(velocity.angle())
	
	# store stabbed enemy
	stabbed_enemy = enemy
	velocity = Vector2() # must be after sprite changes

func _on_Area2D_area_entered(area):
	if state == FLYING:
		stick_in_enemy(area.get_parent())
	
func get_stabbed_enemy():
	return stabbed_enemy