extends Node2D

var STATE_READY = "ready"
var STATE_BUSY = "busy"

onready var raised_arm = $Body/TellArm/Raised
onready var horizontal_arm = $Body/TellArm/Horizontal
onready var lowered_arm = $Body/TellArm/Lowered
onready var body = $Body

onready var idle = $Body/Idle
onready var tell = $Body/Tell
onready var tell_arm = $Body/TellArm
onready var block = $Body/Block
onready var sweep = $Body/Sweep
onready var slash = $Body/Slash
onready var eye = $Body/Eye

var state = STATE_READY

var sequences = {}
var start_sequence = "Idle"

var next_action = null

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
      next_action = sequence.next_action
      call("action_%s" % action)

    sequence = sequences[sequence.next_sequence].new()

func show_tell_arm(arm):
  tell_arm.visible = true
  raised_arm.visible = false
  horizontal_arm.visible = false
  lowered_arm.visible = false

  if arm == "raised":
   raised_arm.visible = true
  elif arm == "horizontal":
   horizontal_arm.visible = true
  elif arm == "lowered":
   lowered_arm.visible = true

func hide_body():
  idle.visible = false
  tell_arm.visible = false
  tell.visible = false
  block.visible = false
  sweep.visible = false
  slash.visible = false
  eye.visible = false

func action_block():
  hide_body()
  block.visible = true
  animation.stop()
  animation.play("Block")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_idle():
  hide_body()
  idle.visible = true
  animation.stop()
  animation.play("Idle")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_tell():
  hide_body()
  if next_action == "left":
    body.scale.x = 1
    show_tell_arm("raised")
  elif next_action == "right":
    body.scale.x = -1
    show_tell_arm("raised")
  else:
    show_tell_arm("horizontal")

  tell.visible = true
  animation.stop()
  animation.play("Tell")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_left():
  hide_body()
  slash.visible = true
  if next_action == "left":
    show_tell_arm("lowered")
  elif next_action == "sweep":
    show_tell_arm("horizontal")
  elif next_action == "right":
    show_tell_arm("raised")
  else:
    show_tell_arm("lowered")

  animation.stop()
  animation.play("Left")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_LEFT, "damage": 10 })

func action_right():
  hide_body()
  slash.visible = true
  if next_action == "left":
    show_tell_arm("raised")
  elif next_action == "sweep":
    show_tell_arm("horizontal")
  elif next_action == "right":
    show_tell_arm("lowered")
  else:
    show_tell_arm("lowered")

  animation.stop()
  animation.play("Right")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_RIGHT, "damage": 10 })

func action_sweep():
  hide_body()
  animation.play("Sweep")
  sweep.visible = true
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_BOTH, "damage": 10 })
