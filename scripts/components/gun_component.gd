extends Node3D

var currentWeapon
@export var start1 : Node3D
@export var start2 : Node3D
var weaponsList = [null, null]
var canShoot : bool = true
@onready var ray_cast_component: RayCast3D = $"../RayCastComponent"


func _ready() -> void:
	initializePlayerWeapons()

func _process(delta: float) -> void:
	weaponKeybinds()

# Function for weapon key binds
func weaponKeybinds():
	# If player presses '1' swap to weapon 1
	if Input.is_action_just_pressed("primary"):
		if weaponsList[0] != null and weaponsList[0] != currentWeapon:
			swapCurrentWeapon(weaponsList[0])
	# If player presses '2' swap to weapon 2
	if Input.is_action_just_pressed("secondary"):
		if weaponsList[1] != null and weaponsList[1] != currentWeapon :
			swapCurrentWeapon(weaponsList[1])
	# If player presses 'mouse1' key call shoot function
	if Input.is_action_just_pressed("shoot") and currentWeapon != null:
		shoot()
	# If player presses 'r' key call reload function
	if Input.is_action_just_pressed("reload") and currentWeapon != null:
		reload()

# Shoot Function
func shoot():
	#print("Shoot function entered")
	#print(currentWeapon.ammo_component.activeAmmoMaxSize)
	#print(currentWeapon.ammo_component.activeAmmoCurrentSize)
	#print(currentWeapon.ammo_component.reserveAmmoMaxSize)
	#print(currentWeapon.ammo_component.reserveAmmoCurrentSize)
	# If checkActiveAmmoEmpty() is false and canShoot is true, SHOOT!
	if !checkActiveAmmoEmpty() and canShoot:
		print("successfully shoot")
		# Set canShoot to false to add delay between shoots i.e. firerate
		canShoot = false
		currentWeapon.ammo_component.activeAmmoCurrentSize -= 1
		# Check if raycast collides with an object that has take_damage function, then it is an enemy
		if ray_cast_component.is_colliding():
			var collider = ray_cast_component.get_collider()
			var health_component = collider.health_component
			if health_component.has_method("takeDamage"):
				health_component.takeDamage(currentWeapon.ammo_component.baseDamage)

		canShoot = true

# Reload Function
func reload():
	# If checkReserveAmmoEmpty() is false and canReloadWeapon() is true, then reload
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

# Function to handle ammunition after player shoots
func ammuntionUsed():
	currentWeapon.ammo_componenet.activeAmmoCurrentSize -= 1

# Function to pick up a new weapon and swap it out
func swapGun(newWeapon):
	print("swapgun")
	# find index of currentWeapon to swap out
	var index = weaponsList.find(currentWeapon)
	# set weaponsList[index] to newWeapon picked up
	weaponsList[index] = newWeapon
	# set current weapon to newWeapon in array
	currentWeapon = weaponsList[index]

# Function to switch between weapons the player currently has
func swapCurrentWeapon(weapon):
	print("swapcurrentweapon")
	currentWeapon = weapon

# Function to initialize player weapons
func initializePlayerWeapons():
	print("initializePlayerWeapons")
	weaponsList = [start1, null]
	currentWeapon = weaponsList[0]

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
	if currentWeapon.ammo_component.activeAmmoCurrentSize < currentWeapon.ammo_component.activeAmmoMaxSize:
		return true
	return false
