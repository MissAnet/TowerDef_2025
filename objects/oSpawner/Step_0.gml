/*// Увеличиваем таймер
spawn_timer += 1;

// Проверяем условия для спавна
if (spawn_timer >= spawn_interval && instance_exists(oPlayer)) 
{
	spawn_interval = irandom_range(min_spawn_interval, max_spawn_interval) * room_speed;
    // Получаем координаты центра спавнера
    var spawn_x = x;
    var spawn_y = y;
    
    // Если есть спрайт, вычисляем центр
    if (sprite_index != -1) {
        spawn_x += sprite_width / 2;
        spawn_y += sprite_height / 2;
    }
    
    // Создаем врага
    with (instance_create_depth(spawn_x, spawn_y, depth, oEnemy)) {
        hsp = -2; // Скорость движения влево
        target = oPlayer; // Цель - игрок
    }
    
    // Сбрасываем таймер
    spawn_timer = 0;
}
*/

function start_new_wave() {
    current_wave++;
    wave_in_progress = true;
    enemies_spawned = 0;
    
    // Увеличиваем сложность
    if (current_wave > 1) {
        enemies_in_wave = floor(enemies_in_wave * 1.5);
    }
    
    show_debug_message("Начало волны " + string(current_wave) + 
                      ". Врагов: " + string(enemies_in_wave));
}

function spawn_enemy() {
    var spawn_x = x;
    var spawn_y = y;
    
    if (sprite_index != -1) {
        spawn_x += sprite_width / 2;
        spawn_y += sprite_height / 2;
    }
    
    with (instance_create_depth(spawn_x, spawn_y, depth, oEnemy)) {
        hsp = -2;
        target = oPlayer;
        
        // Увеличиваем сложность врагов с волнами
        hp += other.current_wave * 1.5;
        attack_damage += other.current_wave * 0.5;
    }
    
    enemies_spawned++;
    enemies_alive++;
    
    // Можно добавить случайный интервал спавна
    spawn_interval = irandom_range(min_spawn_interval, max_spawn_interval)*room_speed;
}

function end_wave() {
    wave_in_progress = false;
    wave_cooldown = base_wave_cooldown;
    
	// Восстанавливаем здоровье игрока
    var player = instance_find(oPlayer, 0);
    if (instance_exists(player)) {
        player.hp = player.max_hp; // Полное восстановление
        
        show_debug_message("The player has been restored to " + string(player.hp) + " HP");
    }
	
    show_debug_message("Wave " + string(current_wave) + " completed. " + 
                      "The next one is in 10 seconds");
	
}


//волны
if (!wave_in_progress && wave_cooldown <= 0) {
    start_new_wave();
}

if (wave_in_progress) {
    // Увеличиваем таймер спавна
spawn_timer += 1;
    
    // Спавним нового врага если пришло время и не превышен лимит волны
    if (spawn_timer >= spawn_interval && enemies_spawned < enemies_in_wave && instance_exists(oPlayer)) {
        spawn_enemy();
        spawn_timer = 0;
    }
    
    // Проверяем завершение волны
    if (enemies_spawned >= enemies_in_wave && enemies_alive <= 0) {
        end_wave();
    }
} 
else if (wave_cooldown > 0) {
    // Обратный отсчет перерыва между волнами
    wave_cooldown--;
	
}
