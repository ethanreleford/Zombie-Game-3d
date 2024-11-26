extends Node3D

var currentWeapon
var weaponsList = [null, null]
var canShoot : bool = true
@onready var ray_cast_component: RayCast3D = $"../RayCastComponent"
var weapon_dictionary_script = preload("res://scripts/guns/weapon_dictionary.gd").new()
@onready var pistol_animations: Node3D = $"../PistolAnimations"
@export var point_component: Node
@export var enemy_spawn_system: Node3D

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
	print("Shoot function entered")
	print(currentWeapon.ammo_component.activeAmmoMaxSize)
	print(currentWeapon.ammo_component.activeAmmoCurrentSize)
	print(currentWeapon.ammo_component.reserveAmmoMaxSize)
	print(currentWeapon.ammo_component.reserveAmmoCurrentSize)
	# If checkActiveAmmoEmpty() is false and canShoot is true, SHOOT!
	if !checkActiveAmmoEmpty() and canShoot:
		pistol_animations.play_animations("Scene")
		#print("successfully shoot")
		# Set canShoot to false to add delay between shoots i.e. firerate
		canShoot = false
		currentWeapon.ammo_component.activeAmmoCurrentSize -= 1
		# Check if raycast collides with an object that has take_damage function, then it is an enemy
		if ray_cast_component.is_colliding():
			var collider = ray_cast_component.get_collider()
			var health_component = collider.health_component
			if health_component.has_method("takeDamage"):
				if(health_component.takeDamage(currentWeapon.ammo_component.baseDamage)):
					enemy_spawn_system.decrementZombieLeftCount()
					point_component.addPointsOnKill()
				else:
					point_component.addPointsOnDamage()
		canShoot = true

# Reload Function
func reload():
	# If checkReserveAmmoEmpty() is false and canReloadWeapon() is true, then reload
	if !checkReserveAmmoEmpty() and canReloadWeapon():
		#print("Reloaded Weapon")
		var ammoNeeded = currentWeapon.ammo_component.activeAmmoMaxSize - currentWeapon.ammo_component.activeAmmoCurrentSize
		if currentWeapon.ammo_component.reserveAmmoCurrentSize >= ammoNeeded:
			currentWeapon.ammo_component.activeAmmoCurrentSize = currentWeapon.ammo_component.activeAmmoMaxSize
			currentWeapon.ammo_component.reserveAmmoCurrentSize -= ammoNeeded
		else:
			currentWeapon.ammo_component.activeAmmoCurrentSize += currentWeapon.ammo_component.reserveAmmoCurrentSize
			currentWeapon.ammo_component.reserveAmmoCurrentSize = 0
	else:
		pass
		#print("Out of Ammo")

# Function to handle ammunition after player shoots
func ammuntionUsed():
	currentWeapon.ammo_componenet.activeAmmoCurrentSize -= 1

# Function to pick up a new weapon and swap it out 
# Effectively deleting currently held weapon to pick up new one
func swapWeapon(newWeaponScene):
	#print("swapWeapon")
	
	# Find index of currentWeapon to swap out
	var index = weaponsList.find(currentWeapon)
	
	# Instantiate the new weapon scene
	var newWeaponInstance = newWeaponScene.instantiate()  # Create an instance of the new weapon
	
	for i in range(weaponsList.size()):
		if weaponsList[i] == null:
			# Set the current weapon to the new instance
			swapCurrentWeapon(newWeaponInstance)
			# Add the new weapon instance to the player node
			add_child(currentWeapon)
			weaponsList[i] = currentWeapon
			weaponsList[i].visible = true
			#print(weaponsList)
			return
		else:
			weaponsList[i].visible = false

	# If there's a current weapon, free it
	if currentWeapon:
		currentWeapon.queue_free()  # Optionally remove the current weapon from the scene
	# Set the current weapon to the new instance
	swapCurrentWeapon(newWeaponInstance)
	# Add the new weapon instance to the player node
	add_child(currentWeapon)
	# Update the weaponsList with the new weapon instance
	weaponsList[index] = currentWeapon
	#print(weaponsList)

# Function to handle the physical mesh showing hiding of weapons
func swapCurrentWeaponAnimation(oldWeapon, newWeapon):
	if oldWeapon == null:
		newWeapon.visible = true
	else:
		oldWeapon.visible = false
		newWeapon.visible = true

# Function to switch between weapons the player currently has
func swapCurrentWeapon(newWeapon):
	swapCurrentWeaponAnimation(currentWeapon, newWeapon)
	#print("swapcurrentweapon")
	currentWeapon = newWeapon

# Function to initialize player weapons
func initializePlayerWeapons():
	#print("initializePlayerWeapons")
	weaponsList = [null, null]
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
	#print("Can Reload Weapon Function")
	if currentWeapon.ammo_component.activeAmmoCurrentSize < currentWeapon.ammo_component.activeAmmoMaxSize:
		return true
	return false


# Function to handle which weapon to add
func findWeaponID(ID: String):
	var newWeaponScene = weapon_dictionary_script.getWeaponScene(ID)  # Use the function to get the weapon scene
	if newWeaponScene:
		swapWeapon(newWeaponScene)  # Swap to the new weapon scene if it exists
	else:
		pass
		#print("Weapon ID not found: " + ID)
		
func getCurrentWeaponStats() -> Dictionary:
	if currentWeapon != null:
		return {"Active Ammo": currentWeapon.ammo_component.activeAmmoCurrentSize, "Reserve Ammo": currentWeapon.ammo_component.reserveAmmoCurrentSize, "Weapon Name": currentWeapon.ammo_component.weaponName}
	else:
		return {"Active Ammo": "0", "Reserve Ammo": "0", "Weapon Name": "Base Gun"}
