extends RigidBody2D

onready var env = $EnvironmentSM
onready var action = $ActionSM

export var default_gravity_scale : float = 4
export var fall_gravity_scale : float = 12
export var jump_impulse : float = 210
export var walk_speed : float = 15
export var air_walk_speed : float = 4

var speed
var debug = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = default_gravity_scale
	
	env.set_state('air')
	action.set_state('fall')
	
func _integrate_forces(state):
	var colliding_bodies = get_colliding_bodies()
	
	# environment
	if env.in_state('air'):
		if len(colliding_bodies) > 0:
			env.set_state('floor')
	elif env.in_state('floor'):
		if len(colliding_bodies) == 0:
			env.set_state('air')
			
    # action
	if action.in_state('ready'):
		if env.in_state('floor') and Input.is_action_just_pressed("ui_accept"):
			action.set_state('jump')
		elif linear_velocity.y > 0:
			action.set_state('fall')
	elif action.in_state('jump'):
		debug += 1
		if Input.is_action_just_released("ui_accept") or linear_velocity.y > 0:
			action.set_state('fall')
	elif action.in_state('fall'):
		if env.in_state('floor'):
			action.set_state('ready')
			
	var dir_x = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	apply_central_impulse(speed*Vector2(dir_x,0))
	state.linear_velocity.x = clamp(state.linear_velocity.x,-speed, speed)

	if dir_x != 0:
		$Graphics/Sprite.flip_h = dir_x < 0
	
func _on_env_change(old_state, new_state):
	print('Environment: ', new_state)
	
	if new_state == 'air':
		speed = air_walk_speed
	elif new_state == 'floor':
		speed = walk_speed
		
	if old_state == 'air' and new_state == 'floor':
		$Graphics/Sprite/AnimationPlayer.play('Land')
		
func _on_action_change(old_state, new_state):
	print('Action: ', new_state)
	
	if new_state == 'jump':
		apply_central_impulse(Vector2(0,-jump_impulse))
	elif new_state == 'fall':
		gravity_scale = fall_gravity_scale
		
	if old_state == 'fall':
		gravity_scale = default_gravity_scale
		
