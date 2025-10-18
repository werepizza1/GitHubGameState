extends States
class_name Run
@onready var player: Player = $"../.."
@onready var animation: AnimatedSprite2D = $"../../Animation"
@onready var hit_box_shape: CollisionShape2D = $"../../Animation/HitBox/HitBoxShape"
var animation_name = "Run"

func Enter():
	var hspx = hit_box_shape.position.x
	if player.get_input() < 0.000 and hspx > 0 or player.get_input() > 0.000 and hspx < 0:
		hit_box_shape.position.x *= -1 
	animation.play(animation_name)

func Exit():
	return

func Phy_Update(_delta):

	if not player.is_on_floor():
		transition.emit(self, "Air")

	if Input.is_action_just_pressed("jump"):
		player.can_jump = true
		transition.emit(self,"Air")

	if Input.is_action_just_pressed("shoot"):
		transition.emit(self, "Attacking")

	if is_zero_approx(player.get_input()):
		transition.emit(self,"Idle")

	if not is_zero_approx(player.get_input()):
		player.velocity.x = move_toward(player.velocity.x, player.get_input() * player.get_speed(), player.acceleration * player.get_speed())

	
	player.move_and_slide()
	
