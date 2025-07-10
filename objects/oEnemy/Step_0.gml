function move_to_target() {
    if (!instance_exists(current_target)) return;
    
    var dir = sign(current_target.x - x);
    x += dir * move_speed;
    sprite_index = walk_sprite;
    image_speed = walk_animation_speed;
}

function start_attack() {
    if (is_attacking || is_hit) return;
    
    is_attacking = true;
    sprite_index = attack_sprite;
    image_speed = attack_animation_speed;
    image_index = 0;
}

function take_damage(amount) {
    hp -= amount;
    
	if (hp <= 0) {
		die();
        instance_destroy();
    } else {
        // Эффект получения урона
        image_blend = c_red;
        alarm[0] = 5;
    }
	
	
	is_hit = true;
    hit_timer = 15;
    sprite_index = hit_sprite;
    image_speed = hit_animation_speed;
    image_index = 0;
}

function die() {
    is_alive = false;
    sprite_index = dead_sprite;
    image_speed = death_animation_speed;
    image_index = 0;
    

    with (oPlayer) {
        coins += other.coin_reward_amount;
    }
	var controller = instance_find(oSpawner, 0);
		if (instance_exists(controller)) {
		    controller.enemies_alive--;
}
}


// Проверка смерти
if (hp <= 0 && is_alive) {
    die();
    exit;
}

// Обработка получения урона
if (is_hit) {
    hit_timer--;
    if (hit_timer <= 0) {
        is_hit = false;
        sprite_index = walk_sprite;
        image_speed = walk_animation_speed;
    }
    exit;
}

// Выбор цели
if (instance_exists(oPlayer))
    current_target = oPlayer;
if (instance_exists(oTower)) {
    current_target = oTower;
} else {
    current_target = noone;
}

// Логика движения и атаки
if (!is_attacking && instance_exists(current_target)) {
    var dist = point_distance(x, y, current_target.x, current_target.y);
    
    // Если в радиусе атаки - атаковать
    if (dist < 40) {
        start_attack();
    } 
    // Иначе двигаться к цели
    else {
        move_to_target();
    }
}

// Обработка атаки
if (is_attacking) {
    attack_cooldown--;
    
    // Нанесение урона на 4 кадре
    if (image_index == 3 && attack_cooldown <= 0) {
        if (place_meeting(x, y, current_target)) {
            with (current_target) {
                hp -= other.attack_damage;
            }
            attack_cooldown = room_speed * 2; // 2 секунды кулдаун
        }
    }
    
    // Завершение атаки
    if (image_index >= image_number-1) {
        is_attacking = false;
        sprite_index = walk_sprite;
        image_speed = walk_animation_speed;
    }
}

// Обновление направления
if (!is_attacking && !is_hit) {
    if (instance_exists(current_target)) {
        image_xscale = sign(current_target.x - x);
    }
}