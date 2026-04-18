class_name SweepSequence
extends AttackSequence

func _init():
	super(["tell", "tell", "sweep"])

func get_next_sequence():
	return IdleSequence
