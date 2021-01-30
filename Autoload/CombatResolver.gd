extends Node

var enemy_attack = null
var player_attack = null

# Signal order is not deterministic
# So we need to resolve the order here
func _ready():
  EventBus.connect("player_attack", self, "_on_player_attack")
  EventBus.connect("enemy_attack", self, "_on_enemy_attack")
  reset_flags()

func reset_flags():
  enemy_attack = null
  player_attack = null

func attempt_resolve():
  if enemy_attack == null || player_attack == null:
    return

  resolve_combat()

  reset_flags()

func resolve_combat():
  print(enemy_attack)
  print(player_attack)
  if enemy_attack.has("lane") && player_attack.has("lane") &&\
     enemy_attack.lane & player_attack.lane > 0:
      if enemy_attack.has("damage"):
        EventBus.emit_signal("player_damage", { "damage": enemy_attack.damage })
  elif player_attack.has("damage"):
    EventBus.emit_signal("enemy_damage", { "damage": player_attack.damage })

func _on_player_attack(data:Dictionary):
  player_attack = data
  attempt_resolve()

func _on_enemy_attack(data:Dictionary):
  enemy_attack = data
  attempt_resolve()
