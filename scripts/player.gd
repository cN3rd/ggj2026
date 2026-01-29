extends Area2D

#東能

const SPEED = 1000
@export var health : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left", "right", "up", "down")
	position += direction * SPEED * delta


func _on_area_entered(area: Area2D) -> void:
	var shot: Shot = area.get_parent() as Shot
	if shot == null:
		return
	if shot.already_hit:
		return
	shot.already_hit = true
	shot.hit_player.emit()
	var damage := shot.damage
	if health > damage:
		health -= damage
	else:
		health = 0
		get_tree().reload_current_scene()
