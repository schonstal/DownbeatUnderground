extends Node

var STATE_READY = "ready"
var STATE_BUSY = "busy"

var state = STATE_READY

func _ready():
  load_sequences()
  EventBus.connect("beat_hit", self, "_on_beat_hit")

func load_sequences():
  var sequences = {}
  var dir = Directory.new()
  dir.open("res://Enemies/Sequences")
  dir.list_dir_begin()

  var file = dir.get_next()
  while file != "":
    if file.ends_with(".gd"):
      sequences[file.filename.rstrip(".gd")] = load(file)
    file = dir.get_next()

  dir.list_dir_end()

  return files

func _on_beat_hit(data:Dictionary):
  tick(data.action)

func tick(player_action):
  if state == STATE_READY:
    start_sequence()
  else:
    perform_next_sequence()

func start_sequence():
  state = STATE_BUSY
  pass

func perform_next_sequence():
  pass

func attack_left():
  print("left")
  EventBus.emit_signal("enemy_attack", { "position": "left" })

func attack_right():
  print("right")
  EventBus.emit_signal("enemy_attack", { "position": "right" })

func attack_mid():
  print("mid")
  EventBus.emit_signal("enemy_attack", { "position": "mid" })
