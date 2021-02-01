extends Sprite

export var scroll_rate = 20

func _process(delta):
  region_rect.position.x += scroll_rate * delta
