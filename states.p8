pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

state = 'title'
state_cooldown = 0

function state_update()
    if state == 'title' then title_update() end
    if state == 'world' then world_update() end
    if state == 'battle' then battle_update() end
    if state_cooldown > 0 then state_cooldown -= 1 end
end

function state_draw()
    if state == 'title' then title_draw() end
    if state == 'world' then world_draw() end
    if state == 'battle' then battle_draw() end
end

function title_update()
    if x_btn.is_pressed and state_cooldown == 0 then 
        state = 'world'
        state_cooldown = 10
    end
end

function title_draw()
    cls()
    print_centered("quest 8", 64, 20, 2)
    print_centered("press x to continue", 64, 70, 2)
    text_small("testtext", 16, 100)
    --sspr(88,0,16,16,5,99)
    spr(32,7,104)
end

function world_update()
    if x_btn.is_pressed and state_cooldown == 0 then 
        state = 'battle' 
        state_cooldown = 10
    end
    if z_btn.is_pressed and state_cooldown == 0 then 
        state = 'title' 
        state_cooldown = 10
    end
    world_p_update()
end

function world_draw()
    cls()
    map(0,0,0,0,16,16)
    print_centered("you are in the world state", 64, 40, 2)
    world_p_draw()
end

function battle_update()
    if z_btn.is_pressed and state_cooldown == 0 then 
        state = 'world' 
        state_cooldown = 10
    end
end

function battle_draw()
    cls()
    map(111, 0, 0, 0, 16, 16)
    print_centered("on the battlefield!", 64, 100, 1)
    text_small("air cutter", 72, 30)
    text_small("rock throw", 0, 30)
    text_small("fireball", 36, 12)
    text_small("water pillar", 36, 48)
    spr(32,60,24)
    spr(33,52,33)
    spr(34,68,33)
    spr(35,60,42)
end


