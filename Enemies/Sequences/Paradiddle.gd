class_name ParadiddleSequence
extends AttackSequence

func _init():
	super(["big_tell", "tell", "left", "right", "right", "left", "right", "left", "left", "right"])

func get_next_sequence():
	var next = [IdleSequence, LeftSequence, ParadiddleSequence]
	return next[randi() % next.size()]
