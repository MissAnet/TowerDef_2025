if (place_meeting(x, y, oEnemy)) {
	
    var enemy = instance_place(x, y, oEnemy);
	
	if (!invincible && is_alive && !enemy.is_hit) {
        var damage_amount = enemy.attack_damage;
        take_damage(damage_amount);
        
        // Отметить врага как атаковавшего
        enemy.is_hit = true;
        enemy.alarm[0] = 90; // 3 секунды задержки
    }
}