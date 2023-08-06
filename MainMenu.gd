extends Node

var tween = Tween
@onready var MainMenuNode = get_tree().root.get_child(2).get_children()[1]
@onready var PlayerSelectionNode = get_tree().root.get_child(2).get_children()[2]

func _ready():
	MainMenuNode.show()
	MainMenuNode.modulate = Color(1,1,1,1)
	PlayerSelectionNode.hide()
	PlayerSelectionNode.modulate = Color(1,1,1,0) 


func _on_install_begin_button_pressed():
	$VBoxContainer/MarginContainer2/MenuManagers/PanelContainer/MarginContainer/VBoxContainer_Info/ScrollContainer/VBoxInstall/Button.disabled = true
	
	tween = create_tween()
	tween.tween_property(MainMenuNode, "modulate", Color(1,1,1,0),0.5)
	await tween.finished
	
	MainMenuNode.hide()
	PlayerSelectionNode.show()
	tween.stop()
	
	tween = create_tween()
	tween.tween_property(PlayerSelectionNode, "modulate", Color(1,1,1,1),0.5)
	await tween.finished
