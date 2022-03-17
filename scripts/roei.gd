extends StaticBody
var dot_scene = preload("res://scenes/red_sphere.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_parent().get_parent().get_parent().get_node("Player/Rotation_Helper/Gun_Fire_Points/Rifle_Point").connect("hit_roei",self,"_on_got_hit")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _on_got_hit(collision_point):
	print("aaa")
	print(collision_point)
	var clone = dot_scene.instance()
	var scene_root = get_tree().root.get_children()[0]
	scene_root.add_child(clone)
	clone.global_transform.origin = collision_point
