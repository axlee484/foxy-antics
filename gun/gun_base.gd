extends Node2D


class_name  GunBase

@export var FIRE_RATE = 0.5
@export var SPEED = 250
@export var BULLET_TYPE: ObjectMaker.BULLET_TYPE


@onready var timer: Timer = $Timer
var canShoot = true

func _ready() -> void:
    timer.wait_time = FIRE_RATE
    timer.start()



func shoot(direction: Vector2):
    if canShoot:
        ObjectMaker.createBullet(BULLET_TYPE,global_position, SPEED, direction)
        canShoot = false
        timer.start()
    


func _on_timer_timeout() -> void:
    canShoot = true
	
