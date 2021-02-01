extends Node

signal track_selected(data)
signal beat(data)
signal beat_hit(data)
signal play_sound(data)

# Enemy
signal enemy_attack(data)
signal enemy_damage(data)
signal enemy_hurt(data)

# Player
signal player_attack(data)
signal player_damage(data)
signal player_hurt(data)

# Gameplay
signal game_over(data)
