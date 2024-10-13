extends Node3D

var currentWeapon
var weaponsList = []
var canShoot : bool = true
@onready var ray_cast_component: RayCast3D = $"../Camera3D/RayCastComponent"


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	weaponKeybinds()

func weaponKeybinds():
	if Input.is_action_just_pressed("primary"):
		if weaponsList[0] != currentWeapon:
			swapCurrentWeapon(weaponsList[0])
	if Input.is_action_just_pressed("secondary"):
		if weaponsList[1] != currentWeapon:
			swapCurrentWeapon(weaponsList[1])
	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()

# Function to pick up a new weapon and swap it out
func swapGun(newWeapon):
	# find index of currentWeapon to swap out
	var index = weaponsList.find(currentWeapon)
	# set weaponsList[index] to newWeapon picked up
	weaponsList[index] = newWeapon
	# set current weapon to newWeapon in array
	currentWeapon = weaponsList[index]

# Function to switch between weapons the player currently has
func swapCurrentWeapon(weapon):
	currentWeapon = weapon

# Function to initialize player weapons
func initializePlayerWeapons():
	weaponsList = []

# Returns true if reserveAmmo == 0, else return false if not empty
func checkReserveAmmoEmpty():
	if currentWeapon.ammo_component.reserveAmmoCurrentSize == 0:
		return true
	return false

# Returns true if activeAmmo == 0, else return false if no empty
func checkActiveAmmoEmpty():
	if currentWeapon.ammo_component.activeAmmoCurrentSize == 0:
		return true
	return false

# Returns true if activeAmmo is less than its activeAmmoMaxSize, else false if it equals it
func canReloadWeapon():
	print("Can Reload Weapon Function")
	if currentWeapon.ammo_componenet.activeAmmoCurrentSize < currentWeapon.ammo_componenet.activeAmmoMaxSize:
		return true
	return false

# Shoot Function
func shoot():
	print("Shoot")
	# If activeAmmo is not empty and canShoot is true, SHOOT!
	if !checkActiveAmmoEmpty() and canShoot:
		# Set canShoot to false to add delay between shoots i.e. firerate
		canShoot = false
		# Check if raycast collides with an object that has take_damage function, then it is an enemy
		if ray_cast_component.is_colliding() and ray_cast_component.get_collider().health_component.has_method("take_damage"):
			ray_cast_component.get_collider().take_damage(currentWeapon.ammo_component.baseDamage)

# Reload Function
func reload():
	# If reserveAmmo is not empty and canReloadWeapon is true, then reload
	if !checkReserveAmmoEmpty() and canReloadWeapon():
		print("Reloaded Weapon")
		var ammoNeeded = currentWeapon.ammo_component.activeAmmoMaxSize - currentWeapon.ammo_component.activeAmmoCurrentSize
		if currentWeapon.ammo_component.reserveAmmoCurrentSize >= ammoNeeded:
			currentWeapon.ammo_component.activeAmmoCurrentSize = currentWeapon.ammo_component.activeAmmoMaxSize
			currentWeapon.ammo_component.reserveAmmoCurrentSize -= ammoNeeded
		else:
			currentWeapon.ammo_component.activeAmmoCurrentSize += currentWeapon.ammo_component.reserveAmmoCurrentSize
			currentWeapon.ammo_component.reserveAmmoCurrentSize = 0
	else:
		print("Out of Ammo")
