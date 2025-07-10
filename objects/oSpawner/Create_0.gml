// Таймер и интервал спавна (5 секунд)
hp = 500;
max_hp = 500;

spawn_timer = 0;
spawn_interval = 5 * room_speed; // room_speed = кадров в секунду (обычно 30 или 60)
min_spawn_interval = 1;
max_spawn_interval = 5;


// Настройки волн
current_wave = 0;
enemies_in_wave = 10;
enemies_spawned = 0;
enemies_alive = 0;
wave_cooldown = 0;
wave_in_progress = false;
base_wave_cooldown = room_speed * 10;


