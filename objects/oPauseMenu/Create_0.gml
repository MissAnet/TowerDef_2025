// Состояние меню
is_active = false;
game_over = false;

// Настройки кнопок
buttons = [];
button_width = 200;
button_height = 60;
button_spacing = 30;

// Создаем кнопки
buttons[0] = {
    text: "RESTART",
    action: function() { room_restart(); },
    x: 0,
    y: 0,
    width: button_width,
    height: button_height,
    hover: false
};

buttons[1] = {
    //text: "GO OUT IN RAGE",
    text: "EXIT",
    action: function() { game_end(); },
    x: 0,
    y: 0,
    width: button_width,
    height: button_height,
    hover: false
};

// Позиционирование
menu_x = display_get_gui_width() / 2;
menu_y = display_get_gui_height() / 2;

// Шрифт
fnt_menu = fnt_main;
menu_font = fnt_menu // Должен быть создан в ресурсах
