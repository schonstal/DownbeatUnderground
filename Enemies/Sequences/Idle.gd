class_name IdleSequence
extends AttackSequence

func _init():
	super(["idle"])

func get_next_sequence():
	var next = ["Idle", "Idle", "Idle", "Left", "Left", "Right", "Right", "Sweep", "Sweep", "Paradiddle"]
	return next[randi() % next.size()]
