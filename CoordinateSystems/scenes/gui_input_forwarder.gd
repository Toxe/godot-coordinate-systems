class_name GUIInputForwarder extends TextureRect

@export var sub_viewport: SubViewport


func _notification(what: int) -> void:
    # Due to a bug we need to manually send NOTIFICATION_VP_MOUSE_ENTER to the SubViewport,
    # because otherwise we wouldn't be able to push InputEventMouseMotion events.
    # https://github.com/godotengine/godot/issues/115265
    match what:
        NOTIFICATION_MOUSE_ENTER: sub_viewport.notification(NOTIFICATION_VP_MOUSE_ENTER)
        NOTIFICATION_MOUSE_EXIT: sub_viewport.notification(NOTIFICATION_VP_MOUSE_EXIT)


func _input(event: InputEvent) -> void:
    if !is_propagated_in_gui_input(event):
        sub_viewport.push_input(event)


func _unhandled_input(event: InputEvent) -> void:
    if !is_propagated_in_gui_input(event):
        sub_viewport.push_input(event)


func _gui_input(event: InputEvent) -> void:
    if is_propagated_in_gui_input(event):
        if event is InputEventMouse:
            var ev: InputEventMouse = event.duplicate()

            if ev is InputEventMouseMotion:
                Events.mouse_moved.emit(self, ev.position)

            ev.position = to_viewport_coords(ev.position)
            sub_viewport.push_input(ev)
        else:
            sub_viewport.push_input(event)


func is_propagated_in_gui_input(event: InputEvent) -> bool:
    return event is InputEventMouse || event is InputEventScreenDrag || event is InputEventScreenTouch || event is InputEventGesture


func to_viewport_coords(pos: Vector2) -> Vector2:
    var normalized_pos := pos / size
    if flip_h:
        normalized_pos.x = 1.0 - normalized_pos.x
    if flip_v:
        normalized_pos.y = 1.0 - normalized_pos.y
    return normalized_pos * Vector2(sub_viewport.size)
