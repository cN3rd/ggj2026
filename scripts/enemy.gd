extends Node2D

@export var health : int = 10
@onready var area_2d: Area2D = $Area2D
@onready var shots: Emitter = $Shots
var killed : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_entered(area: Area2D) -> void:
	if killed:
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
		health -= damage
	else:
		#TODO: Spawn enemy death animation
		health = 0
		killed = true
		shots.active = false
		queue_free()
