extends "res://Enemies/AttackSequence.gd"

func _init().(["big_tell", "tell", "left", "right", "right", "left", "right", "left", "left", "right"]):
  pass

func get_next_sequence():
  var next = ["Idle", "Left", "Left", "Paradiddle"]
  return next[randi() % next.size()]
