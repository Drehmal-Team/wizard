extends HBoxContainer

@onready var Socials = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxSocials
@onready var Info = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/LabelMenuInfo
@onready var Install = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxInstall

# Called when the node enters the scene tree for the first time.
func _ready():
	Socials.hide()
	Install.hide()
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "What is Drehmal 2.2 ?"
	Info.show()
	$MarginContainer/VBoxContainer/Button_Install.set_pressed_no_signal(false)
	$MarginContainer/VBoxContainer/Button_Social.set_pressed_no_signal(false)
	$MarginContainer/VBoxContainer/Button_Info.set_pressed_no_signal(true)

func _on_button_install_pressed():
	$MarginContainer/VBoxContainer/Button_Info.set_pressed_no_signal(false)
	$MarginContainer/VBoxContainer/Button_Social.set_pressed_no_signal(false)
	if Socials.visible == true :
		Socials.hide()
	if Info.visible == true :
		Info.hide()
	
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "Let's install Drehmal !"
	Install.show()


func _on_button_info_pressed():
	$MarginContainer/VBoxContainer/Button_Install.set_pressed_no_signal(false)
	$MarginContainer/VBoxContainer/Button_Social.set_pressed_no_signal(false)
	if Install.visible == true :
		Install.hide()
	if Socials.visible == true :
		Socials.hide()
	
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "What is Drehmal 2.2 ?"
	Info.show()


func _on_button_social_pressed():
	$MarginContainer/VBoxContainer/Button_Install.set_pressed_no_signal(false)
	$MarginContainer/VBoxContainer/Button_Info.set_pressed_no_signal(false)
	if Install.visible == true :
		Install.hide()
	if Info.visible == true :
		Info.hide()
	
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "Where to find us :"
	Socials.show()
