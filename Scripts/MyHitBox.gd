class_name MyHitBox
extends Area2D

@export var dmg = 10

func _init():
	collision_layer = 10
	collision_mask = 11 
