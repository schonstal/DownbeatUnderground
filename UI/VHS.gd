extends BackBufferCopy

onready var tween = $Tween
onready var color_rect = $ColorRect

func _ready():
  EventBus.connect("player_damage", self, "_on_player_damage")
  color_rect.visible = false

func _on_player_damage(_data:Dictionary):
  tween.stop_all()
  color_rect.visible = true
  tween.interpolate_property(
      color_rect.material,
      "shader_param/strength",
      1,
      0,
      0.2,
      Tween.TRANS_QUAD,
      Tween.EASE_OUT)
  tween.start()
  yield(tween, "tween_completed")
  color_rect.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#  pass
