extends Node2D

onready var animation = $AnimationPlayer
onready var sprite = $Sprite

var STATE_IDLE = "idle"
var STATE_ATTACK = "attack"
var STATE_BLOCK = "block"
var STATE_DODGE_LEFT = "dodge_left"
var STATE_DODGE_RIGHT = "dodge_right"

var lane = Game.LANE_LEFT

var state = STATE_IDLE

var health = 30

func _ready():
  EventBus.connect("beat_hit", self, "_on_beat_hit")

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

  change_state(STATE_DODGE_LEFT)

  EventBus.emit_signal("player_attack", {
    "lane": lane
  })

func dodge_right():
  lane = Game.LANE_RIGHT
  animation.stop()
  animation.play("Dodge Right")

  change_state(STATE_DODGE_RIGHT)

  EventBus.emit_signal("player_attack", {
    "lane": lane
  })

func change_state(new_state):
  self.state = new_state

func hurt(damage):
  health -= damage

  if health <= 0:
    health = 0
    die()

func die():
  pass

func _on_beat_hit(data:Dictionary):
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
