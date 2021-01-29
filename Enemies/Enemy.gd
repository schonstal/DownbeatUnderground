extends Node

func _ready():
  EvenntBus.connect("beat_hit", self, "_on_beat_hit")

func _on_beat_hit(_data:Dictionary):
  tick()

func tick():
  print("tick")
