// В DRAW GUI EVENT (альтернатива без спрайтов)
if (controls_show_timer > 0) {
    draw_set_font(fnt_control);
    draw_set_halign(fa_center);
    draw_set_color(c_black);
    
    y = 100;
    draw_text(room_width/2, y, "Controls:");
    y += 30;
    draw_text(room_width/2, y, "Move: WASD       Jump: Space");
    y += 30;
    draw_text(room_width/2, y, "Attack: LMB      PAUSE: ESC");
}