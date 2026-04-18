extends Node

func _ready():
  EventBus.beat_hit.connect(_on_beat_hit)

func _on_beat_hit(_data:Dictionary):
  tick()

func tick():
  print("tick")
