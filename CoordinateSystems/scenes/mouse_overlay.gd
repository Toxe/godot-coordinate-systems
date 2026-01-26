class_name MouseOverlay extends Node2D

var lines: Array[String]


func _ready() -> void:
    Events.mouse_moved.connect(_on_mouse_moved)


func _draw() -> void:
    if !lines.is_empty():
        var mouse_pos := get_viewport().get_mouse_position()
        DebugDraw.draw_labeled_circle(self, mouse_pos, 10, Color.BLACK, 2, "\n".join(lines))
        lines.clear()


func _on_mouse_moved(control: Control, local_mouse_coords: Vector2) -> void:
    var line := append_to_line("", control.name, local_mouse_coords)

    var sub_viewport: SubViewport = control.get_viewport() as SubViewport
    if sub_viewport:
        # control is inside a SubViewport
        var sub_viewport_canvas_coords := control.get_global_transform_with_canvas() * local_mouse_coords
        line = append_subviewport_info(line, sub_viewport, sub_viewport_canvas_coords)

    line = append_viewport_and_canvas_info(line, control, local_mouse_coords)
    lines.append(line)
    queue_redraw()


func append_to_line(line: String, name_or_class: String, pos: Vector2) -> String:
    return line + "%s%s: %s" % ["" if line == "" else " → ", name_or_class, Format.format_position(pos)]


func append_subviewport_info(line: String, sub_viewport: SubViewport, sub_viewport_canvas_coords: Vector2) -> String:
    line = append_to_line(line, "Canvas (%s)" % [sub_viewport.name], sub_viewport_canvas_coords)

    var sub_viewport_container: SubViewportContainer = sub_viewport.get_parent() as SubViewportContainer
    if sub_viewport_container && sub_viewport_container.stretch:
        # sub_viewport is inside a SubViewportContainer
        sub_viewport_canvas_coords *= sub_viewport_container.stretch_shrink
        line = append_to_line(line, sub_viewport_container.name, sub_viewport_canvas_coords)
        line = append_viewport_and_canvas_info(line, sub_viewport_container, sub_viewport_canvas_coords)

    return line


func append_viewport_and_canvas_info(line: String, control: Control, local_control_coords: Vector2) -> String:
    var viewport := control.get_viewport()
    var canvas_coords := control.get_global_transform_with_canvas() * local_control_coords

    if viewport is not SubViewport:
        line = append_to_line(line, "Canvas (%s)" % [viewport.get_class()], canvas_coords)

    if viewport is Window:
        var window_coords := control.get_viewport().get_screen_transform() * canvas_coords
        line = append_to_line(line, "%s (%s)" % [viewport.get_class(), viewport.name], window_coords)

    return line
