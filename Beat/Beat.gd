extends Node2D

var keys = [
  KEY_UP,
  KEY_DOWN,
  KEY_LEFT,
  KEY_RIGHT
 ]

var beat = 0
var note_speed = 0.0004

var target_position = 512
var start_position = -20
var moving = true
var active = true

# microseconds
onready var target_time = (beat / Conductor.bps) * 1000000.0

func _ready():
  position.x = -2000

func _process(delta):
  move()

func move():
  if moving:
    var delta = Conductor.time_elapsed - target_time
    position.x = target_position + delta * note_speed
  
func _input(event):
  if event is InputEventKey:
    if event.pressed:
      var delta = Conductor.time_elapsed - target_time
        
      if abs(delta) < 102000:
        hit(delta, event.scancode)
      
func hit(delta, scancode):
  if !(keys.has(scancode) && active):
    return

  active = false
  moving = false
  Conductor.presses += 1
  Conductor.error_total += delta
  Conductor.average_error = Conductor.error_total / Conductor.presses
  print("average error: ", Conductor.average_error)
  
  var timing = "early"
  if delta > 0:
    timing = "late"
  
  var judgement = "great"
  if abs(delta) < 21500:
    judgement = "fantastic"
  elif abs(delta) < 43000:
    judgement = "excellent"

  EventBus.emit_signal("beat_hit", {
    "judgement": judgement,
    "key": scancode
  })
  
  queue_free()
