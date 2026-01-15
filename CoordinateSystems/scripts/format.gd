class_name Format

static func format_position(vec: Vector2) -> String:
    return "%.2f / %.2f" % [vec.x, vec.y]


static func format_size(vec: Vector2) -> String:
    return "%.1f×%.1f" % [vec.x, vec.y]
