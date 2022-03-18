extends Spatial

const DAMAGE = 4
signal hit_roei
const IDLE_ANIM_NAME = "Rifle_idle"
const FIRE_ANIM_NAME = "Rifle_fire"
var speed = 5
var is_weapon_enabled = false
var position_of_collision
var player_node = null
var first_pos
onready var wire = $Ray_Cast/wire
func _ready():
	pass

func fire_weapon():
	var ray = $Ray_Cast
	ray.force_raycast_update()

	if ray.is_colliding():
		var body = ray.get_collider()

		if body == player_node:
			pass
		elif body.has_method("bullet_hit"):
			body.bullet_hit(DAMAGE, ray.get_collision_point())
		elif body.name == "roei":
			emit_signal("hit_roei",ray.get_collision_point())

func fire_grappling_hook():
	var ray = $Ray_Cast
	ray.force_raycast_update()

	if ray.is_colliding():
		var body = ray.get_collider()
		print(body.name)
		if body.name != "":
			wire.visible = true
			#ray.remove_child(wire)
			#get_parent().get_parent().get_parent().get_parent().add_child(wire)
			position_of_collision = ray.get_collision_point()
			get_parent().get_parent().get_parent().position_of_collision = position_of_collision
			print(position_of_collision,get_parent().get_parent().global_transform.origin)
			get_parent().get_parent().get_parent().dir = (position_of_collision - get_parent().get_parent().global_transform.origin).normalized() * speed #a -> b = b-a
			print(get_parent().get_parent().get_parent().dir)
			if position_of_collision.y > get_parent().get_parent().get_parent().global_transform.origin.y:
				#get_parent().get_parent().get_parent().dir.y *= 20
				print("above")
			else:
				print("below")	
			print(get_parent().get_parent().get_parent().dir)
			
func equip_weapon():
	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		is_weapon_enabled = true
		return true

	if player_node.animation_manager.current_state == "Idle_unarmed":
		player_node.animation_manager.set_animation("Rifle_equip")

	return false

func unequip_weapon():

	if player_node.animation_manager.current_state == IDLE_ANIM_NAME:
		if player_node.animation_manager.current_state != "Rifle_unequip":
			player_node.animation_manager.set_animation("Rifle_unequip")

	if player_node.animation_manager.current_state == "Idle_unarmed":
		is_weapon_enabled = false
		return true

	return false
