extends Node
class_name States

signal transition

func Enter():
	pass

func Exit():
	pass

func Update(_delta):
	pass

func Phy_Update(_delta):
	pass

func declared_here():
	transition.get_name()
	pass
