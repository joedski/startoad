extends CharacterBody2D

## destination coordinates in the parameter space.
## X controls horizontal skew, Y controls vertical scale.
## Reset to (0, 0) to put Tod back to normal.
@export var dest_coords = Vector2(0, 0)

## current coordinates in the parameter space.
## These converge on dest_coords but technically never meet them.
@export var current_coords = Vector2(0, 0)

## time in seconds where 1/2 the distance is covered.
@export var ease_time_factor = 50.

## Animatied parameter indicating how deflated Tod is.
## Reset the DeflationAnimationPlayer to reset this to 0.
@export var deflation_progress = 0.

## Effects of deflation on the coords.
## This is scaled by deflation_progress.
@export var deflation_coord_offset = Vector2(0.2, -0.2)

func _process(delta):
	var coords_delta = dest_coords - current_coords
	var coords_step = coords_delta * pow(0.5, delta * ease_time_factor)
	current_coords = current_coords + coords_step
	
	var y_scale = 1. + current_coords.y + (deflation_coord_offset.y * deflation_progress)
	var x_skew = current_coords.x + (deflation_coord_offset.x * deflation_progress)
	
	# Top value of the second column is the horizontal skew.
	transform.y = Vector2(x_skew, transform.y.y)
	# Set the scale afterwards.
	scale.y = y_scale
