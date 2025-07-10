if (is_alive && !is_hit && other.is_alive) {
    // Получение урона от игрока
    if (other.is_attacking) {
        take_damage(other.attack_damage);
    }
    
    // Начало атаки, если не атакуем
    if (!is_attacking) {
        current_target = other;
        start_attack();
    }
}