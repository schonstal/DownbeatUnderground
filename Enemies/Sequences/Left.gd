class_name LeftSequence
extends AttackSequence

func _init():
	super(["tell", "left"])

func get_next_sequence():
	return IdleSequence
