// Обработка ESC для паузы
if (keyboard_check_pressed(vk_escape) && instance_exists(oPlayer) && oPlayer.is_alive) {
    is_active = !is_active;
    game_paused = is_active;
    
    if (game_paused) {
        // Пауза всей игры
        instance_deactivate_all(true);
		layer_set_visible("Assets_1",false);
        instance_activate_object(oPauseMenu);
    } else {
        // Продолжение игры
        instance_activate_all();
    }
}

// Активация меню при смерти игрока
if (game_over) {
    is_active = true;
    game_paused = true;
    instance_deactivate_all(true);
    layer_set_visible("Assets_1",false);
	
    instance_activate_object(oPauseMenu);
}

// Обработка кликов по кнопкам (только если меню активно)
if (is_active) {
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);
    
    if (mouse_check_button_pressed(mb_left)) {
        for (var i = 0; i < array_length(buttons); i++) {
            var btn = buttons[i];
            if (mx > btn.x - btn.width/2 && mx < btn.x + btn.width/2 &&
                my > btn.y - btn.height/2 && my < btn.y + btn.height/2) {
                btn.action();
            }
        }
    }
    
    // Обновление состояния hover
    for (var i = 0; i < array_length(buttons); i++) {
        var btn = buttons[i];
        btn.hover = (mx > btn.x - btn.width/2 && mx < btn.x + btn.width/2 &&
                    my > btn.y - btn.height/2 && my < btn.y + btn.height/2);
    }
}