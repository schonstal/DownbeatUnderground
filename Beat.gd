extends Node2D

var beat = 0
var note_speed = 0.0004

var target_position = 512
var start_position = -20
var moving = true

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
        
      if abs(delta) < 180000:
        hit(delta)
      
func hit(delta):
      moving = false
      modulate = Color(1, 1, 1, 0.1)
      Conductor.presses += 1
      Conductor.error_total += delta
      Conductor.average_error = Conductor.error_total / Conductor.presses
      print("average ", Conductor.average_error)
      
      var timing = "early"
      if delta > 0:
        timing = "late"
      
      if abs(delta) < 21500:
        print("fantastic ", timing, ": ", delta)
      elif abs(delta) < 43000:
        print("excellent ", timing, ": ", delta)
      elif abs(delta) < 102000:
        print("great ", timing, ": ", delta)
      else:
        print("way off ", timing, ": ", delta)
