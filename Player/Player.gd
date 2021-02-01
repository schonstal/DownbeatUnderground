extends Node2D

onready var dash_animation = $DashAnimation
onready var block_animation = $BlockAnimation
onready var animation = $AnimationPlayer
onready var sprite = $Sprite

var STATE_IDLE = "idle"
var STATE_ATTACK = "attack"
var STATE_BLOCK = "block"
var STATE_DODGE_LEFT = "dodge_left"
var STATE_DODGE_RIGHT = "dodge_right"

var lane = Game.LANE_LEFT

var state = STATE_IDLE

var max_health = 100.0
var health = 100.0
var blocking = false

func _ready():
  EventBus.connect("beat_hit", self, "_on_beat_hit")
  EventBus.connect("player_damage", self, "_on_player_damage")

func idle():
  if lane == Game.LANE_LEFT:
    sprite.scale.x = 1
  else:
    sprite.scale.x = -1
  animation.play("Idle")

  change_state(STATE_IDLE)

  EventBus.emit_signal("player_attack", {
    "lane": lane
  })

func attack():
  animation.stop()
  animation.play("Attack")

  change_state(STATE_ATTACK)

  EventBus.emit_signal("player_attack", {
    "damage": 10,
    "lane": lane
  })

func block():
  blocking = true
  if lane == Game.LANE_LEFT:
    sprite.scale.x = -1
  else:
    sprite.scale.x = 1

  animation.stop()
  animation.play("Block")

  change_state(STATE_BLOCK)

  EventBus.emit_signal("player_attack", {
    "lane": lane
  })

func dodge_left():
  lane = Game.LANE_LEFT
  animation.stop()
  animation.play("Dodge Left")
  dash_animation.stop()
  dash_animation.play("Dash")

  change_state(STATE_DODGE_LEFT)

  EventBus.emit_signal("player_attack", {
    "lane": lane
  })

func dodge_right():
  lane = Game.LANE_RIGHT
  animation.stop()
  animation.play("Dodge Right")
  dash_animation.stop()
  dash_animation.play("Dash")

  change_state(STATE_DODGE_RIGHT)

  EventBus.emit_signal("player_attack", {
    "lane": lane
  })

func change_state(new_state):
  self.state = new_state

func hurt(damage):
  if lane == Game.LANE_LEFT:
    sprite.scale.x = -1
  else:
    sprite.scale.x = 1

  if blocking:
    health -= damage - 8
    block_animation.play("Block")
  else:
    health -= damage
    animation.play("Hurt")

  if health <= 0:
    health = 0
    die()

  EventBus.emit_signal("player_hurt", { "health": health, "max_health": max_health })

func die():
  pass

func _on_player_damage(data:Dictionary):
  hurt(data.damage)

func _on_beat_hit(data:Dictionary):
  blocking = false
  if data.judgement < 0:
    idle()
    return

  if data.action == STATE_ATTACK:
    attack()
  elif data.action == STATE_BLOCK:
    block()
  elif data.action == STATE_DODGE_LEFT:
    dodge_left()
  elif data.action == STATE_DODGE_RIGHT:
    dodge_right()
