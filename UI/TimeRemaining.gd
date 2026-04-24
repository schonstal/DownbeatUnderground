extends Label

var update = true

func _ready():
  EventBus.game_over.connect(_on_game_over)

func _on_game_over(_data:Dictionary):
  text = "0:00"
  update = false

func _process(_delta):
  if !update:
    text = "0:00"
    return

  var seconds_remaining = (Conductor.song_length - Conductor.time_elapsed / 1000000.0)
  var minutes = int(seconds_remaining / 60.0)
  var seconds = int(seconds_remaining) % 60
  text = "%d:%02d" % [minutes, seconds]
