extends CharacterBody2D

## The current squish scale as controlled by $SquishAnimationPlayer.
## Animated from 1.0 to 0.0.
@export var current_squish_scale: float = 0.0

## The maximum amplitude applied to current_squish_scale.
## 0 means no squish, positive means stretch, negative means squish.
@export var squish_amplitude: float = 0.0

#maybe some day we'll get a tod adventure
#(but really I just followed the first sprite anim thing on the godot site
#and CharacterBody2D is the one used there so uuuuh here you go I guess)
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _process(delta):
	var total_squish = squish_amplitude * current_squish_scale
	scale.y = 1.0 + total_squish

#func _physics_process(delta):
	## Add the gravity.
	#if not is_on_floor():
		#velocity.y += gravity * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
