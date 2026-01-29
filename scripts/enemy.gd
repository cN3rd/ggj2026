extends Node2D

@export var health : int = 10
@onready var area_2d: Area2D = $Area2D
@export var shot_layer : Node2D


var killed : bool = false



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)


func shoot(shot: PackedScene) -> void:
	if killed:
		return
	var shotInstance : Node2D = shot.instantiate()
	shotInstance.position = shot_layer.to_local(self.global_position)
	shot_layer.add_child(shotInstance)
	

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
		queue_free()
