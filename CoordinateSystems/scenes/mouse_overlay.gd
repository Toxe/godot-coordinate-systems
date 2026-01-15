class_name MouseOverlay extends Node2D

var lines: Array[String]


func _ready() -> void:
    Events.mouse_moved.connect(_on_mouse_moved)


func _draw() -> void:
    if !lines.is_empty():
        var mouse_pos := get_viewport().get_mouse_position()
        DebugDraw.draw_labeled_circle(self, mouse_pos, 10, Color.BLACK, 2, "\n".join(lines))
        lines.clear()


func _on_mouse_moved(node: Node, local_position: Vector2, g_position: Vector2) -> void:
    lines.append("%s: %s → %s" % [node.name, Format.format_position(local_position), Format.format_position(g_position)])
    queue_redraw()
