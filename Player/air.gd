extends States
class_name Air
@onready var player: Player = $"../.."
@onready var animation: AnimatedSprite2D = $"../../Animation"
@onready var hit_box_shape: CollisionShape2D = $"../../Animation/HitBox/HitBoxShape"
@onready var air: Air = $"."
var finished = false
var animation_name = "Jump"

func Enter():
	if player.can_jump == true and player.jump_count < player.MAX_JUMP:
		player.jump_count += 1
		player.velocity.y = player.JUMP_VELOCITY
	animation.play(animation_name)

func Exit():
	player.jump_count = 0
	player.can_jump = false

#func Update():
#	if player.velocity < -1:
		
func Phy_Update(delta):
	if player.is_on_floor():
		if is_zero_approx(player.get_input()):
			transition.emit(self, "Idle")
		else:
			transition.emit(self,"Run")

	if not is_zero_approx(player.get_input()):
		player.velocity.x = move_toward(player.velocity.x, player.get_input() * player.get_speed(), player.acceleration * player.get_speed())
	else:
		player.velocity.x = move_toward(player.velocity.x, 0.0, player.friction * player.get_speed())

	if Input.is_action_just_pressed("jump"):
		Enter()
	
	if Input.is_action_just_pressed("shoot"):
		transition.emit(self, "Attacking")
	
	var hspx = hit_box_shape.position.x
	if player.get_input() < 0.0 and hspx > 0 or player.get_input() > 0.0 and hspx < 0:
		hit_box_shape.position.x *= -1 

	player.velocity += player.get_gravity() * delta
	player.move_and_slide()
	player.reset_char()
	
func attack_finished():
	finished = true
