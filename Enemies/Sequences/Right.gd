class_name RightSequence
extends AttackSequence

func _init():
	super(["tell", "right"])

func get_next_sequence():
	return IdleSequence
