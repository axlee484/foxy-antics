extends CharacterBody2D


@onready var sprite = $Sprite2D;
@onready var animationPlayer = $AnimationPlayer
@onready var debugLabel = $DebugLabel
@onready var soundPlayer = $SoundPlayer




@export var GRAVITY = 300;
@export var LINEAR_SPEED = 100;
@export var JUMP = -120;
@export var DOUBLE_JUMP_BOOST = -30
@export var MAX_FALL = 400;



enum PLAYER_STATES {
    IDLE,
    RUNNING,
    JUMPING,
    FALLING,
    SHOOTING,
    HURTING
}


var state = PLAYER_STATES.IDLE
var jumpCount = 0;




func setAnimation():
    match state:
        PLAYER_STATES.IDLE:
            animationPlayer.play("idle")
        PLAYER_STATES.RUNNING:
            animationPlayer.play("run")
        PLAYER_STATES.JUMPING:
            animationPlayer.play("jump")
        PLAYER_STATES.FALLING:
            animationPlayer.play("fall")
        _:
            animationPlayer.play("idle")


func setState():
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



func getInput() -> void:
    velocity.x = 0;
    if Input.is_action_pressed("left"):
        if !sprite.flip_h:
            sprite.flip_h = true;
        velocity.x = -LINEAR_SPEED
    if Input.is_action_pressed("right"):
        if sprite.flip_h:
            sprite.flip_h = false;
        velocity.x = LINEAR_SPEED
    if !is_on_floor():
        if Input.is_action_just_pressed("fall"):
            velocity.y = MAX_FALL;
    if Input.is_action_just_pressed("jump") and jumpCount < 2:
        SoundManager.play_sound(soundPlayer, SoundManager.SOUND_JUMP)
        if jumpCount == 1:
            velocity.y = JUMP+DOUBLE_JUMP_BOOST
        else :
            velocity.y = JUMP;
        jumpCount +=1
    velocity.y = clampf(velocity.y, velocity.y, MAX_FALL);
        




func applyGravity(delta: float) -> void:
    if is_on_floor():
        return;
    velocity.y += GRAVITY*delta;


func _physics_process(delta: float) -> void:
    applyGravity(delta);
    getInput();
    move_and_slide();
    if is_on_floor():
        jumpCount = 0;
    
    var prevState = state;
    setState()
    if prevState == PLAYER_STATES.FALLING and state == PLAYER_STATES.IDLE:
        SoundManager.play_sound(soundPlayer, SoundManager.SOUND_LAND)
    setAnimation()
    updateDebugLabel()
    



func updateDebugLabel():
    var debugStr =  "velocity %s %s \nfloor %s \n%s" % [
                        velocity.x , velocity.y,
                        is_on_floor(),
                        PLAYER_STATES.keys()[state]
                    ]
    debugLabel.text = debugStr;
    