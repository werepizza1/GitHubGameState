extends States
class_name Idle
@onready var player: Player = $"../.."
@onready var animation: AnimatedSprite2D = $"../../Animation"
@onready var hit_box_shape: CollisionShape2D = $"../../Animation/HitBox/HitBoxShape"

func Enter():
	var hspx = hit_box_shape.position.x
	if player.get_input() < 0.000 and hspx > 0 or player.get_input() > 0.000 and hspx < 0:
		hit_box_shape.position.x *= -1 
	var animation_name = "Idle"
	
	if Input.is_action_just_pressed("shoot"):
		animation_name = "Attack"
	else:
		animation_name = "Idle"
	animation.play(animation_name)


func Phy_Update(_delta):
	if not player.is_on_floor():
		transition.emit(self, "Air")

	player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.get_speed())

	if Input.is_action_just_pressed("jump") and is_zero_approx(player.get_input()):
		player.can_jump = true
		transition.emit(self,"Air")

	if not is_zero_approx(player.get_input()):
		transition.emit(self, "Run")

	if Input.is_action_just_pressed("shoot") and player.can_jump == false and is_zero_approx(player.get_input()):
		transition.emit(self, "Attacking")

	player.move_and_slide()
	player.reset_char()
