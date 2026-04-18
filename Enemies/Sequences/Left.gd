extends "res://Enemies/AttackSequence.gd"

func _init():
	super(["tell", "left"])
  pass

func get_next_sequence():
  return "Idle"
