extends Node2D

class_name PixelPerfect

onready var parent : RigidBody2D = get_parent()

var offset : Vector2

func _ready():
	offset = position

func _process(delta):
	if abs(parent.linear_velocity.x) < 0.01:
		global_position.x = round(parent.global_position.x + offset.x)
	
	if abs(parent.linear_velocity.y) < 0.01:
		global_position.y = round(parent.global_position.y + offset.y)