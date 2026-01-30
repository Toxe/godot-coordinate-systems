class_name DebugDraw

const font_size := 24
const font_outline_size := 6

static var project_theme := ThemeDB.get_project_theme()


static func draw_label(canvas_item: CanvasItem, pos: Vector2, text: String, text_color: Color, outline_color: Color) -> void:
    if canvas_item.visible:
        var label_size := project_theme.default_font.get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_RIGHT, -1, font_size)
        var label_rect := Rect2(pos + Vector2(roundf(-label_size.x / 2.0), font_size), label_size)
        var viewport_rect := canvas_item.get_viewport_rect()

        var moved_rect := Rect2(label_rect)
        if label_rect.end.x > viewport_rect.end.x:
            moved_rect.position.x += viewport_rect.end.x - label_rect.end.x
        elif label_rect.position.x < viewport_rect.position.x:
            moved_rect.position.x += viewport_rect.position.x - label_rect.position.x

        if label_rect.end.y > viewport_rect.end.y:
            moved_rect.position.y += viewport_rect.end.y - label_rect.end.y
        elif label_rect.position.y < viewport_rect.position.y:
            moved_rect.position.y += viewport_rect.position.y - label_rect.position.y

        canvas_item.draw_multiline_string_outline(project_theme.default_font, moved_rect.position + Vector2(0, font_size), text, HORIZONTAL_ALIGNMENT_RIGHT, moved_rect.size.x + 1, font_size, -1, font_outline_size, outline_color)
        canvas_item.draw_multiline_string(project_theme.default_font, moved_rect.position + Vector2(0, font_size), text, HORIZONTAL_ALIGNMENT_RIGHT, moved_rect.size.x + 1, font_size, -1, text_color)


static func draw_labeled_circle(canvas_item: CanvasItem, pos: Vector2, radius: float, color: Color, width: float, text: String) -> void:
    canvas_item.draw_circle(pos, radius, color, false, width)
    draw_label(canvas_item, pos + Vector2(0, radius), text, Color.WHITE, Color.BLACK)
