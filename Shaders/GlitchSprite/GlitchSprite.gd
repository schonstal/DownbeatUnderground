extends Sprite2D

func _ready():
  set_material(material.duplicate())

var time = 0
func _process(delta):
  material.set_shader_parameter("time", time)
  time += delta
