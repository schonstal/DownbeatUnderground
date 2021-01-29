extends Node

var STATE_READY = "ready"
var STATE_BUSY = "busy"

var state = STATE_READY

var sequences = {
}

func _ready():
  EvenntBus.connect("beat_hit", self, "_on_beat_hit")

func _on_beat_hit(_data:Dictionary):
  tick()

func tick():
  if state == STATE_READY:
    start_sequence()
  else:
    perform_next_sequence()

func start_sequence():
  state = STATE_BUSY
  pass

func perform_next_sequence():
  pass
