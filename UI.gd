extends Control

@export var player_weapon_component : Node3D = null
@onready var weapon_name: Label = $WeaponInfo/WeaponName
@onready var player_reserve_ammo: Label = $WeaponInfo/PlayerReserveAmmo
@onready var player_active_ammo: Label = $WeaponInfo/PlayerActiveAmmo
@onready var player_point_count = $PlayerPointsInfo/PlayerPointCount
@export var player_point_component: Node
@export var spawn_system: Node3D
@onready var zombies_left_count = $ZombieCountInfo/ZombiesLeftCount




var weaponInfo : Dictionary

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	weaponInformation()
	pointInformation()
	zombieLeftInformation()

func weaponInformation():
	weaponInfo = player_weapon_component.getCurrentWeaponStats()
	weapon_name.text = str(weaponInfo["Weapon Name"])
	player_reserve_ammo.text = str(weaponInfo["Reserve Ammo"])
	player_active_ammo.text = str(weaponInfo["Active Ammo"])

func pointInformation():
	player_point_count.text = str(player_point_component.player_points)

func roundInformation():
	pass

func zombieLeftInformation():
	zombies_left_count.text = str(spawn_system.zombies_left_count)
