extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var col_pos
var speed = 400
signal enemy_attacked
var direction : Vector2 = Vector2.ZERO
onready var player = get_node("../player_master/KinematicBody2D")
onready var hitbox = get_node("../player_master/KinematicBody2D/Sprite/knife_attack_area")
onready var collision_obj = get_node("CollisionPolygon2D")
onready var sprite = get_node("Sprite")
var hits = 0
var hit_area
var max_hp = 4
var jump_multiplier = 10
var is_hit
var hit_range = 65
var color_frame_counter = 0
var red_hit_frames = 10
var delay_counter = 0
var max_delay_counter = 30
var detection_radius = 600
var y_box_len = 40
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	get_parent().get_node("player_master/KinematicBody2D").connect("attacked", self, "_on_attacked") 

func _physics_process(delta):
	if is_hit:
		if color_frame_counter == red_hit_frames:
			sprite.set_modulate(Color( 1, 1, 1, 1 ))
			color_frame_counter = 0
			is_hit = false
		else:
			color_frame_counter += 1
	direction = Vector2.ZERO
	player = get_node("../player_master/KinematicBody2D")
	if global_position.distance_to(player.global_position) < detection_radius:
		direction.x = -1 * (global_position.x - player.global_position.x)
		direction.y = -1 * (global_position.y - player.global_position.y)
		direction = direction.normalized()
		direction = direction * speed
		direction = move_and_slide(direction,Vector2.UP)
		if global_position.distance_to(player.global_position) < 65:
			if delay_counter == 0:
				emit_signal("enemy_attacked")
				delay_counter += 1
			elif delay_counter == max_delay_counter:
				delay_counter = 0
			else:
				delay_counter += 1
func _on_attacked():
	if hits == max_hp:
		queue_free()
	print("test_attacked")
	col_pos = collision_obj.global_position
	hit_area = hitbox.global_position
	print(col_pos.x)
	print(hit_area.x)
	print(abs(col_pos.x - hit_area.x))
	direction.x = -1 * (global_position.x - player.global_position.x)
	direction.y = -1 * (global_position.y - player.global_position.y)
	direction = direction.normalized()
	direction = direction * speed
	if abs(hit_area.y - col_pos.y) < y_box_len:
		if hitbox.rotation_degrees == 180:
			print("facing left")
			if hit_area.x - col_pos.x < hit_range and hit_area.x - col_pos.x > 0:
				print("actually got hit")
				sprite.set_modulate(Color( 1, 0, 0, 1 ))
				move_and_slide(direction * -jump_multiplier,Vector2.UP)
				hits = hits + 1
				print(str(hits))
				sprite.texture = load("res://textures/evil_red%s.png" % str(hits))
				is_hit = true
			else:
				print("too far away")
		else:
			if col_pos.x - hit_area.x < hit_range:
				print("actually got hit")
				
				hits = hits + 1
				print(str(hits))
				sprite.texture = load("res://textures/evil_red%s.png" % str(hits))
				move_and_slide(direction *-jump_multiplier,Vector2.UP)
				sprite.set_modulate(Color( 1, 0, 0, 1 ))
				is_hit = true
			else:
				print("too far away")

