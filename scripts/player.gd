extends Area2D

#東能

@onready var weapons: Node2D = $Weapons
@onready var sprite: AnimatedSprite2D = $Sprite
const WEAPON_HEALTH_LEVELS = [70, 30]
const SCREEN_SIZE = Vector2(1920, 1080)
const SPEED = 1000
const MAX_HEALTH = 100
const HEAL_MIN_TIME = 5.0
const HEAL_REPEAT_TIME = 0.03
const DEATH_TIME = 2.0
@export var health : int = MAX_HEALTH
@export var margin : float = 50
@export var explosion: PackedScene = null
@export var armed: bool = true
var last_active_weapon : int = 0
var heal_timer : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	if health <= 0:
		return
	var direction := Input.get_vector("left", "right", "up", "down")
	position += direction * SPEED * delta
	position.x = clampf(position.x, margin, SCREEN_SIZE.x - margin)
	position.y = clampf(position.y, margin, SCREEN_SIZE.y - margin)
	var current_weapon : int = -1
	if armed:
		current_weapon = 0
		while current_weapon < WEAPON_HEALTH_LEVELS.size() && health < WEAPON_HEALTH_LEVELS[current_weapon]:
			current_weapon += 1
	if current_weapon != last_active_weapon:
		last_active_weapon = current_weapon
		_set_active_weapon(current_weapon)
	if health < MAX_HEALTH:
		heal_timer += delta
		while health < MAX_HEALTH && heal_timer > HEAL_MIN_TIME:
			heal_timer -= HEAL_REPEAT_TIME
			health += 1

func _on_area_entered(area: Area2D) -> void:
	if health <= 0:
		return
	var shot: Shot = area.get_parent() as Shot
	if shot == null:
		return
	if shot.already_hit:
		return
	shot.already_hit = true
	shot.impact.emit()
	var damage := shot.damage
	if health > damage:
		heal_timer = 0
		health -= damage
	else:
		if explosion != null:
			var explosion_layer := get_tree().get_first_node_in_group('explosion_layer') as Node2D
			var explosionInstance : Node2D = explosion.instantiate()
			explosionInstance.position = explosion_layer.to_local(self.global_position)
			explosion_layer.add_child(explosionInstance)
		health = 0
		_set_active_weapon(-1)
		visible = false
		#TODO game over screen
		await get_tree().create_timer(DEATH_TIME).timeout
		get_tree().call_deferred('reload_current_scene')

func _set_active_weapon(which: int) -> void:
	if which >= 0 && which <= WEAPON_HEALTH_LEVELS.size():
		sprite.frame = which
	for child in weapons.get_children():
		var weapon := child as Emitter
		if weapon == null:
			continue
		weapon.active = (which == 0)
		which -= 1

func win() -> void:
	#TODO victory screen
	get_tree().call_deferred('reload_current_scene')
