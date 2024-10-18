extends Node

@export var health : int = 100
@export var maxHealth : int = 100

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func healHealth(heal : int):
	if (heal + health) > maxHealth:
		health = maxHealth
	else:
		health += heal

func takeDamage(damage : int):
	print("entered take damage of:")
	print(self)
	if damage >= health:
		get_parent().queue_free()
		print(health)
	else:
		health -= damage
	print(health)
