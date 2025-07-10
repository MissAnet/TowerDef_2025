function take_damage(amount) {
    if (invincible || !is_alive) return;
    
    hp -= amount;
    
    // Эффект получения урона
    if (hp > 0) {
        invincible = true;
        invincible_timer = invincible_duration;
        
        // Отбрасывание персонажа
        var enemy = instance_place(x, y, oEnemy);
        if (instance_exists(enemy)) {
            hsp = sign(x - enemy.x) * 4; // Отлет в противоположную сторону
            vsp = -1; // Небольшой подскок
        }
    } else {
        hp = 0;
        die();
    }
}

// урон
function perform_attack() {
    if (!can_attack || is_attacking) return;
    
    is_attacking = true;
    can_attack = false;
    attack_cooldown = attack_cooldown_time;
    
    current_state = PLAYER_STATE.ATTACK;
    prev_state = on_ground ? (hsp != 0 ? PLAYER_STATE.WALK : PLAYER_STATE.IDLE) : PLAYER_STATE.JUMP;
    animation_lock = true;
    
    sprite_index = spr_player_attack;
    image_speed = attack_animation_speed;
    image_index = 0;
    
    var enemies_in_radius = ds_list_create();
    instance_place_list(x, y, oEnemy, enemies_in_radius, false);
    
    for (var i = 0; i < ds_list_size(enemies_in_radius); i++) {
        var enemy = enemies_in_radius[| i];
        if (instance_exists(enemy)) {
            enemy.take_damage(attack_damage);
        }
    }
    ds_list_destroy(enemies_in_radius);
}

//смерть
function die() {
    if (!is_alive) return;
    
    is_alive = false;
    lives--;
    death_animation_played = false; // Сбрасываем флаг при новой смерти
    
    hsp = 0;
    vsp = 0;
    
    current_state = PLAYER_STATE.DEAD;
    animation_lock = true;
    sprite_index = dead_sprite;
    image_speed = death_animation_speed;
    image_index = 0; // Начинаем анимацию с первого кадра
    
    if (lives > 0) {
        respawn_timer = respawn_delay;
    } else {
        oPauseMenu.game_over = true;
        if (instance_exists(oPauseMenu)) {
            var menu = instance_create_depth(0, 0, -100, oPauseMenu);
            menu.is_game_over = true;
        }
    }
}

// RESPAWN
function respawn() {
    if (lives <= 0) return;
    
    var tower = instance_nearest(x, y, oTower);
    if (instance_exists(tower)) {
        x = tower.x;
        y = tower.y - 50;
    }
    
    is_alive = true;
    death_animation_played = false; // Сбрасываем флаг при возрождении
    hp = max_hp;
    invincible = true;
    invincible_timer = 210;
    
    current_state = PLAYER_STATE.IDLE;
    animation_lock = false;
    sprite_index = default_sprite;
    image_speed = 1; // Восстанавливаем скорость анимации
    image_index = 0;
}



function is_on_ground() {
    return (place_meeting(x, y+1, oGround) ||
           place_meeting(x, y+1, oGroundRoad) || 
           place_meeting(x, y+1, oLeftGroundRoad) ||  
           place_meeting(x, y+1, oRightGroundRoad));
}

function check_collision_with_grounds(xpos, ypos) {
    return (place_meeting(xpos, ypos, oGround) ||
           place_meeting(xpos, ypos, oGroundRoad) || 
           place_meeting(xpos, ypos, oLeftGroundRoad) ||  
           place_meeting(xpos, ypos, oRightGroundRoad));
}

