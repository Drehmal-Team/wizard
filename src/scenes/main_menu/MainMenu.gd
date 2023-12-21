extends Node

var tween = Tween
var tween2 = Tween
@onready var MainMenuNode = get_tree().root.get_child(2).get_children()[1]
@onready var PlayerSelectionNode = get_tree().root.get_child(2).get_children()[2]
@onready var GlowText1 = $VBoxContainer/MarginContainer/VBoxContainer/TextureRect
@onready var Glow1 = $VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1
var OgSize1 : float

func _ready():
	Engine.physics_ticks_per_second = 10
	OgSize1 = 295.674
	get_tree().get_root().size_changed.connect(repositionGlows)
	MainMenuNode.show()
	$VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1/ColorRect/Button.disabled = false
	MainMenuNode.modulate = Color(1,1,1,1)
	PlayerSelectionNode.hide()
	PlayerSelectionNode.modulate = Color(1,1,1,0)
	$VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1/ColorRect.play("default")
	$VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1/TimerGlow1.timeout.connect(repositionGlows)
	
	for child in get_all_nodes($".") :
		if child is TextureButton:
			child.mouse_entered.connect(buttonHovered)
			child.pressed.connect(buttonPressed)

	$VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1/TimerGlow1.start()
	repositionGlows()

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
	Global.play_from_path("res://assets/sounds/Buttons/Hover.ogg",-6.0)

func buttonPressed():
	Global.play_from_path("res://assets/sounds/Buttons/Click.ogg",-6.0)

func get_all_nodes(node : Node) -> Array:
	var children := []
	for N in node.get_children():
		children.append(N)
		if N.get_child_count() > 0:
			children.append_array(get_all_nodes(N))
	return children

func repositionGlows():
	var size1 = GlowText1.size
	var ratio1 : float = 0.75 * size1.x/OgSize1
	Glow1.position = Vector2(0.439673424 * size1.x, 0.647058824 * size1.y)
	Glow1.set_scale(Vector2(ratio1,ratio1))
	return

var distance := 0.0

func _process(_delta):
	if not $VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1/ColorRect/Button.disabled :
		distance = Glow1.get_global_mouse_position().distance_to(Glow1.global_position)
		if distance < 6 :
			Glow1.modulate = Color(1,1,1,1)
		elif distance > 10 :
			Glow1.modulate = Color(1,1,1,0)
		else :
			Glow1.modulate = Color(1,1,1,(distance-6)/4)
		


func _on_button_glow1_pressed():
	Global.play_from_path("res://assets/sounds/Runes/rune_5.ogg")
	$VBoxContainer/MarginContainer/VBoxContainer/TextureRect/Glow1/ColorRect/Button.disabled = true
	tween = create_tween()
	tween.tween_property(Glow1, "modulate", Color(1,1,1,0), 1)
	tween2 = create_tween()
	tween2.tween_property(Glow1, "scale", Vector2(20,20), 1)
	await tween.finished
	
	SceneTransition.dissolve("res://scenes/main_menu/secret/secretCredits.tscn")
