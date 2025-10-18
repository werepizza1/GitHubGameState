extends CharacterBody2D
class_name Player

var bullet = preload("res://Player/bullet.tscn")
@onready var hit_box: MyHitBox = $Animation/HitBox
@onready var animation: AnimatedSprite2D = $Animation
@onready var iframe_timer: Timer = $Iframe
@onready var marker_2d: Marker2D = $Marker2D
const MAX_JUMP = 2
const RUN_SPEED = 250
const WALKING_SPEED = 150
const JUMP_VELOCITY = -400
@export var friction = .2
@export var acceleration = .1
var can_jump = false
var can_attack = false
var player_speed
var jump_count = 0
var player_hp = 10
var cd 
var direction
var marker

func get_input():
	direction = Input.get_axis("left", "right")

	if direction < 0:
		animation.flip_h = true
	if direction > 0:
		animation.flip_h = false
	
	return direction

func get_speed():
	if Input.is_action_pressed("run"):
		player_speed = RUN_SPEED
	else:
		player_speed = WALKING_SPEED
	return player_speed

func dmg_taken(posx):
	iframe_timer.start(.5)
	player_hp -= 1
	velocity.y = JUMP_VELOCITY * .7
	set_modulate(Color(100,1,1,.5))
	return player_hp

func reset_char():
	#Reset whole scene and not just position
	if Input.is_action_just_pressed("Reset") or player_hp == 0:
		get_tree().reload_current_scene()

func _on_iframe_timeout():
	set_modulate(Color.WHITE)
