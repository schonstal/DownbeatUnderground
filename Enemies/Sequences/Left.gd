var AttackSequence = preload("res://Enemies/AttackSequence.gd")

extends AttackSequence

var sequence = ["tell", "left"]

func get_next_sequence():
  return "Idle"
