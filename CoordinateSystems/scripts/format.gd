class_name Format


static func format_position(vec: Vector2) -> String:
    return "%.2f / %.2f" % [vec.x, vec.y]


static func format_size(vec: Vector2) -> String:
    return "%s×%s" % [without_trailing_zeros(vec.x), without_trailing_zeros(vec.y)]


static func without_trailing_zeros(n: float) -> String:
    return String.num(n, 0 if step_decimals(n) == 0 else -1)
