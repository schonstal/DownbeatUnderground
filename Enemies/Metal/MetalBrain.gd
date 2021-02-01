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
onready var death = $Body/Death
onready var victory = $Body/Victory

onready var big_tell = $Body/BigTell
onready var big_tell_arms = $Body/BigTellArms
onready var big_raised_arm = $Body/BigTellArms/Raised
onready var big_horizontal_arm = $Body/BigTellArms/Horizontal
onready var big_lowered_arm = $Body/BigTellArms/Lowered

var state = STATE_READY

var sequences = {}
var start_sequence = "Idle"

var next_action = null
var current_action = null
var previous_action = "idle"

signal tick

onready var animation = $AnimationPlayer

var max_health = 700.0
var health = 700.0

func _ready():
  sequences = load_sequences()
  EventBus.connect("beat_hit", self, "_on_beat_hit")
  EventBus.connect("enemy_damage", self, "_on_enemy_damage")
  EventBus.connect("game_over", self, "_on_game_over")
  hide_body()
  victory.visible = true
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

func _on_game_over(data:Dictionary):
  if data.victor == "enemy":
    yield(get_tree().create_timer(0.5), "timeout")
    hide_body()
    victory.visible = true
    animation.play("Victory")
  else:
    hide_body()
    death.visible = true
    animation.play("Death")

func _on_beat_hit(data:Dictionary):
  emit_signal("tick")

func _on_enemy_damage(data:Dictionary):
  if previous_action == "idle" && current_action == "idle":
    block()
  else:
    health -= data.damage
    if health <= 0:
      health = 0
      EventBus.emit_signal("game_over", { "type": "ko", "victor": "player" })
      EventBus.emit_signal("play_sound", { "node_name": "EnemyDeath" })
    else:
      EventBus.emit_signal("play_sound", { "node_name": "EnemyHurt%s" % (randi() % 4 + 1) })

    EventBus.emit_signal("enemy_hurt", { "health": health, "max_health": max_health })

func perform_sequences():
  var sequence = sequences.Left.new()

  while true:
    for action in sequence:
      yield(self, "tick")
      previous_action = current_action
      current_action = action
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

func show_big_tell_arm(arm):
  big_tell_arms.visible = true
  big_raised_arm.visible = false
  big_horizontal_arm.visible = false
  big_lowered_arm.visible = false

  if arm == "raised":
   big_raised_arm.visible = true
  elif arm == "horizontal":
   big_horizontal_arm.visible = true
  elif arm == "lowered":
   big_lowered_arm.visible = true

func hide_body():
  idle.visible = false
  tell_arm.visible = false
  tell.visible = false
  block.visible = false
  sweep.visible = false
  slash.visible = false
  eye.visible = false
  eye.offset.x = 0
  victory.visible = false
  death.visible = false
  big_tell.visible = false
  big_tell_arms.visible = false

func block():
  hide_body()
  block.visible = true
  animation.stop()
  animation.play("Block")

func action_idle():
  hide_body()
  idle.visible = true
  animation.stop()
  animation.play("Idle")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_big_tell():
  hide_body()
  EventBus.emit_signal("play_sound", { "node_name": "ParadiddleRoar" })
  big_tell.visible = true
  animation.stop()
  animation.play("BigTell")
  show_big_tell_arm("horizontal")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_tell():
  hide_body()
  eye.visible = true
  if next_action == "left":
    body.scale.x = 1
    eye.offset.x = -3
    show_tell_arm("raised")
  elif next_action == "right":
    body.scale.x = -1
    eye.offset.x = -3
    show_tell_arm("raised")
  elif next_action == "sweep":
    show_tell_arm("horizontal")
  else:
    show_tell_arm("lowered")

  tell.visible = true
  animation.stop()
  animation.play("Tell")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_NONE })

func action_left():
  hide_body()
  slash.visible = true
  eye.visible = true
  eye.flash()
  if next_action == "left":
    show_tell_arm("lowered")
    eye.position = Vector2(3, -82)
  elif next_action == "sweep":
    show_tell_arm("horizontal")
    eye.position = Vector2(-1, -82)
  elif next_action == "right":
    show_tell_arm("raised")
    eye.position = Vector2(-5, -82)
  else:
    show_tell_arm("lowered")
    eye.position = Vector2(-1, -82)

  animation.stop()
  animation.play("Left")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_LEFT, "damage": 10 })

func action_right():
  hide_body()
  slash.visible = true
  eye.visible = true
  eye.flash()
  if next_action == "left":
    show_tell_arm("raised")
    eye.position = Vector2(-5, -82)
  elif next_action == "sweep":
    show_tell_arm("horizontal")
    eye.position = Vector2(0, -82)
  elif next_action == "right":
    show_tell_arm("lowered")
    eye.position = Vector2(3, -82)
  else:
    show_tell_arm("lowered")
    eye.position = Vector2(-1, -82)

  animation.stop()
  animation.play("Right")
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_RIGHT, "damage": 10 })

func action_sweep():
  hide_body()
  animation.play("Sweep")
  sweep.visible = true
  EventBus.emit_signal("enemy_attack", { "lane": Game.LANE_BOTH, "damage": 10 })
