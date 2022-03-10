extends KinematicBody
export var G = 1.5
var speed_y = 0
var up_dir = Vector3.UP
var is_jumping = true
export var movement_speed = 200
export var jump_impulse = 400

#@stav you never use these, why did you just define variables without doing anything with them?????
var gravity = - 30
var max_speed = 8
var mouse_sensitivity = 0.002   #radians


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vect : Vector3 = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func _process(delta):
	vect.x = 0
	vect.z = 0
	# We check for each move input and update the vect accordingly.
	if Input.is_action_pressed("move_right"):
		vect.x -= movement_speed
	if Input.is_action_pressed("move_left"):
		vect.x += movement_speed
	if Input.is_action_pressed("move_back"):
		vect.z -= movement_speed
	if Input.is_action_pressed("move_forward"):
		vect.z += movement_speed
	if Input.is_action_just_pressed("jump"):
		vect.y = vect.y + jump_impulse
		is_jumping = true
		print("jump")
	move_and_slide(vect,up_dir)
	print('is jumping is',is_jumping)
	print('speed_y is ',speed_y)
	print('vect.y is ', vect.y)
	print('on_floor is ',is_on_floor())
	if is_on_floor():
		print('')
		if !is_jumping:
			speed_y = 0
			vect.y = 0

	else:
		is_jumping = false
		speed_y = speed_y + G
	vect.y = vect.y - speed_y
