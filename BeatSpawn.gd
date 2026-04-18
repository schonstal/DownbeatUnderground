extends Node

@export var beat_scene: Resource = preload("res://Beat/Beat.tscn")

var next_beat = 15
@onready var tempo_spawn = $TempoSpawn

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

@export var stream: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
  EventBus.beat.connect(_on_beat)
  EventBus.emit_signal("track_selected", { "bpm": 80, "stream": stream })

func _on_beat(data:Dictionary):
  spawn_beat()

func spawn_beat():
  next_beat += 1
  var instance = beat_scene.instantiate()
  instance.position.y = tempo_spawn.position.y
  instance.beat = next_beat
  call_deferred("add_child", instance)