// 1. Обработка состояний и физики
if (is_alive) {
    key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
    key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
    key_jump = keyboard_check_pressed(vk_space) || keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"));

    // Устанавливаем горизонтальную скорость
    hsp = (key_right - key_left) * walksp;
    
    // Обработка прыжка
    on_ground = is_on_ground();
    
    if (on_ground) {
        is_jumping = false;
        if (key_jump && !is_attacking) {
            vsp = -jump_force;
            is_jumping = true;
        }
    }

    // Применяем гравитацию если не на земле
    if (!on_ground) {
        vsp += grv;
        if (vsp > 10) vsp = 10;
    }

    // Горизонтальные коллизии
    if (hsp != 0) {
        if (check_collision_with_grounds(x + hsp, y)) {
            var try_y = y - 5;
            if (!check_collision_with_grounds(x + hsp, try_y)) {
                y = try_y;
            } else {
                hsp = 0;
            }
        }
        
        var new_dir = sign(hsp);
        if (new_dir != 0) {
            facing_direction = new_dir;
            image_xscale = facing_direction;
        }
        x += hsp;
    }

    // Вертикальные коллизии
    if (vsp != 0) {
        if (check_collision_with_grounds(x, y + vsp)) {
            if (vsp > 0) on_ground = true;
            vsp = 0;
        }
        y += vsp;
    }
    
    // Обработка атаки
    if (mouse_check_button_pressed(mb_left) && can_attack && !is_attacking) {
        perform_attack();
    }
} else {
    hsp = 0;
    vsp = 0;
}

// 2. Система анимаций
var new_state = PLAYER_STATE.IDLE;

if (!is_alive) {
    new_state = PLAYER_STATE.DEAD;
}
else if (is_attacking) {
    new_state = PLAYER_STATE.ATTACK;
}
else if (hsp != 0) {
    new_state = PLAYER_STATE.WALK;
}
else {
    if (landing_timer > 0) {
        new_state = PLAYER_STATE.JUMP;
        landing_timer--;
    }
}

// Смена состояния
if (new_state != current_state && !animation_lock) {
    if (!(current_state == PLAYER_STATE.JUMP && new_state == PLAYER_STATE.IDLE && landing_timer > 0)) {
	
	prev_state = current_state;
    current_state = new_state;
    image_index = 0;
    
    switch(current_state) {
        case PLAYER_STATE.ATTACK:
            sprite_index = spr_player_attack;
            image_speed = attack_animation_speed;
            animation_lock = true;
            break;
            
        case PLAYER_STATE.WALK:
            sprite_index = walk_sprite;
            image_speed = walk_animation_speed;
            break;
            
        case PLAYER_STATE.JUMP:
            sprite_index = jump_sprite;
            image_speed = 1;
            break;
            
        case PLAYER_STATE.DEAD:
            sprite_index = dead_sprite;
            image_speed = death_animation_speed;
            animation_lock = true;
            break;
            
        default:
            sprite_index = default_sprite;
            image_speed = 1;
            image_index = 0;
		}
    }
}

if (vsp != 0) {
    if (check_collision_with_grounds(x, y + vsp)) {
        if (vsp > 0) {
            on_ground = true;
            // Устанавливаем таймер приземления только если падали вниз
            if (current_state == PLAYER_STATE.JUMP) {
                landing_timer = landing_delay;
            }
        }
        vsp = 0;
    }
    y += vsp;
}

// Обработка завершения анимации атаки
if (current_state == PLAYER_STATE.ATTACK && image_index >= image_number - 1) {
    is_attacking = false;
    animation_lock = false;
    
    if (hsp != 0 && on_ground) {
        current_state = PLAYER_STATE.WALK;
        sprite_index = walk_sprite;
    } else {
        current_state = on_ground ? PLAYER_STATE.IDLE : PLAYER_STATE.JUMP;
        sprite_index = on_ground ? default_sprite : jump_sprite;
    }
    image_index = 0;
}

// 3. Обработка перезарядки атаки
if (attack_cooldown > 0) {
    attack_cooldown--;
} else if (!can_attack) {
    can_attack = true;
}

// 4. Обработка неуязвимости
if (invincible) {
    invincible_timer--;
    image_alpha = (invincible_timer % 10 < 5) ? 0.5 : 1;
    
    if (invincible_timer <= 0) {
        invincible = false;
        image_alpha = 1;
    }
}

// 5. Возрождения
if (!is_alive) {
    new_state = PLAYER_STATE.DEAD;
    
    // Проверяем, что анимация смерти еще не проиграна
    if (!death_animation_played) {
        // Если анимация дошла до последнего кадра
        if (image_index >= image_number - 1) {
            death_animation_played = true; // Помечаем как проигранную
            image_speed = 0; // Останавливаем анимацию
            image_index = image_number - 1; // Фиксируем на последнем кадре
        }
        else {
            image_speed = death_animation_speed; // Продолжаем проигрывать
        }
    }
	if (lives > 0) {
    respawn_timer--;
    if (respawn_timer <= 0) {
        respawn();
    }
}
}