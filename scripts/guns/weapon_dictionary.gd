extends Node

# Basic dictionary of all the weapons in the game
# ID : Reference to scene to add to the player when picking up a weapon
var weapon_data = {
	"AK-47": preload("res://scenes/guns/ak47_obj.tscn"),
	"M4A4": preload("res://scenes/guns/m4a4_obj.tscn"),
}

# Function to get the weapon scene by ID
func getWeaponScene(ID: String):
	return weapon_data.get(ID, null)  # Returns null if ID is not found
