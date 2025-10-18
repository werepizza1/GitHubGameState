extends CharacterBody2D
@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var floor_checker: RayCast2D = $FloorChecker
@onready var movement_collision: CollisionShape2D = $MovementCollision
@onready var sides: CollisionShape2D = $MyHitBox/Sides
@onready var marker_2d: Marker2D = $Marker2D
@onready var timer: Timer = $Timer

const JUMP_VELOCITY = -400
var animated_name = "Idle"
var dir = -1
var rng = RandomNumberGenerator.new()
var speed
var hp
@export var detects_cliffs = true
var size

func _ready():
	size = animated
	speed = rng.randf_range(5, 10)
	sides.position.x *= dir
	if dir < 0:
		animated.flip_h = true
	if dir > 0:
		animated.flip_h = false
	animated.play(animated_name)
	
	hp = 5
	floor_checker.position.x = round(movement_collision.shape.get_rect().size.x) * dir
	floor_checker.enabled = detects_cliffs
	
func _physics_process(delta):
	if is_on_wall() or not floor_checker.is_colliding() and detects_cliffs and is_on_floor():
		dir = dir * -1
		floor_checker.position.x = round(movement_collision.shape.get_rect().size.x) * dir
		sides.position.x *= -1 
	if dir < 0:
		animated.flip_h = true
	if dir > 0:
		animated.flip_h = false
	velocity.x = speed * dir
	
	velocity += get_gravity() * delta
	move_and_slide()
	if hp == 0:
		die()

func dmg_taken(posx):
	timer.start(.5)
	hp -= 1
	velocity.y = JUMP_VELOCITY * .7
	set_modulate(Color(100,1,1,.5))
	return hp

func die():
	queue_free()

func _on_timer_timeout():
	set_modulate(Color.WHITE)
