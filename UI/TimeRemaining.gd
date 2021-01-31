extends Label

func _process(delta):
  var seconds_remaining = (Conductor.song_length - Conductor.time_elapsed / 1000000.0)
  var minutes = int(seconds_remaining) / 60
  var seconds = int(seconds_remaining) % 60
  text = "%d:%02d" % [minutes, seconds]
