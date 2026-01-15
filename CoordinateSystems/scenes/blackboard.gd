class_name Blackboard extends Control

var points: PackedVector2Array

@onready var coords_label: Label = $CoordsLabel
@onready var info_label: Label = $InfoLabel


func _ready() -> void:
    info_label.text = "%s\nsize: %s, scale: %s" % [name, Format.format_size(size), Format.format_size(scale)]


func _on_mouse_exited() -> void:
    coords_label.text = ""


func _on_gui_input(event: InputEvent) -> void:
    var mouse_motion_event: InputEventMouseMotion = event as InputEventMouseMotion
    if mouse_motion_event:
        coords_label.text = Format.format_position(mouse_motion_event.position)
        Events.mouse_moved.emit(self, mouse_motion_event.position, get_global_transform() * mouse_motion_event.position)

        if mouse_motion_event.button_mask == 1:
            if get_global_rect().has_point(mouse_motion_event.global_position):
                points.append(mouse_motion_event.position)
                queue_redraw()


func _draw() -> void:
    if points.size() >= 2:
        draw_polyline(points, Color.WHEAT, 5)
