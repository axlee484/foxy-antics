extends CharacterBody2D

class_name Player

@onready var sprite = $Sprite2D;
@onready var animationPlayer = $AnimationPlayer
@onready var debugLabel = $DebugLabel
@onready var soundPlayer = $SoundPlayer
@onready var rayCastWallLeft = $RayCastWallLeft
@onready var rayCastWallRight = $RayCastWallRight
@onready var gun = $PlayerGun
@onready var hitbox = $HitBox
@onready var damageTimer = $DamageTimer
@onready var invinciblePlayer = $InvicibleAnimationPlayer




@export var GRAVITY = 300;
@export var LINEAR_SPEED = 100;
@export var JUMP = -120;
@export var DOUBLE_JUMP_BOOST = -30
@export var WALL_JUMP_BOOST = -10
@export var WALL_PUSH = 800
@export var MAX_FALL = 400
@export var MAX_HEALTH = 100



enum PLAYER_STATES {
	IDLE,
	INVINCIBLE,
	RUNNING,
	JUMPING,
	FALLING,
	SHOOTING,
	HURTING
}


var state = PLAYER_STATES.IDLE
var canDoubleJump = false;
var health = MAX_HEALTH
var isInvincible = false

func isTouchingWall():
	if rayCastWallLeft.is_colliding() or rayCastWallRight.is_colliding():
		return true
	return false



func playAnimation():
	match state:
		PLAYER_STATES.IDLE:
			animationPlayer.play("idle")
		PLAYER_STATES.RUNNING:
			animationPlayer.play("run")
		PLAYER_STATES.JUMPING:
			animationPlayer.play("jump")
		PLAYER_STATES.FALLING:
			animationPlayer.play("fall")
		PLAYER_STATES.HURTING:
			animationPlayer.play("hurt")
		_:
			animationPlayer.play("idle")
	if isInvincible:
		invinciblePlayer.play("invincible")



func setState():
	if state == PLAYER_STATES.HURTING:
		return
	if is_on_floor():
		if velocity.x == 0:
			state = PLAYER_STATES.IDLE
		else:
			state = PLAYER_STATES.RUNNING
	
	else:
		if velocity.y <= 0:
			state = PLAYER_STATES.JUMPING
		else:
			state = PLAYER_STATES.FALLING

func doubleJump(jumpBoost = DOUBLE_JUMP_BOOST):
	if canDoubleJump:
		SoundManager.play_sound(soundPlayer, SoundManager.SOUND_JUMP)
		velocity.y = JUMP + jumpBoost;
	

func shoot():
	var dir = Vector2.LEFT if sprite.flip_h else Vector2.RIGHT
	gun.shoot(dir)


func getInput() -> void:
	if state == PLAYER_STATES.HURTING:
		return
	velocity.x = 0;
	if Input.is_action_pressed("left"):
		if !sprite.flip_h:
			sprite.flip_h = true;
		velocity.x += -LINEAR_SPEED
	if Input.is_action_pressed("right"):
		if sprite.flip_h:
			sprite.flip_h = false;
		velocity.x += LINEAR_SPEED
	
	if Input.is_action_just_pressed("shoot"):
		shoot()


	if is_on_floor() and Input.is_action_pressed("jump") :
		SoundManager.play_sound(soundPlayer, SoundManager.SOUND_JUMP)
		velocity.y = JUMP;
		canDoubleJump = true;

	else:
		if Input.is_action_just_pressed("fall"):
			velocity.y = MAX_FALL;
			canDoubleJump = false;
				
		elif Input.is_action_just_pressed("jump"):
			if isTouchingWall():
				canDoubleJump = true;
				doubleJump(WALL_JUMP_BOOST)
				canDoubleJump = false
			else:
				doubleJump()
				canDoubleJump = false
		
		
	velocity.y = clampf(velocity.y, velocity.y, MAX_FALL);
		



func takeEnemyDamage(enemy: EnemyBase):
	health -= enemy.DAMAGE
	state = PLAYER_STATES.HURTING
	velocity.x = 0;

func takeBulletDamage(bullet: BulletBase):
	health -= bullet.damage
	state = PLAYER_STATES.HURTING
	velocity.x = 0;

func takeBossDamage(boss: Boss):
	health -= boss.DAMAGE
	state = PLAYER_STATES.HURTING
	velocity.x = 0;

func takeDamage(area: Area2D):
	var areaParent = area.get_parent()
	isInvincible = true
	SoundManager.play_sound(soundPlayer, SoundManager.SOUND_DAMAGE)
	damageTimer.start()
	if areaParent is BulletBase:
		takeBulletDamage(areaParent)
	if areaParent is EnemyBase:
		takeEnemyDamage(areaParent)
	elif areaParent.get_parent() is Boss:
		takeBossDamage(areaParent.get_parent())




func applyGravity(delta: float) -> void:
	if is_on_floor():
		return;
	velocity.y += GRAVITY*delta;


func _physics_process(delta: float) -> void:
	applyGravity(delta);
	getInput();
	move_and_slide();
	
	var prevState = state;
	setState()
	if prevState == PLAYER_STATES.FALLING and state == PLAYER_STATES.IDLE:
		SoundManager.play_sound(soundPlayer, SoundManager.SOUND_LAND)
	playAnimation()
	updateDebugLabel()
	




func takeHealth(healthBoost: float):
	health += healthBoost


func _ready() -> void:
	SignalManager.on_fruit_collected.connect(takeHealth)

func updateDebugLabel():
	var debugStr =  "velocity %s %s \nfloor %s \n%s\nhealth %s" % [
						velocity.x , velocity.y,
						is_on_floor(),
						PLAYER_STATES.keys()[state],
						health
					]
	debugLabel.text = debugStr;
	


func _on_hit_box_area_entered(area: Area2D) -> void:
	if state == PLAYER_STATES.HURTING or isInvincible:
		return
	takeDamage(area)


func _on_damage_timer_timeout() -> void:
	state = PLAYER_STATES.IDLE
	invinciblePlayer.stop()
	isInvincible = false
