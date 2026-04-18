class_name IdleSequence
extends AttackSequence

func _init():
	super(["idle"])

func get_next_sequence():
	var next = [LeftSequence, LeftSequence, RightSequence, RightSequence, SweepSequence, SweepSequence, ParadiddleSequence]
	return next[randi() % next.size()]
