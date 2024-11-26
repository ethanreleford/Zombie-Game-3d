extends Node
 
@export var player_points : int = 0
@export var points_on_damage : int = 10
@export var points_on_kill : int = 70

func _ready():
	pass 

func _process(delta):
	pass

func addPointsOnDamage():
	player_points += points_on_damage

func addPointsOnKill():
	player_points += points_on_kill

func removePoints(deduction: int):
	player_points -= deduction
