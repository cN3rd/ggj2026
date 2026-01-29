extends Area2D

#東能

const SCREEN_SIZE = Vector2(1920, 1080)
const SPEED = 1000
@export var health : int = 100
@export var margin : float = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)


func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	position += direction * SPEED * delta
	position.x = clampf(position.x, margin, SCREEN_SIZE.x - margin)
	position.y = clampf(position.y, margin, SCREEN_SIZE.y - margin)


func _on_area_entered(area: Area2D) -> void:
	var shot: Shot = area.get_parent() as Shot
	if shot == null:
		return
	if shot.already_hit:
		return
	shot.already_hit = true
	shot.impact.emit()
	var damage := shot.damage
	if health > damage:
		health -= damage
	else:
		health = 0
		get_tree().reload_current_scene()
