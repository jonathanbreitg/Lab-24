extends KinematicBody

onready var camera = $pivot/camera

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
	print(delta)
	vect = Vector3.ZERO

	# We check for each move input and update the vect accordingly.
	if Input.is_action_pressed("move_right"):
		vect.x += 100
	if Input.is_action_pressed("move_left"):
		vect.x -= 100
	if Input.is_action_pressed("move_back"):
		vect.z += 100
	if Input.is_action_pressed("move_forward"):
		vect.z -= 100
	move_and_slide(vect)


	
