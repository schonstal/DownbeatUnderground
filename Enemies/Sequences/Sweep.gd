extends "res://Enemies/AttackSequence.gd"

func _init():
	super(["tell", "tell", "sweep"])
  pass

func get_next_sequence():
  return "Idle"
