extends KinematicBody2D

const GRAVITY_VEC = Vector2(0, 900)
const FLOOR_NORMAL = Vector2(0, -1)

const WALK_SPEED = 70
const STATE_WALKING = 0
const STATE_KILLED = 1

var linear_velocity = Vector2()
var direction = -1
var anim=""

var stabbed = false

var state = STATE_WALKING

func _physics_process(delta):
	var new_anim = "idle"

	if state==STATE_WALKING:
		linear_velocity.y += Global.GRAVITY * delta
		linear_velocity.x = direction * WALK_SPEED
		linear_velocity = move_and_slide(linear_velocity, FLOOR_NORMAL)

		if not $DetectFloorLeft.is_colliding() or $DetectWallLeft.is_colliding():
			direction = 1.0

		if not $DetectFloorRight.is_colliding() or $DetectWallRight.is_colliding():
			direction = -1.0

		$AnimatedSprite.scale = Vector2(direction, 1.0)
		new_anim = "walk"
	else:
		new_anim = "explode"

#	if anim != new_anim:
#		anim = new_anim
#		$anim.play(anim)

func _on_Area2D_area_entered(area):
	stabbed = true