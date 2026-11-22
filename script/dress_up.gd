extends Node2D

var doll: AnimalDoll

func _ready() -> void:
	var screen: Vector2 = get_viewport_rect().size

	var bg: ColorRect = ColorRect.new()
	bg.color = UIStyle.PINK_BG
	bg.size = screen
	bg.z_index = -10
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	doll = AnimalDoll.new()
	doll.editable = true
	doll.position = Vector2(screen.x * 0.27, screen.y * 0.56)
	add_child(doll)
	doll.setup(Global.chosen_animal, 440.0)

	# Panneau à onglets
	var panel: OptionPanel = OptionPanel.new()
	panel.position = Vector2(screen.x * 0.50, 80)
	add_child(panel)
	panel.add_section("Hauts", "res://art/top", _on_top, Vector2(90, 90), 4)
	panel.add_section("Bas", "res://art/pants", _on_bottom, Vector2(90, 90), 4)
	# Plus tard : panel.add_section("Accessoires", "res://art/accessories", _on_acc, Vector2(90, 90), 4)

	# Boutons de réglage, sur le côté gauche
	var tools: VBoxContainer = UIStyle.make_tools(
		func(): doll.scale_selected(1.1),
		func(): doll.scale_selected(1.0 / 1.1),
		func(): doll.rotate_selected(10.0),
		func(): doll.reset_selected())
	tools.position = Vector2(20, screen.y * 0.40)
	add_child(tools)

	var hint: Label = Label.new()
	hint.text = "Clique un vêtement sur le personnage et glisse-le. Molette = taille, Maj + molette = rotation."
	hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	hint.custom_minimum_size = Vector2(500, 0)
	hint.position = Vector2(screen.x * 0.50, 495)
	UIStyle.style_label(hint, 18)
	add_child(hint)

	var back: Button = Button.new()
	back.text = "Retour"
	UIStyle.style_button(back, 26)
	back.position = Vector2(20, screen.y - 70)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scene/character_select.tscn"))
	add_child(back)

	var nxt: Button = Button.new()
	nxt.text = "Suivant"
	UIStyle.style_button(nxt, 26)
	nxt.position = Vector2(screen.x - 220, screen.y - 70)
	nxt.pressed.connect(func(): get_tree().change_scene_to_file("res://scene/photo.tscn"))
	add_child(nxt)

func _on_top(path: String) -> void:
	Global.top_path = path
	doll.set_top(path)

func _on_bottom(path: String) -> void:
	Global.bottom_path = path
	doll.set_bottom(path)
