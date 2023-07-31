extends Node

var RessourcePackMode = ""
var MinecraftFolderPath = ""
var ModsFolderPath = ""
var ResFolderPath = ""
var SavesFolderPath = ""
var NecessMods = true
var PerfMods = false
var OptiMods = false
var FabricInstalled = false

var Music = AudioStreamPlayer.new()

signal BeginInstall
signal NextStep
signal PrevStep
signal SeeMods
signal OutMods

func _ready():
	add_child(Music)
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

func _on_install_begin_button_pressed():
	$VBoxContainer/MarginContainer2/MenuManagers/PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxInstall/Button.process_mode = Node.PROCESS_MODE_DISABLED
	SceneTransition.dissolve("res://InstallMain.tscn")
