// Основные параметры
hp = 50;
max_hp = 50;
attack_damage = 10;
move_speed = 1.5;
is_alive = true;
coin_reward_amount = 50;

// Состояния
is_attacking = false;
is_hit = false;
current_target = noone;

// Таймеры
attack_cooldown = 0;
hit_timer = 0;
death_frame = 0;

// Анимационные параметры
walk_sprite = skeletWalkSprite;
attack_sprite = skeletAtackSprite;
hit_sprite = skeletHitSprite;
dead_sprite = skeletDeadSprite;

attack_animation_speed =1 //1/6; // 6 кадров в секунду
walk_animation_speed =1 //1/7;   // 7 кадров в секунду
hit_animation_speed =1 //1/2;    // 2 кадра в секунду
death_animation_speed =1 //1/4;  // 4 кадра в секунду

// Начальная настройка
sprite_index = walk_sprite;
image_speed = walk_animation_speed;

alarm[0] = 0;