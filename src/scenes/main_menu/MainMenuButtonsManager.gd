extends HBoxContainer

@onready var Socials = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxSocials
@onready var Info = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/LabelMenuInfo
@onready var Install = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxInstall
@onready var Credits = $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/RichLabelCredits

# Called when the node enters the scene tree for the first time.
func _ready():
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "What is Drehmal 2.2 ?"
	
	turn_off_buttons()
	turn_off_shit()
	$MarginContainer/VBoxContainer/Button_Info.set_pressed_no_signal(true)
	Info.show()
	
	
	
	
func _on_button_install_pressed():
	turn_off_buttons()
	turn_off_shit()
	$MarginContainer/VBoxContainer/Button_Install.set_pressed_no_signal(true)
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "Let's install Drehmal !"
	Install.show()


func _on_button_info_pressed():
	turn_off_buttons()
	turn_off_shit()
	$MarginContainer/VBoxContainer/Button_Info.set_pressed_no_signal(true)
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "What is Drehmal 2.2 ?"
	Info.show()


func _on_button_social_pressed():
	turn_off_buttons()
	turn_off_shit()
	$MarginContainer/VBoxContainer/Button_Social.set_pressed_no_signal(true)
	Socials.show()
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "Where to find us :"
	


func _on_button_credits_pressed():
	turn_off_shit()
	turn_off_buttons()
	$MarginContainer/VBoxContainer/Button_Credits.set_pressed_no_signal(true)
	$PanelContainer/MarginContainer/VBoxContainer_Info/Label.text = "Credits :"
	Credits.show()

func turn_off_buttons():
	for child in $MarginContainer/VBoxContainer.get_children():
		child.set_pressed_no_signal(false)

func turn_off_shit():
	for child in $PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer.get_children():
		child.hide()
