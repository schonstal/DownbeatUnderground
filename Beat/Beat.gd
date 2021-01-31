extends Node2D

# YEP! I'm hardcoding strings. It's a game jam. DEAL WITH IT.
var keys = {
    KEY_UP: "attack",
    KEY_DOWN: "block",
    KEY_LEFT: "dodge_left",
    KEY_RIGHT: "dodge_right"
}

onready var icon_left = $IconLeft
onready var icon_right = $IconRight
onready var animation_left = $IconLeft/AnimationPlayer
onready var animation_right = $IconRight/AnimationPlayer

var beat = 0
var note_speed = 0.0003

var target_position = 640
var start_position = -20
var moving = true
var active = true
var miss_time = 102000

var appeared = false

# microseconds
onready var target_time = (beat / Conductor.bps) * 1000000.0

func _ready():
  position.x = 0
  visible = false

func _process(delta):
  move()
  if icon_left.position.x > target_position:
    visible = false
  if Conductor.time_elapsed - target_time > Conductor.TIME_GREAT:
    miss()

func move():
  if moving:
    var delta = Conductor.time_elapsed - target_time
    icon_left.position.x = target_position + delta * note_speed
    icon_right.position.x = target_position + (target_position - icon_left.position.x)

    if !appeared && icon_left.position.x >= 250:
      appeared = true
      visible = true
      animation_left.play("Appear")
      animation_right.play("Appear")

func _input(event):
  if event is InputEventKey:
    if event.pressed:
      var delta = Conductor.time_elapsed - target_time

      if abs(delta) < Conductor.TIME_GREAT:
        hit(delta, event.scancode)

func miss():
  EventBus.emit_signal("beat_hit", {
    "beat": beat,
    "judgement": -1,
    "action": null
  })
  clear_note()

func hit(delta, scancode):
  if !(keys.has(scancode) && active):
    return

  active = false
  moving = false
  Conductor.presses += 1
  Conductor.error_total += delta
  Conductor.average_error = Conductor.error_total / Conductor.presses

  var timing = "early"
  if delta > 0:
    timing = "late"

  var judgement = 0
  if abs(delta) < Conductor.TIME_FANTASTIC:
    judgement = 1
  elif abs(delta) < Conductor.TIME_EXCELLENT:
    judgement = 2

  EventBus.emit_signal("beat_hit", {
    "beat": beat,
    "judgement": judgement,
    "action": keys[scancode]
  })

  clear_note()

func clear_note():
  queue_free()
