class_name SweepSequence
extends AttackSequence

func _init():
	super(["tell", "tell", "sweep"])
  pass

func get_next_sequence():
  return "Idle"
