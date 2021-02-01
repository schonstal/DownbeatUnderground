extends Node2D

var sequences = {
  "countdown": [2, 2, 1, 1, 0, 0, 3, 3]
}

onready var titles = $Titles
onready var caution_animation = $CautionAnimation
onready var title_animation = $TitleAnimation
onready var countdown_sound = $CountdownSound

onready var game_over_sound = $GameOver
onready var ko_sound = $KO
onready var you_lose_sound = $YouLose

func _ready():
  EventBus.connect("beat", self, "_on_beat")
  EventBus.connect("game_over", self, "_on_game_over")
  caution_animation.play("Appear")

func play(sequence):
  var index = 0
  titles.frame = 8
  #caution_animation.play("Appear")
  for frame in sequences[sequence]:
    if frame != titles.frame:
      title_animation.stop()
      title_animation.play("Appear")
    titles.frame = frame
    yield(EventBus, "beat")
  titles.frame = 8
  caution_animation.stop()
  caution_animation.play_backwards("Appear")

func _on_beat(data:Dictionary):
  if data.beat == 8:
    play("countdown")
    countdown_sound.play()

func _on_game_over(data:Dictionary):
  game_over_sound.play()
  yield(get_tree().create_timer(2.0), "timeout")

  caution_animation.play("Appear")

  if data.type == "ko":
    titles.frame = 4
    ko_sound.play()
  else:
    titles.frame = 5

  title_animation.stop()
  title_animation.play("Appear")

  yield(get_tree().create_timer(1.5), "timeout")

  if data.victor == "player":
    titles.frame = 7
  else:
    you_lose_sound.play()
    titles.frame = 6

  title_animation.stop()
  title_animation.play("Appear")

  yield(get_tree().create_timer(1.5), "timeout")

  titles.frame = 8

  caution_animation.stop()
  caution_animation.play_backwards("Appear")
