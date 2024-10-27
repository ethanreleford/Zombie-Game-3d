extends Control

@export var player : Node3D = null
@onready var weapon_name: Label = $WeaponInfo/WeaponName
@onready var player_reserve_ammo: Label = $WeaponInfo/PlayerReserveAmmo
@onready var player_active_ammo: Label = $WeaponInfo/PlayerActiveAmmo

var weaponInfo : Dictionary

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	weaponInformation()

func weaponInformation():
	weaponInfo = player.getCurrentWeaponStats()
	weapon_name.text = str(weaponInfo["Weapon Name"])
	player_reserve_ammo.text = str(weaponInfo["Reserve Ammo"])
	player_active_ammo.text = str(weaponInfo["Active Ammo"])
