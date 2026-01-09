extends CharacterBody2D

class_name EnemyBase

enum FACE_DIRECTION {LEFT = -1, RIGHT = 1}

@export var POINTS = 1
@export var SPEED = 500
@export var GRAVITY = 800
@export var FALLEN_OFF_POSITION_Y = 8000
@export var FACING: FACE_DIRECTION = FACE_DIRECTION.LEFT
var playerRef: Player
var isAlive = false;


func _ready() -> void:
	playerRef = get_tree().get_nodes_in_group(GameManager.GROUP_PLAYER)[0]
	FACING = FACE_DIRECTION.LEFT if randf() > 0.5 else FACE_DIRECTION.RIGHT
	isAlive = true


func killOffScreen():
	if global_position.y > FALLEN_OFF_POSITION_Y:
		queue_free()
		print("died")

func _physics_process(_delta: float) -> void:
	killOffScreen()


func die():
	if isAlive:
		SignalManager.on_enemy_hit.emit(POINTS, global_position)
		set_physics_process(false)
		hide()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	pass # Replace with function body.

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	pass # Replace with function body.
