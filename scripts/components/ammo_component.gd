extends Node3D

@export var weaponObject : Node3D
@export var reserveAmmoMaxSize = 300
var reserveAmmoCurrentSize
@export var activeAmmoMaxSize = 30
var activeAmmoCurrentSize
var weaponName: String
@export var baseDamage = 10

func initializeAmmo():
	print("initialize weapon compoenent")
	reserveAmmoCurrentSize = reserveAmmoMaxSize
	activeAmmoCurrentSize = activeAmmoMaxSize
	weaponName = weaponObject.weaponName

func _ready() -> void:
	initializeAmmo()

func _process(delta: float) -> void:
	pass
