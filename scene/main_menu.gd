extends Control

const PLAY_PATH: String = "res://art/boutons/play.png"

func _ready() -> void:
	print("main_menu.gd lancé")
	print("play.png existe : ", ResourceLoader.exists(PLAY_PATH))
	print("enfants de la scène : ", get_children())
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var sky := ColorRect.new()
	sky.color = Color("dfeaf0")
	add_child(sky)
	sky.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg := TextureRect.new()
	bg.texture = load("res://art/farm.JPG")
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var btn: BaseButton
	var tex: Texture2D = load(PLAY_PATH) as Texture2D
	if tex != null:
		var tb := TextureButton.new()
		tb.texture_normal = tex
		tb.ignore_texture_size = true
		tb.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		tb.custom_minimum_size = Vector2(320, 140)
		tb.mouse_entered.connect(func(): tb.modulate = Color(1.1, 1.1, 1.1))
		tb.mouse_exited.connect(func(): tb.modulate = Color.WHITE)
		btn = tb
	else:
		push_warning("Image introuvable : " + PLAY_PATH)
		var b := Button.new()
		b.text = "PLAY"
		b.custom_minimum_size = Vector2(240, 80)
		UIStyle.style_button(b, 40)
		btn = b

	btn.anchor_left = 0.5
	btn.anchor_right = 0.5
	btn.anchor_top = 0.86
	btn.anchor_bottom = 0.86
	btn.grow_horizontal = Control.GROW_DIRECTION_BOTH
	btn.grow_vertical = Control.GROW_DIRECTION_BOTH
	btn.pressed.connect(_on_start_pressed)
	add_child(btn)

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/character_select.tscn")
