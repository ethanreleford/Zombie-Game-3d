extends Node3D

@export var reserveAmmoMaxSize = 300
var reserveAmmoCurrentSize
@export var activeAmmoMaxSize = 30
var activeAmmoCurrentSize
@export var baseDamage = 10

func initializeAmmo():
	print("initialize weapon compoenent")
	reserveAmmoCurrentSize = reserveAmmoMaxSize
	activeAmmoCurrentSize = activeAmmoMaxSize

func _ready() -> void:
	initializeAmmo()

func _process(delta: float) -> void:
	pass
