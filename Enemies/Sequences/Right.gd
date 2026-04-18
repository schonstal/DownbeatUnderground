class_name RightSequence
extends AttackSequence

func _init():
	super(["tell", "right"])
  pass

func get_next_sequence():
  return "Idle"
