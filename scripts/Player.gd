extends KinematicBody

var fire_sound = preload("res://audio/soundEffects/gun_and_kick.wav")
var dodge_sound = preload("res://audio/soundEffects/wooshing sound effect.wav")


var GRAVITY = -90.8
const def_GRAVITY = -90.8
var vel = Vector3()
const MAX_SPEED = 20
const JUMP_SPEED = 45
const ACCEL= 4.5
var dodge_impulse = 800
const MAX_SPRINT_SPEED = 35
const SPRINT_ACCEL = 20
const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40
var allowed_to_grapple = true
var dir = Vector3()
var rotation_helper
var first_coords
var first_rot
var MOUSE_SENSITIVITY

var position_of_collision
var speed_hook = 5
var unlocked_double_jump = true
var unlocked_gun = true
var unlocked_dodge = true

onready var wire = $Rotation_Helper/Gun_Fire_Points/Rifle_Point/Ray_Cast/wire
var default_wire_transform
var wire_first_pos
var wire_first_basis
var camera
onready var timer = $Timer
onready var timer2 = $Timer2
var animation_manager
var dodged = false
var grappled = false

var current_weapon_name = "UNARMED"
var weapons = {"UNARMED":null, "KNIFE":null, "RIFLE":null}
const WEAPON_NUMBER_TO_NAME = {0:"UNARMED", 1:"KNIFE", 2:"RIFLE"}
const WEAPON_NAME_TO_NUMBER = {"UNARMED":0, "KNIFE":1, "RIFLE":2}
var changing_weapon = false
var changing_weapon_name = "UNARMED"

var first_wire_pos
var health = 100


var is_slowing_down = false
var jump_bool


func _ready():
	default_wire_transform = wire.transform
	self.first_coords = self.global_transform.origin
	print(self.first_coords)
	self.first_rot = self.global_transform.basis
	var file = File.new()
	file.open("user://mouse_sensitivity.dat", File.READ)
	var content = file.get_as_text()
	file.close()
	MOUSE_SENSITIVITY = float(content)
	camera = $Rotation_Helper/Camera
	rotation_helper = $Rotation_Helper

	animation_manager = $Rotation_Helper/Model/Animation_Player
	animation_manager.callback_function = funcref(self, "fire_bullet")

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	weapons["KNIFE"] = $Rotation_Helper/Gun_Fire_Points/Knife_Point
	weapons["RIFLE"] = $Rotation_Helper/Gun_Fire_Points/Rifle_Point

	var gun_aim_point_pos = $Rotation_Helper/Gun_Aim_Point.global_transform.origin

	for weapon in weapons:
		var weapon_node = weapons[weapon]
		if weapon_node != null:
			weapon_node.player_node = self
			weapon_node.look_at(gun_aim_point_pos, Vector3(0, 1, 0))
			weapon_node.rotate_object_local(Vector3(0, 1, 0), deg2rad(180))

	current_weapon_name = "UNARMED"
	changing_weapon_name = "UNARMED"


func _physics_process(delta):
	process_input(delta)
	process_movement(delta)
	process_changing_weapons(delta)
func process_input(delta):

	# ----------------------------------
	# Walk
	if !grappled:
		dir = Vector3()
		var cam_xform = camera.get_global_transform()

		var input_movement_vector = Vector2()

		if Input.is_action_pressed("movement_forward"):
			input_movement_vector.y += 1
		if Input.is_action_pressed("movement_backward"):
			input_movement_vector.y -= 1
		if Input.is_action_pressed("movement_left"):
			input_movement_vector.x -= 1
		if Input.is_action_pressed("movement_right"):
			input_movement_vector.x = 1

		input_movement_vector = input_movement_vector.normalized()

		dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
		dir += cam_xform.basis.x.normalized() * input_movement_vector.x
		# ----------------------------------

		# ----------------------------------
		# Jumping

		# ----------------------------------
		
		# ----------------------------------
		# Sprinting
		if Input.is_action_pressed("slow_down"):
			is_slowing_down = false
		else:
			is_slowing_down = true
		
		if Input.is_action_just_pressed("dodge"):
			if dodged:
				pass # maybe a sound  effect that you cant do it yet?
			else:
				if is_slowing_down:
					dodged = true
					timer.start(1.5)
					#print(vel,global_transform.basis,dir)
					#vel.x += dodge_impulse
					#transform.origin.x += dodge_impulse
					#global_transform.origin += transform.basis.z * dodge_impulse
					#move_and_slide(transform.basis.z * dodge_impulse,Vector3.UP)
					if Input.is_action_pressed("movement_backward"):
						
						vel=vel.normalized()-transform.basis.z * dodge_impulse
						GRAVITY = 3*def_GRAVITY/4
					else:
						vel=vel.normalized()+transform.basis.z * dodge_impulse
						GRAVITY = 3*def_GRAVITY/4
					$player_soundEffects_player.stream = dodge_sound
					$player_soundEffects_player.play(0.2)
		# ----------------------------------
		
		# ----------------------------------
		# ----------------------------------

		# ----------------------------------
		# Capturing/Freeing the cursor
		# ----------------------------------
		
		# ----------------------------------
		# Changing weapons.
		var weapon_change_number = WEAPON_NAME_TO_NUMBER[current_weapon_name]
		
		if Input.is_key_pressed(KEY_1):
			weapon_change_number = 0
		if Input.is_key_pressed(KEY_2):
			weapon_change_number = 1
		if Input.is_key_pressed(KEY_3):
			weapon_change_number = 2
		if Input.is_key_pressed(KEY_4):
			weapon_change_number = 3
		
		if Input.is_action_just_pressed("shift_weapon_positive"):
			weapon_change_number += 1
		if Input.is_action_just_pressed("shift_weapon_negative"):
			weapon_change_number -= 1
		
		weapon_change_number = clamp(weapon_change_number, 0, WEAPON_NUMBER_TO_NAME.size()-1)
		
		if changing_weapon == false:
			if WEAPON_NUMBER_TO_NAME[weapon_change_number] != current_weapon_name:
				changing_weapon_name = WEAPON_NUMBER_TO_NAME[weapon_change_number]
				changing_weapon = true
		# ----------------------------------
		
		# ----------------------------------
		# Firing the weapons
		# ----------------------------------
		if Input.is_action_just_pressed("grappling_hook"):
			if grappled:
				pass # maybe a sound  effect that you cant do it yet?
				print("allready grapplkded")
			else:
				if is_slowing_down && allowed_to_grapple:
					grappled = true
					$Rotation_Helper/Gun_Fire_Points/Rifle_Point.fire_grappling_hook()
					timer2.start(2.3)
					allowed_to_grapple = false
					wire_first_pos= wire.global_transform.origin
					wire_first_basis = wire.global_transform.basis
	if Input.is_action_just_pressed("movement_jump"):
		if is_on_floor():
			vel.y = JUMP_SPEED
			jump_bool = true
		elif jump_bool:
			vel.y = JUMP_SPEED
			jump_bool = false
		if grappled:
			grappled=false
			print("got here")
			dir = Vector3.ZERO
			vel.y = JUMP_SPEED
	if Input.is_action_pressed("fire"):
		if changing_weapon == false:
			var current_weapon = weapons[current_weapon_name]
			if current_weapon != null:
				if animation_manager.current_state == current_weapon.IDLE_ANIM_NAME:
					animation_manager.set_animation(current_weapon.FIRE_ANIM_NAME)
					if current_weapon_name == "RIFLE":
						$player_soundEffects_player2.stream = fire_sound
						$player_soundEffects_player2.play()
