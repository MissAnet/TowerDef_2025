// Устанавливаем параметры отрисовки
draw_set_color(c_white);
draw_set_font(fnt_main);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Получаем ссылки на объекты
var player_instance = instance_find(oPlayer, 0);
var tower_instance = instance_find(oTower, 0);

// Проверяем, существует ли игрок
if (instance_exists(player_instance))
{
    // Получаем размеры спрайтов
    var heart_width = sprite_get_width(heartSprite);
    var coin_width = sprite_get_width(coinSprite);

    // 1. Отрисовка HP игрока слева сверху
    var base_y = 10; // Начальная позиция по Y
    draw_sprite(heartSprite, 0, 10, base_y);
    draw_text(10 + heart_width + 5, base_y, 
              "HP: " + string(player_instance.hp) + 
              "/" + string(player_instance.max_hp));

    // 2. Отрисовка Tower HP под HP игрока
    if (instance_exists(tower_instance))
    {
        draw_sprite(heartSprite, 0, 10, base_y + 30);
        draw_text(10 + heart_width + 5, base_y + 30,
                 "Tower: " + string(tower_instance.hp) +
                 "/" + string(tower_instance.max_hp));
    }
    else
    {
        draw_set_color(c_yellow);
        draw_text(10, base_y + 30, "TOWER DESTROYED");
        draw_set_color(c_white);
    }

    // 3. Отрисовка монет справа сверху
    var coin_x = display_get_gui_width() - coin_width - 100;
    draw_sprite(coinSprite, 0, coin_x, base_y);
    draw_text(coin_x + coin_width + 5, base_y, string(player_instance.coins));
}
else
{
    // Альтернативный вывод, если игрок не найден
    draw_set_color(c_red);
    draw_text(10, 10, "PLAYER NOT FOUND");
    draw_set_color(c_white);
}

// Отображение информации о волнах
var wave_controller = instance_find(oSpawner, 0);
if (instance_exists(wave_controller)) 
{
    if (wave_controller.wave_in_progress) {
        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text(room_width/2, 20, "Wave " + string(wave_controller.current_wave) + 
                  ": " + string(wave_controller.enemies_alive) + "/" + string(wave_controller.enemies_in_wave));
        
        draw_text(room_width/2, 40, "The next enemy: " + 
                  string(max(0, wave_controller.spawn_interval - wave_controller.spawn_timer)/room_speed) + " sec");
    } 
    else if (wave_controller.wave_cooldown > 0) {
        draw_set_color(c_yellow);
        draw_text(room_width/2, 20, "Until the next wave: " + 
                  string(ceil(wave_controller.wave_cooldown/room_speed)) + " sec");
    }
}