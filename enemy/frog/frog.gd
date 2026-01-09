extends EnemyBase

@onready var animatedSprite = $AnimatedSprite2D
@onready var timer = $Timer

@export var FROG_JUMP_TIME: Vector2 = Vector2(3,6)
@export var FROG_JUMP_SPEED: Vector2 = Vector2(100,-200)

var isVisibleOnScreen = false
var isJumping = false
var canJump = false


func startTimer():
	var randomTimeOut = randf_range(FROG_JUMP_TIME.x, FROG_JUMP_TIME.y)
	timer.wait_time = randomTimeOut
	timer.start()

func takeDamage():
	health -= 1
	print("take damage frog, health: ", health)


func _ready() -> void:
	super._ready()
	startTimer()

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


func applyGravity(delta: float) -> void:
	if is_on_floor():
		velocity.x = 0
		animatedSprite.play("idle")
		return
	velocity.y += GRAVITY*delta;

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	applyGravity(_delta)
	seePlayer()
	jump()
	move_and_slide()   




func jump():
	if !isVisibleOnScreen:
		return
	if canJump and is_on_floor():
		velocity = FROG_JUMP_SPEED
		velocity.x = velocity.x*FACING
		isJumping = true
		canJump = false
		startTimer()
		animatedSprite.play("jump")



func _on_timer_timeout() -> void:
	canJump = true
	isJumping = false

func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	isVisibleOnScreen = true

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	isVisibleOnScreen = false
