extends Node

var RessourcePackMode := ""
var MinecraftFolderPath := ""
var ModsFolderPath := ""
var ResFolderPath := ""
var SavesFolderPath := ""
var NecessMods := true
var PerfMods := false
var OptiMods := false
var RamValue := 0
var FabricInstalled := false
var FabricVersion := ""
var InstallType : String
var TimeSpent := 0.0

var Music = AudioStreamPlayer.new()

signal BeginInstall
signal NextStep
signal PrevStep
signal SeeMods
signal OutMods



func _ready():
	add_child(Music)
	Music.set_volume_db(5.0)
	Music.finished.connect(_finished)
	Music.stream = load("res://assets/sounds/MainMenu.ogg")
	_finished()
	Input.set_custom_mouse_cursor(load("res://textures/Cursor/Cursor.png"))
	
func _finished():
	Music.play()

func play_sound(type):
	if type in ["FRWD","BACK"]:
		var path : String
		if type == "FRWD":
			var files = ["res://assets/sounds/Frwd/frwd_01.ogg", "res://assets/sounds/Frwd/frwd_02.ogg", "res://assets/sounds/Frwd/frwd_03.ogg", "res://assets/sounds/Frwd/frwd_04.ogg", "res://assets/sounds/Frwd/frwd_05.ogg", "res://assets/sounds/Frwd/frwd_06.ogg", "res://assets/sounds/Frwd/frwd_07.ogg"]
			path = files[randi() % files.size()]
		var SFX = AudioStreamPlayer.new()
		add_child(SFX)
		SFX.stream = load(path)
		SFX.play()
		await SFX.finished
		SFX.queue_free()
	else :
		print("Argument not valid !")

func play_from_path(path, vol = 0.0):
	var SFX = AudioStreamPlayer.new()
	add_child(SFX)
	SFX.set_volume_db(vol)
	SFX.stream = load(path)
	SFX.play()
	await SFX.finished
	SFX.queue_free()
