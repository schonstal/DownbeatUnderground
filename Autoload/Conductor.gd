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
var time_elapsed : get = get_time_elapsed
var song_length : get = get_length

var TIME_GREAT = 120000
var TIME_EXCELLENT = 43000
var TIME_FANTASTIC = 21500

@export var stream: Resource = preload("res://Music/metalstep140.ogg")

var audio_stream_player
var time_delay := 0.0
var offset_usec := 35008

func _ready():
  EventBus.track_selected.connect(_on_track_selected)
  EventBus.game_over.connect(_on_game_over)
  _prewarm_audio_context()

func _prewarm_audio_context() -> void:
  audio_stream_player = AudioStreamPlayer.new()
  add_child(audio_stream_player)


func play_track():
  audio_stream_player.stream = stream
  audio_stream_player.seek(0.0)
  AudioServer.set_bus_volume_db(0, 0.0)

  beat = 0

  var retries := 0
  while AudioServer.get_output_latency() == 0.0 && retries < 300:
    await get_tree().physics_frame
    retries += 1

  time_delay = AudioServer.get_time_to_next_mix() +\
               AudioServer.get_output_latency()

  song_start_time = Time.get_ticks_usec()
  audio_stream_player.play()

func _physics_process(_delta: float):
  time = get_time_elapsed() - time_delay

  var next_beat = int(time * bps)

  if next_beat > beat:
    beat = next_beat
    EventBus.emit_signal("beat", {
      "beat": beat,
      "measure": int(beat / float(beats_per_bar))
    })

func _on_track_selected(_track:Dictionary):
  #print(track.stream)
  #audio_stream_player.stream = load(track.stream)
  #bpm = track.bpm
  play_track()

func _on_game_over(_data:Dictionary):
  audio_stream_player.stop()

func get_time_elapsed():
  if audio_stream_player.playing:
    return Time.get_ticks_usec() - song_start_time - offset_usec
  else:
    return 0

func get_length():
  return audio_stream_player.stream.get_length()
