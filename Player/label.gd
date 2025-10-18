extends Label
@onready var player: Player = $".."

func _ready():
	var state = player.get_node("State_Manager")
	var state_name = state.get_state_name()
	text = str("State: ", state_name , "Hp: ", player.player_hp)

func _process(_delta):
	_ready()
