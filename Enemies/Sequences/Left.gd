class_name LeftSequence
extends AttackSequence

func _init():
	super(["tell", "left"])
  pass

func get_next_sequence():
  return "Idle"
