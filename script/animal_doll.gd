class_name AnimalDoll
extends Node2D

# Placement de départ (avant tes réglages à la main)
const SETTINGS: Dictionary = {
	"cow":    {"top_y": 0.58, "top_w": 0.36, "bot_y": 0.76, "bot_w": 0.30},
	"cat":    {"top_y": 0.50, "top_w": 0.34, "bot_y": 0.73, "bot_w": 0.28},
	"monkey": {"top_y": 0.47, "top_w": 0.36, "bot_y": 0.72, "bot_w": 0.30},
	"rabbit": {"top_y": 0.50, "top_w": 0.34, "bot_y": 0.72, "bot_w": 0.28},
}

var animal_name: String = "cow"
var height: float = 420.0
var editable: bool = false   # true seulement dans la scène d'habillage
var top_sprite: Sprite2D
var bottom_sprite: Sprite2D
var outline: Line2D
var selected: String = ""    # "top", "bottom" ou ""
var dragging: bool = false
var drag_offset: Vector2 = Vector2.ZERO

func setup(animal: String, h: float) -> void:
	animal_name = animal
	height = h
	set_process_unhandled_input(editable)

	var tex: Texture2D = load("res://art/%s.png" % animal)
	var body := Sprite2D.new()
	body.texture = tex
	var s: float = height / float(tex.get_height())
	body.scale = Vector2(s, s)
	add_child(body)

	outline = Line2D.new()
	outline.closed = true
	outline.width = 4.0
	outline.default_color = UIStyle.PINK
	outline.z_index = 50
	outline.visible = false
	add_child(outline)

	set_bottom(Global.bottom_path, true)
	set_top(Global.top_path, true)
	_select("")

func set_top(path: String, use_saved: bool = false) -> void:
	_set_cloth("top", path, use_saved)

func set_bottom(path: String, use_saved: bool = false) -> void:
	_set_cloth("bottom", path, use_saved)

# ---------- vêtements ----------

func _sprite(slot: String) -> Sprite2D:
	if slot == "top":
		return top_sprite
	if slot == "bottom":
		return bottom_sprite
	return null

func _get_xf(slot: String) -> Dictionary:
	return Global.top_xf if slot == "top" else Global.bottom_xf

func _set_xf(slot: String, xf: Dictionary) -> void:
	if slot == "top":
		Global.top_xf = xf
	else:
		Global.bottom_xf = xf

func _set_cloth(slot: String, path: String, use_saved: bool) -> void:
	var old: Sprite2D = _sprite(slot)
	if old != null:
		old.queue_free()
	var sp: Sprite2D = null
	if path != "":
		sp = _make_cloth(slot, path, use_saved)
	if slot == "top":
		top_sprite = sp
	else:
		bottom_sprite = sp
	if sp == null:
		_set_xf(slot, {})
		if selected == slot:
			_select("")
	else:
		if not use_saved:
			_save(slot)
		if editable and not use_saved:
			_select(slot)

func _make_cloth(slot: String, path: String, use_saved: bool) -> Sprite2D:
	var tex: Texture2D = load(path) as Texture2D
	if tex == null:
		return null
	var st: Dictionary = SETTINGS[animal_name]
	var is_top: bool = slot == "top"
	var y_key: String = "top_y" if is_top else "bot_y"
	var w_key: String = "top_w" if is_top else "bot_w"
	var max_frac: float = 0.30 if is_top else 1.0 - float(st["bot_y"]) + 0.02

	var sc: float = height * float(st[w_key]) / float(tex.get_width())
	sc = minf(sc, height * max_frac / float(tex.get_height()))
	var y_edge: float = (float(st[y_key]) - 0.5) * height
	var pos: Vector2 = Vector2(0.0, y_edge + float(tex.get_height()) * sc / 2.0)
	var rot: float = 0.0

	if use_saved:
		var xf: Dictionary = _get_xf(slot)
		if not xf.is_empty() and xf.get("animal", "") == animal_name:
			var pn: Vector2 = xf["pos"]
			pos = pn * height
			sc = float(xf["scale"]) * height
			rot = float(xf["rot"])

	var sp := Sprite2D.new()
	sp.texture = tex
	sp.scale = Vector2(sc, sc)
	sp.position = pos
	sp.rotation = rot
	sp.z_index = 2 if is_top else 1
	add_child(sp)
	return sp

func _save(slot: String) -> void:
	var sp: Sprite2D = _sprite(slot)
	if sp == null:
		return
	_set_xf(slot, {
		"animal": animal_name,
		"pos": sp.position / height,
		"scale": sp.scale.x / height,
		"rot": sp.rotation,
	})

# ---------- sélection et réglages ----------

func _select(slot: String) -> void:
	selected = slot
	_update_outline()

func _update_outline() -> void:
	var sp: Sprite2D = _sprite(selected)
	if sp == null or not editable or outline == null:
		if outline != null:
			outline.visible = false
		return
	var r: Rect2 = sp.get_rect()
	var pts: PackedVector2Array = PackedVector2Array([
		r.position,
		Vector2(r.end.x, r.position.y),
		r.end,
		Vector2(r.position.x, r.end.y),
	])
	for i in pts.size():
		pts[i] = sp.transform * pts[i]
	outline.points = pts
	outline.visible = true

func scale_selected(factor: float) -> void:
	var sp: Sprite2D = _sprite(selected)
	if sp == null:
		return
	var v: float = clampf(sp.scale.x * factor, 0.02, 3.0)
	sp.scale = Vector2(v, v)
	_save(selected)
	_update_outline()

func rotate_selected(deg: float) -> void:
	var sp: Sprite2D = _sprite(selected)
	if sp == null:
		return
	sp.rotation += deg_to_rad(deg)
	_save(selected)
	_update_outline()

func reset_selected() -> void:
	if selected == "top":
		_set_cloth("top", Global.top_path, false)
	elif selected == "bottom":
		_set_cloth("bottom", Global.bottom_path, false)

func _hit(sp: Sprite2D) -> bool:
	if sp == null:
		return false
	return sp.get_rect().has_point(sp.to_local(get_global_mouse_position()))

func _unhandled_input(event: InputEvent) -> void:
	if not editable:
		return
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == MOUSE_BUTTON_LEFT:
			if mb.pressed:
				var hit: String = ""
				if _hit(top_sprite):
					hit = "top"
				elif _hit(bottom_sprite):
					hit = "bottom"
				_select(hit)
				if hit != "":
					dragging = true
					var sp: Sprite2D = _sprite(hit)
					drag_offset = sp.position - to_local(get_global_mouse_position())
			else:
				dragging = false
		elif mb.pressed and (mb.button_index == MOUSE_BUTTON_WHEEL_UP or mb.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			var up: bool = mb.button_index == MOUSE_BUTTON_WHEEL_UP
			if Input.is_key_pressed(KEY_SHIFT):
				rotate_selected(5.0 if up else -5.0)
			else:
				scale_selected(1.05 if up else 1.0 / 1.05)
	elif event is InputEventMouseMotion and dragging and selected != "":
		var sp2: Sprite2D = _sprite(selected)
		sp2.position = to_local(get_global_mouse_position()) + drag_offset
		_save(selected)
		_update_outline()
