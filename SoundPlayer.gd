extends Node2D

func _ready():
  EventBus.connect("play_sound", self, "_on_play_sound")

func _on_play_sound(data:Dictionary):
  var node = self.find_node(data.node_name)
  if node != null && node.has_method("stop"):
    node.play()
