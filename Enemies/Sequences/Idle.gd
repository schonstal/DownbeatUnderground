extends "res://Enemies/AttackSequence.gd"

func _init().(["idle"]):
  pass

func get_next_sequence():
  var next = ["Idle", "Idle", "Idle", "Left", "Left", "Right", "Right", "Sweep", "Sweep", "Paradiddle"]
  return next[randi() % next.size()]
