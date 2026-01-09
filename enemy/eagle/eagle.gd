extends EnemyBase


@onready var animatedSprite = $AnimatedSprite2D
@onready var directionTimer = $DirectionTimer


@export var EAGLE_FLY_SPEED: Vector2 = Vector2(75, 50)


var isVisibleOnScreen = false


func takeDmage():
    print("take damage eagle")


func seePlayer():
    if !isVisibleOnScreen:
        return
    var playerPos = playerRef.global_position.x
    var selfPos = global_position.x

    if playerPos <= selfPos:
        FACING = FACE_DIRECTION.LEFT
    else:
        FACING = FACE_DIRECTION.RIGHT
    animatedSprite.flip_h = FACING == FACE_DIRECTION.RIGHT




func _ready() -> void:
    super._ready()
    seePlayer()


func flyToPlayer():
    velocity = EAGLE_FLY_SPEED
    velocity.x *= FACING



func _physics_process(_delta: float) -> void:
    super._physics_process(_delta)
    move_and_slide()




func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
    seePlayer()
    animatedSprite.play("fly")
    directionTimer.start()
    isVisibleOnScreen = true


func _on_direction_timer_timeout() -> void:
    seePlayer()
    flyToPlayer()
    directionTimer.start()