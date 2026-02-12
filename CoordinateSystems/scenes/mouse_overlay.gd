class_name MouseOverlay extends Node2D

var lines: Array[String]


func _ready() -> void:
    Events.mouse_moved.connect(_on_mouse_moved)


func _draw() -> void:
    if !lines.is_empty():
        var mouse_pos := get_viewport().get_mouse_position()
        DebugDraw.draw_labeled_circle(self, mouse_pos, 10, Color.MAGENTA, 2, lines)
        lines.clear()


func _on_mouse_moved(control: Control, local_control_coords: Vector2) -> void:
    var output_parts := calculate_transformations(control, local_control_coords)
    lines.append(" → ".join(output_parts))
    queue_redraw()


func calculate_transformations(control: Control, local_control_coords: Vector2) -> Array[String]:
    var output_parts: Array[String]
    output_parts.append(format_line_part(control.name, local_control_coords))

    # Is the control inside a SubViewport?
    var sub_viewport: SubViewport = control.get_viewport() as SubViewport
    if sub_viewport:
        var coords_on_sub_viewport_canvas := control.get_global_transform_with_canvas() * local_control_coords
        output_parts.append(format_line_part("Canvas (%s)" % [sub_viewport.name], coords_on_sub_viewport_canvas))

        # Is sub_viewport inside a SubViewportContainer?
        var sub_viewport_container: SubViewportContainer = sub_viewport.get_parent() as SubViewportContainer
        if sub_viewport_container:
            var local_sub_viewport_container_coords := coords_on_sub_viewport_canvas
            if sub_viewport_container.stretch && sub_viewport_container.stretch_shrink > 1:
                local_sub_viewport_container_coords *= sub_viewport_container.stretch_shrink
            # recurse down into the SubViewportContainer
            output_parts.append_array(calculate_transformations(sub_viewport_container, local_sub_viewport_container_coords))
    else:
        # control is not inside a SubViewport, therefore it is (probably) inside the root Window (aka. the screen)
        var viewport := control.get_viewport()
        var coords_on_canvas := control.get_global_transform_with_canvas() * local_control_coords
        output_parts.append(format_line_part("Canvas (%s)" % [viewport.get_class()], coords_on_canvas))

        if viewport is Window:
            var window_coords := viewport.get_screen_transform() * coords_on_canvas
            output_parts.append(format_line_part("%s (%s)" % [viewport.get_class(), viewport.name], window_coords, true))

    return output_parts


func format_line_part(label: String, pos: Vector2, trim_trailing_zeros := false) -> String:
    return "%s: %s" % [label, Format.format_position(pos, trim_trailing_zeros)]
