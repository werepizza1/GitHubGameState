extends States
class_name Attacking
@onready var player: Player = $"../.."
@onready var animation: AnimatedSprite2D = $"../../Animation"
@onready var hit_box_shape: CollisionShape2D = $"../../Animation/HitBox/HitBoxShape"
var hbpos
var animation_name = "Attack"
var rotation = 180
var finished = false
var hspx
var displace = 10

func Enter():
	hspx = hit_box_shape.position.x
	hit_box_shape.disabled = false
	
	if hspx < 0:
		hspx += displace
	if hspx > 0:
		hspx -= displace
	
	if Input.is_action_pressed("down") and Input.is_action_just_pressed("shoot"):
		animation_name = "d_attack"
		hit_box_shape.position.y = 21
		hit_box_shape.position.x = hspx
		hit_box_shape.rotation_degrees = rotation
	elif Input.is_action_pressed("up") and Input.is_action_just_pressed("shoot"):
		animation_name = "u_attack"
		hit_box_shape.position.y = -29
		hit_box_shape.position.x = hspx
		hit_box_shape.rotation_degrees = rotation
	else:
		animation_name = "Attack"

	animation.play(animation_name)
	
	if animation.is_connected("animation_finished", attack_finished):
		return
	else:
		animation.connect("animation_finished", attack_finished)
	
func Exit():
	hit_box_shape.disabled = true
	if hspx < 0:
		hspx -= displace
	if hspx > 0:
		hspx += displace
	hit_box_shape.position.x = hspx
	hit_box_shape.position.y = 5
	hit_box_shape.rotation_degrees = 90
	finished = false

func Phy_Update(delta):
	
	if not player.is_on_floor() and finished:
		if Input.is_action_just_pressed("shoot"):
			Enter()
		else:
			transition.emit(self, "Air")

	if not is_zero_approx(player.get_input()) and player.is_on_floor() and finished:
		transition.emit(self, "Run")

	if not is_zero_approx(player.get_input()):
		player.velocity.x = move_toward(player.velocity.x, player.get_input() * player.get_speed(), player.acceleration * player.get_speed())
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.get_speed())

	player.velocity += player.get_gravity() * delta
	player.move_and_slide()

	if is_zero_approx(player.get_input()) and finished:  
		transition.emit(self,"Idle")
	
	if player.get_input() < 0.0 and hspx > 0 or player.get_input() > 0.0 and hspx < 0:
		hit_box_shape.position.x *= -1

func attack_finished():
	player.can_attack = true
	finished = true
