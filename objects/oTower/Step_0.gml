// Проверка смерти башни
if (hp <= 0) {
	oPauseMenu.game_over = true;
	if (instance_exists(oPauseMenu)) {
        var menu = instance_create_depth(0, 0, -100, oPauseMenu);
        menu.is_game_over = true; // Передаем флаг в меню
    }
}