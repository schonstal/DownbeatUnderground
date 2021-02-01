extends Node

var bpm = 140.0
var bps = bpm / 60.0
var beats_per_bar = 4
var beat = 0
var time = 0

var average_error = 0.0
var error_total = 0.0
var presses = 0
var song_start_time = 0.0
var time_elapsed setget ,get_time_elapsed
var song_length setget ,get_length

var TIME_GREAT = 102000
var TIME_EXCELLENT = 43000
var TIME_FANTASTIC = 21500

export(Resource) var stream = preload("res://Music/metalstep140.ogg")

var audio_stream_player

func _ready():
  EventBus.connect("track_selected", self, "_on_track_selected")
  EventBus.connect("game_over", self, "_on_game_over")
  audio_stream_player = AudioStreamPlayer.new()

func play_track():
  if audio_stream_player != null:
    audio_stream_player.queue_free()
  audio_stream_player = AudioStreamPlayer.new()
  call_deferred("add_child", audio_stream_player)
  audio_stream_player.stream = stream

  var time_delay = AudioServer.get_time_to_next_mix() +\
                   AudioServer.get_output_latency()
  beat = 0

  yield(get_tree().create_timer(time_delay), "timeout")
  print(time_delay)

  song_start_time = OS.get_ticks_usec()
  audio_stream_player.play()

func _process(_delta: float):
  time = (
    audio_stream_player.get_playback_position() +
    AudioServer.get_time_since_last_mix() -
    AudioServer.get_output_latency()
  )

  var next_beat = int(time * bps)

  if next_beat > beat:
    beat = next_beat
    EventBus.emit_signal("beat", {
      "beat": beat,
      "measure": int(beat / beats_per_bar)
    })

func _on_track_selected(track:Dictionary):
  #print(track.stream)
  #audio_stream_player.stream = load(track.stream)
  #bpm = track.bpm
  play_track()

func _on_game_over(data:Dictionary):
  audio_stream_player.stop()

func get_time_elapsed():
  if audio_stream_player.playing:
    return OS.get_ticks_usec() - song_start_time - 35008
  else:
    return 0

func get_length():
  return audio_stream_player.stream.get_length()
