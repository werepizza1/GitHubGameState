class_name MyHurtBox
extends Area2D

func _init():
	collision_layer = 11
	collision_mask = 10

func _ready():
	connect("area_entered", _on_area_entered)

func _on_area_entered(hitbox: MyHitBox):
	if hitbox == null:
		return
	
	if owner.has_method("dmg_taken"):
		owner.dmg_taken(hitbox.position.x)
