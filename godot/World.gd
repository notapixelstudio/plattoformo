extends Node2D

export var hero_scene : PackedScene
onready var start_pos = $Hero.position

func _on_OffScreen_body_entered(body):
	var hero = body.duplicate()
	body.queue_free()
	hero.position = start_pos
	hero.linear_velocity = Vector2()
	# var hero = hero_scene.instance()
	yield(get_tree().create_timer(0.3), "timeout")
	add_child(hero)
