extends Node

# Signal order is not deterministic
# So we need to resolve the order here
func _ready():
  EventBus.connect("player_attack", self, "_on_player_attack")
  EventBus.connect("enemy_attack", self, "_on_enemy_attack")
