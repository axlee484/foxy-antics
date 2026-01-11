extends Node2D

class_name  BulletBase

@export var MAX_LIFE_TIME = 10
@export var MAX_DAMAGE: float = 1
var speed: float
var damage: float
var direction: Vector2 = Vector2.RIGHT
var lifeTime = 0;
var isAlive = true



func setup(_speed: float, _direction: Vector2, _position: Vector2, maxLifeTime = MAX_LIFE_TIME):
	speed = _speed
	direction = _direction
	global_position = _position
	if(maxLifeTime):
		MAX_LIFE_TIME = maxLifeTime



func checkIfDied():
	if lifeTime > MAX_LIFE_TIME:
		die()

func die():
	if isAlive:
		isAlive = false
		set_process(false)
		queue_free()

func _process(delta: float) -> void:
	lifeTime+=delta
	damage = MAX_DAMAGE/(lifeTime+1)
	checkIfDied()
	global_position += speed*(direction).normalized()*delta


func _on_area_2d_area_entered(_area: Area2D) -> void:
	die()


func _on_area_2d_body_entered(_body: Node2D) -> void:
	die()
