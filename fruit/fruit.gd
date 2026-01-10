extends Area2D

class_name Fruit

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var groundRayCast = $GroundRayCast
@onready var timer = $Timer
var fruit: Dictionary
var healthBoost: float
var timeout: float
var jump_y = 20
var speed = 100
var died = false


const fruits = [
	{
		animation = "cherry",
		healthBoost = 10,
		timeout = 4
	},
	{
		animation = "banana",
		healthBoost = 30,
		timeout = 3.5
	},
	{
		animation = "melon",
		healthBoost = 50,
		timeout = 1.5
	},
	{
		animation = "kiwi",
		healthBoost = 5,
		timeout = 4
	}
]

func setup():
	fruit = fruits[randi_range(0, fruits.size()-1)]
	animatedSprite.animation = fruit["animation"]
	timeout = fruit["timeout"]
	healthBoost = fruit["healthBoost"]

func _ready():
	setup()
	timer.wait_time = timeout
	timer.start()
	animatedSprite.play(fruit["animation"])
	var tween = create_tween()
	tween.tween_property(self, "position", global_position-Vector2(0,jump_y), 0.3)
	tween.tween_property(self, "position", global_position, 0.3)


func _process(delta):
	if !groundRayCast.is_colliding():
		global_position.y += speed*delta
	
	

	

func die():
	died = true
	animatedSprite.stop()
	hide()
	queue_free()

func _on_timer_timeout() -> void:
	if !died:
		die()


func _on_area_entered(_area: Area2D) -> void:
	if !died:
		SignalManager.on_fruit_collected.emit(fruit["healthBoost"])
		die()
