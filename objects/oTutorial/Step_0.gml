if (controls_show_timer * room_speed > 0) {
    controls_show_timer--; // Уменьшаем таймер
    
    // Начинаем исчезать в последние 0.5 секунды
    if (controls_show_timer < room_speed * 0.5 ) {
        controls_alpha -= fade_out_speed;
        if (controls_alpha <= 0) {
            controls_alpha = 0;
            should_destroy = true;
        }
    }
}

// Уничтожаем объект после исчезновения
if (should_destroy) {
    instance_destroy();
}