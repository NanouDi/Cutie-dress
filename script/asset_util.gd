class_name AssetUtil
extends RefCounted

# Liste les fichiers d'un dossier (marche aussi dans le jeu exporté)
static func list_files(dir: String, exts: Array, exclude: Array = []) -> Array[String]:
	var out: Array[String] = []
	var seen: Dictionary = {}
	var da: DirAccess = DirAccess.open(dir)
	if da == null:
		return out
	for f in da.get_files():
		var fname: String = f
		if fname.ends_with(".import"):
			fname = fname.trim_suffix(".import")
		elif fname.ends_with(".remap"):
			fname = fname.trim_suffix(".remap")
		var ext: String = fname.get_extension().to_lower()
		if not exts.has(ext):
			continue
		if exclude.has(fname.get_basename()):
			continue
		if seen.has(fname):
			continue
		seen[fname] = true
		out.append(dir.path_join(fname))
	out.sort_custom(func(a: String, b: String) -> bool: return a.naturalnocasecmp_to(b) < 0)
	return out

static func list_images(dir: String, exclude: Array = []) -> Array[String]:
	return list_files(dir, ["png", "jpg", "jpeg", "webp"], exclude)

# Trouve une image sans connaître son extension : find("res://art/boutons/play")
static func find(base: String) -> String:
	for ext in ["png", "PNG", "jpg", "JPG", "jpeg", "webp"]:
		var p: String = base + "." + ext
		if ResourceLoader.exists(p):
			return p
	return ""
