extends "res://Enemies/AttackSequence.gd"

func _init().(["tell", "left", "right", "right", "left", "right", "left", "left", "right"]):
  EventBus.emit_signal("play_sound", { "node_name": "Dislike" })
  pass

func get_next_sequence():
  var next = ["Idle", "Left", "Left", "Paradiddle"]
  return next[randi() % next.size()]
