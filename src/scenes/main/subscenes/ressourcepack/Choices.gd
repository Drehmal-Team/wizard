extends Control

@onready var ButtonLocal = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxContainer/HBoxContainer_LOCAL/TextureButton
@onready var ButtonGlobal = $VBoxContainer/MarginContMinecraftFolder/VBoxContainer/VBoxContainer/HBoxContainer_GLOBAL/TextureButton


func _ready():
	if Global.InstallType == "SINGLE" :
		ButtonLocal.set_pressed_no_signal(true)
		ButtonGlobal.set_pressed_no_signal(false)
	elif  Global.InstallType == "CLIENT" :
		ButtonLocal.set_pressed_no_signal(false)
		ButtonGlobal.set_pressed_no_signal(true)
		Global.RessourcePackMode = "GLOBAL"
	else : # FOR TESTING
		ButtonLocal.set_pressed_no_signal(true)
		ButtonGlobal.set_pressed_no_signal(false)

func _on_texture_button_LOCAL_toggled(state):
	if not ButtonGlobal.button_pressed and not state :
		ButtonLocal.button_pressed = true
	_button_state_changed()
	if state == true and Global.InstallType == "CLIENT" :
		$ConfirmationDialog.show()
	

func _on_texture_button_GLOBAL_toggled(state):
	if not ButtonLocal.button_pressed and not state :
		ButtonGlobal.button_pressed = true
	_button_state_changed()

func _button_state_changed():
	if ButtonGlobal.button_pressed and ButtonLocal.button_pressed :
		Global.RessourcePackMode = "BOTH"
	elif ButtonGlobal.button_pressed :
		Global.RessourcePackMode = "GLOBAL"
	elif ButtonLocal.button_pressed :
		Global.RessourcePackMode = "LOCAL"
	elif not ButtonGlobal.button_pressed and not ButtonLocal.button_pressed :
		if Global.InstallType == "SINGLE": 
			ButtonLocal.set_pressed_no_signal(true)
		elif Global.InstallType == "CLIENT": 
			ButtonGlobal.set_pressed_no_signal(true)
		else:
			ButtonLocal.set_pressed_no_signal(true)
