if (is_active) {
    // Полупрозрачный черный фон
    draw_set_alpha(0.7);
    draw_set_color(c_black);
    draw_rectangle(0, 0, display_get_gui_width(), display_get_gui_height(), false);
    draw_set_alpha(1);
    
    // Заголовок
    draw_set_font(menu_font);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text(menu_x, menu_y - 100, "GAME OVER");
    
    // Отрисовка кнопок
    for (var i = 0; i < array_length(buttons); i++) {
        var btn = buttons[i];
        btn.x = menu_x;
        btn.y = menu_y + i * (button_height + button_spacing);
        
        // Рамка кнопки
        draw_set_color(btn.hover ? c_yellow : c_white);
        draw_rectangle(
            btn.x - btn.width/2,
            btn.y - btn.height/2,
            btn.x + btn.width/2,
            btn.y + btn.height/2,
            false
        );
        
        // Текст кнопки
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_black);
        draw_text(btn.x, btn.y, btn.text);
    }
}