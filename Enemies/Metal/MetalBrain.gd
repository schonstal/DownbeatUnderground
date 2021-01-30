extends Node2D

var STATE_READY = "ready"
var STATE_BUSY = "busy"

var state = STATE_READY

var sequences = {}
var start_sequence = "Idle"

signal tick

onready var animation = $AnimationPlayer

func _ready():
  sequences = load_sequences()
  EventBus.connect("beat_hit", self, "_on_beat_hit")
  perform_sequences()

func load_sequences():
  var sequences = {}
  var dir = Directory.new()
  dir.open("res://Enemies/Sequences")
  dir.list_dir_begin()

  var file = dir.get_next()
  while file != "":
    if file.ends_with(".gd"):
      sequences[file.get_file().rstrip(".gd")] = load("res://Enemies/Sequences/%s" % file)
    file = dir.get_next()

  dir.list_dir_end()

  return sequences

func _on_beat_hit(data:Dictionary):
  emit_signal("tick")

func perform_sequences():
  var sequence = sequences.Left.new()

  while true:
    for action in sequence:
      yield(self, "tick")
      self.call("action_%s" % action)

    sequence = sequences[sequence.next_sequence].new()


func perform_next_sequence():
  pass

func action_block():
  print("blocked ya!")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_idle():
  animation.stop()
  animation.play("idle")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_tell():
  animation.stop()
  animation.play("tell")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_left():
  animation.stop()
  animation.play("left")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_LEFT })

func action_right():
  animation.stop()
  animation.play("right")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_RIGHT })

func action_mid():
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_BOTH })
