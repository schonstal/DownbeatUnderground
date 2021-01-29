extends Node2D

# YEP! I'm hardcoding strings. It's a game jam. DEAL WITH IT.
var keys = {
    KEY_UP: "attack",
    KEY_DOWN: "block",
    KEY_LEFT: "dodge_left",
    KEY_RIGHT: "dodge_right"
}

var beat = 0
var note_speed = 0.0004

var target_position = 512
var start_position = -20
var moving = true
var active = true
var miss_time = 102000

# microseconds
onready var target_time = (beat / Conductor.bps) * 1000000.0

func _ready():
  position.x = -2000

func _process(delta):
  move()
  if Conductor.time_elapsed - target_time > Conductor.TIME_GREAT:
    miss()

func move():
  if moving:
    var delta = Conductor.time_elapsed - target_time
    position.x = target_position + delta * note_speed

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
