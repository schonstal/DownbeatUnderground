var AttackSequence = preload("res://Enemies/AttackSequence.gd")

extends AttackSequence

var sequence = ["idle"]

func get_next_sequence():
  return "Left"
