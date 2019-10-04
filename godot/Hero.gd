extends RigidBody2D

onready var env = $EnvironmentSM
onready var action = $ActionSM

export var default_gravity_scale : float = 6 
export var fall_gravity_scale : float = 20
export var jump_impulse : float = 800
export var walk_speed : float = 40

# Called when the node enters the scene tree for the first time.
func _ready():
	gravity_scale = default_gravity_scale
	
	env.set_state('air')
	action.set_state('fall')
	
func _physics_process(delta):
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
		if Input.is_action_just_released("ui_accept") or linear_velocity.y > 0:
			action.set_state('fall')
	elif env.in_state('floor'):
		action.set_state('ready')
		
	var dir_x = int(Input.is_action_pressed('ui_right'))-int(Input.is_action_pressed('ui_left'))
	apply_central_impulse(walk_speed*Vector2(dir_x,0))
	if dir_x != 0:
		$Sprite.flip_h = dir_x < 0
	
func _on_env_change(old_state, new_state):
	print('Environment: ', new_state)
	
func _on_action_change(old_state, new_state):
	print('Action: ', new_state)
	
	if new_state == 'jump':
		apply_central_impulse(Vector2(0,-jump_impulse))
	elif new_state == 'fall':
		gravity_scale = fall_gravity_scale
		
	if old_state == 'fall':
		gravity_scale = default_gravity_scale
		