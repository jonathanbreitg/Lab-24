extends KinematicBody

var velocity = Vector3(0, 0, 0)
var direction = Vector3(0, 0, 0) # Used for animation
signal died
const JUMP = 18
const PLAYER_MOVE_SPEED = 9
var sprint_multiplier = 1
var first_coords
var first_rot
var first_jump
var double_jump_multiplier = 1.1
onready var Camera = $Camera
onready var GRAVITY = ProjectSettings.get("physics/3d/default_gravity") / 100
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.first_coords = self.global_transform.origin
	self.first_rot = rotation
func move_forward_back(in_direction: int):
	"""
	Move the camera forward or backwards
	"""
	self.direction.z += in_direction
	self.velocity += get_transform().basis.z * in_direction * PLAYER_MOVE_SPEED * sprint_multiplier

func move_left_right(in_direction: int):
	"""
	Move the camera to the left or right
	"""
	self.direction.x += in_direction
	self.velocity += get_transform().basis.x * in_direction * PLAYER_MOVE_SPEED * sprint_multiplier


func _process(_delta: float):
	"""
	Allow the player to move the camera with WASD
	See Project settings -> Input map for keyboard bindings
	"""
	# Preserve the Y velocity from the previous frame
	self.velocity = Vector3(0, self.velocity.y, 0)
	self.direction = Vector3(0, 0, 0)
	
	if Input.is_action_pressed("sprint"):
		sprint_multiplier = 1.5
	else:
		if sprint_multiplier > 1:
			sprint_multiplier -= 0.05
	
	if Input.is_action_pressed("ui_up"):
		self.move_forward_back(-1)

	elif Input.is_action_pressed("ui_down"):
		self.move_forward_back(+1)

	if Input.is_action_pressed("ui_left"):
		self.move_left_right(-1)

	elif Input.is_action_pressed("ui_right"):
		self.move_left_right(+1)
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == 'box':
			print('should move to next level')
			get_tree().change_scene("res://level2.tscn")
		elif collision.collider.name == 'death_floor':
			emit_signal("died")
			
			self.global_transform.origin = self.first_coords
			self.rotation = self.first_rot
func _physics_process(_delta: float):
	var snap_vector = Vector3(0, -1, 0)
	
	if Input.is_action_just_pressed("action_jump"):
		if self.is_on_floor():
			first_jump = true
			self.velocity.y = 0
			self.velocity.y += JUMP
			snap_vector = Vector3(0, 0, 0)
		elif first_jump == true:
			self.velocity.y = 0
			first_jump = false
			self.velocity.y += JUMP * double_jump_multiplier
			snap_vector = Vector3(0, 0, 0)
	# Apply less gravity if we were on the floor last frame
	# This helps our KinematicBody to avoid physics jitter
	if self.is_on_floor():
		self.velocity -= Vector3(0, GRAVITY / 100, 0)
	else:
		self.velocity -= Vector3(0, GRAVITY, 0)

	# Play the run/strafe/idle animation

	self.velocity = self.move_and_slide_with_snap(
		self.velocity,
		snap_vector,
		Vector3(0, +1, 0),
		true
	)
