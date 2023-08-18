extends Node

var tween = Tween
@onready var MainMenuNode = get_tree().root.get_child(2).get_children()[1]
@onready var PlayerSelectionNode = get_tree().root.get_child(2).get_children()[2]

func _ready():
	MainMenuNode.show()
	MainMenuNode.modulate = Color(1,1,1,1)
	PlayerSelectionNode.hide()
	PlayerSelectionNode.modulate = Color(1,1,1,0) 

	for child in get_all_nodes($".") :
		if child is TextureButton:
			child.mouse_entered.connect(buttonHovered)
			child.pressed.connect(buttonPressed)

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

func buttonHovered():
	Global.play_from_path("res://assets/sounds/Buttons/Hover.ogg")

func buttonPressed():
	Global.play_from_path("res://assets/sounds/Buttons/Click.ogg")

func get_all_nodes(node : Node) -> Array:
	var children := []
	for N in node.get_children():
		children.append(N)
		if N.get_child_count() > 0:
			children.append_array(get_all_nodes(N))
	return children
