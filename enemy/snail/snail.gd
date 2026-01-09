extends EnemyBase


@onready var animatedSprite = $AnimatedSprite2D
@onready var floorRayCast = $FloorRayCast

var floorRayCastDistance = 20



func takeDmage():
	print("take damage snail")


func _ready():
	super._ready()
	animatedSprite.flip_h = FACING == 1
	floorRayCast.position.x = floorRayCastDistance * FACING


func walk(delta):
	velocity.x = SPEED*delta*FACING

func flipDirection():
	FACING = (FACING * -1) as FACE_DIRECTION
	floorRayCast.position.x = floorRayCastDistance * FACING
	animatedSprite.flip_h = FACING == 1


func applyGravity(delta: float) -> void:
	if is_on_floor():
		return;
	velocity.y += GRAVITY*delta;


func _physics_process(delta):
	super._physics_process(delta)
	applyGravity(delta)
	walk(delta)
	move_and_slide()
	if !floorRayCast.is_colliding() or is_on_wall():
		flipDirection()