func process_movement(delta):
	print(jump_bool)
	#procces HUD
	if timer.time_left == 0:
		$ColorRect/ProgressBar.value = 100
	$ColorRect/ProgressBar.value = timer.time_left / 1.5 * 100
	if timer2.time_left == 0:
		$ColorRect/ProgressBar2.value = 100
	$ColorRect/ProgressBar2.value = timer2.time_left / 2.3* 100
	
	if !grappled:
		wire.visible = false
		wire.transform = default_wire_transform
		dir.y = 0
		
		dir = dir.normalized()

		vel.y += delta*GRAVITY
	if grappled:
		wire.global_transform.origin = wire_first_pos
		wire.global_transform.basis = wire_first_basis
		dir = (position_of_collision - global_transform.origin).normalized() * speed_hook 
		if dir.x < 0.01 && dir.x > -0.001 || dir.z < 0.01 && dir.z > -0.001|| dir.y< 0.01 && dir.y > -0.001:
			grappled = false
	var hvel = vel
	if !grappled:	
		hvel.y = 0

	var target = dir
	if is_slowing_down:
		target *= MAX_SPRINT_SPEED
	else:
		target *= MAX_SPEED

	var accel
	if dir.dot(hvel) > 0:
		if is_slowing_down:
			accel = SPRINT_ACCEL
		else:
			accel = ACCEL
	else:
		accel = DEACCEL

	hvel = hvel.linear_interpolate(target, accel*delta)
	vel.x = hvel.x
	vel.z = hvel.z
	#print(vel)
	vel = move_and_slide(vel,Vector3.UP, 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "red_floor":
			#DEATH LOGIG IS HERE
			global_transform.origin = first_coords
			global_transform.basis = first_rot
		elif collision.collider.name == "nextlevelcube":
			get_tree().change_scene("res://Levels//level2.tscn")
			print("just died XD")
			timer2.stop()
			allowed_to_grapple = true
			grappled = false
		elif collision.collider.name != "" && !is_on_floor():
			grappled = false
			
			#jump_bool = true
			

	
	if def_GRAVITY<GRAVITY:
		GRAVITY -= 0.8
func process_changing_weapons(delta):
	if changing_weapon == true:
		var weapon_unequipped = false
		var current_weapon = weapons[current_weapon_name]

		if current_weapon == null:
			weapon_unequipped = true
		else:
			if current_weapon.is_weapon_enabled == true:
				weapon_unequipped = current_weapon.unequip_weapon()
			else:
				weapon_unequipped = true

		if weapon_unequipped == true:

			var weapon_equiped = false
			var weapon_to_equip = weapons[changing_weapon_name]

			if weapon_to_equip == null:
				weapon_equiped = true
			else:
				if weapon_to_equip.is_weapon_enabled == false:
					weapon_equiped = weapon_to_equip.equip_weapon()
				else:
					weapon_equiped = true

			if weapon_equiped == true:
				changing_weapon = false
				current_weapon_name = changing_weapon_name
				changing_weapon_name = ""


func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
		self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot

func fire_bullet():
	if changing_weapon == true:
		return

	weapons[current_weapon_name].fire_weapon()
	
	




func _on_Timer_timeout():
	dodged = false


func _on_Timer2_timeout():
	allowed_to_grapple = true
	print("grappled is flase")
