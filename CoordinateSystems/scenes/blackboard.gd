class_name Blackboard extends Control

var dots: PackedVector2Array

@onready var coords_label: Label = $CoordsLabel
@onready var info_label: Label = $InfoLabel


func _ready() -> void:
    info_label.text = "%s\nsize: %s\nscale: %s" % [name, Format.format_size(size), Format.format_size(scale)]
    coords_label.visible = false


func _on_mouse_exited() -> void:
    coords_label.visible = false


func _gui_input(event: InputEvent) -> void:
    var mouse_event: InputEventMouse= event as InputEventMouse
    if mouse_event:
        coords_label.text = Format.format_position(mouse_event.position)
        coords_label.visible = true
        Events.mouse_moved.emit(self, mouse_event.position)

        if mouse_event.button_mask == 1:
            if get_global_rect().has_point(mouse_event.global_position):
                dots.append(mouse_event.position)
                queue_redraw()


func _draw() -> void:
    for dot in dots:
        draw_circle(dot, 5, Color.WHEAT, true)
