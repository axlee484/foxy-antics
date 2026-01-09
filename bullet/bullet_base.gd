extends Node2D


@export var MAX_LIFE_TIME = 10
var speed: float
var direction: Vector2 = Vector2.RIGHT
var lifeTime = 0;



func setup(_speed: float, _direction: Vector2, _position: Vector2, maxLifeTime = MAX_LIFE_TIME):
	speed = _speed
	direction = _direction
	global_position = _position
	if(maxLifeTime):
		MAX_LIFE_TIME = maxLifeTime



func checkIfDied():
	if lifeTime > MAX_LIFE_TIME:
		set_process(false)
		queue_free()



func _process(delta: float) -> void:
	lifeTime+=delta
	checkIfDied()
	global_position += speed*(direction).normalized()*delta
