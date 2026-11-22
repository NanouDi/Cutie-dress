extends Control

const ANIMALS: Array[String] = ["cow", "cat", "monkey", "rabbit"]

func _ready() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var bg := ColorRect.new()
	bg.color = UIStyle.PINK_BG
	add_child(bg)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	var vbox := VBoxContainer.new()
	vbox.add_theme_constant_override("separation", 40)
	center.add_child(vbox)

	var title := Label.new()
	title.text = "Choisis ton animal"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	UIStyle.style_label(title, 56)
	vbox.add_child(title)

	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 30)
	vbox.add_child(row)

	for animal in ANIMALS:
		var btn := TextureButton.new()
		btn.texture_normal = load("res://art/%s.png" % animal)
		btn.ignore_texture_size = true
		btn.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		btn.custom_minimum_size = Vector2(220, 300)
		btn.pressed.connect(_on_animal_chosen.bind(animal))
		btn.mouse_entered.connect(func(): btn.modulate = Color(1.15, 1.15, 1.15))
		btn.mouse_exited.connect(func(): btn.modulate = Color.WHITE)
		row.add_child(btn)

	var back := Button.new()
	back.text = "Retour"
	UIStyle.style_button(back, 28)
	back.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scene/main_menu.tscn"))
	vbox.add_child(back)

func _on_animal_chosen(animal: String) -> void:
	Global.chosen_animal = animal
	get_tree().change_scene_to_file("res://scene/dress_up.tscn")
