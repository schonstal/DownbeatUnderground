extends Node

export(Resource) var beat_scene = preload("res://Beat/Beat.tscn")

var next_beat = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Resource) var stream

# Called when the node enters the scene tree for the first time.
func _ready():
  EventBus.connect("beat", self, "_on_beat")
  EventBus.emit_signal("track_selected", { "bpm": 80, "stream": stream })
  
  for i in range(0, 12):
    spawn_beat()
  
func _on_beat(data:Dictionary):
  spawn_beat()

func spawn_beat():
  next_beat += 1
  var instance = beat_scene.instance()
  instance.beat = next_beat
  call_deferred("add_child", instance)
