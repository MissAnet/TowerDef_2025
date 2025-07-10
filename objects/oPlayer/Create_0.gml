hsp = 0;
vsp = 0;
grv = 0.1;
walksp = 4;
jump_force = 3;
facing_direction = 1;

hp = 100
max_hp = 100;
coins = 0;
attack_damage = 25;
lives = 3 ;

is_jumping = false;
is_attacking = false;
is_alive = true;
can_attack = true;

invincible = false;         // Флаг неуязвимости
invincible_timer = 0;       // Таймер неуязвимостиdddd
invincible_duration = 90;

respawn_timer = 0;
respawn_delay = room_speed * 7; // 5 секунд до воскрешения

attack_cooldown = 0;
attack_radius = 120; 
attack_cooldown_time = 5; 

//анимации
spr_player_attack = awSprite;
dead_sprite = deadSprite;
walk_sprite = rSprite;
jump_sprite = jSprite;
default_sprite = sSprite;

attack_animation_speed =1
walk_animation_speed =1
hit_animation_speed =1
death_animation_speed =1

//исправление 
death_animation_played = false;
landing_timer = 0;
landing_delay = 10;
enum PLAYER_STATE {
    IDLE,
    WALK,
    JUMP,
    ATTACK,
    DEAD
}
current_state = PLAYER_STATE.IDLE;
prev_state = PLAYER_STATE.IDLE;
animation_lock = false;

