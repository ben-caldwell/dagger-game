extends KinematicBody2D

var INIT_SPEED = 1000
var RESISTANCE = 0.000005
var velocity = Vector2()
var stuck_in_wall = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("spinning")
	
	# throw the knife towards the mouse
	velocity = get_viewport().get_mouse_position() - position
	velocity = velocity.normalized() * INIT_SPEED

func _process(delta):
	$AnimatedSprite.flip_h = velocity.x > 0

func _physics_process(delta):
	if not stuck_in_wall:
		# gravity
		velocity.y += delta * Global.GRAVITY
		# air resistence
		velocity -= RESISTANCE * velocity.length() * velocity.length() * velocity.normalized()
		
		var collision_info = move_and_collide(velocity * delta)
		
		if collision_info:
			# collided
			stick_in_wall(collision_info)


func stick_in_wall(collision_info):
	stuck_in_wall = true
	velocity = Vector2()
	$AnimatedSprite.play("stuck_in_wall")
	$AnimatedSprite.rotate(PI)
	
	var collision_vector = collision_info.position - position
	var angle = collision_vector.angle()
	
	if angle > -1*PI/4 and angle < 1*PI/4:
		pass #right
	elif angle >= 1*PI/4 and angle < 3*PI/4:
		$AnimatedSprite.rotate(PI/2)  # down
	elif angle <= -1*PI/4 and angle > -3*PI/4:
		$AnimatedSprite.rotate(-PI/2) # up
	else:
		$AnimatedSprite.rotate(PI)    # left