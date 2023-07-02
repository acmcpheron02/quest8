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

    spr(048,10,92,1,1,false,true)
    spr(048,10,100)
    for x=1,5 do
        spr(049,10+x*8,92,1,1,false,true)
        spr(049,10+x*8,100,1,1,false,false)
    end
    spr(048,58,92,1,1,true, true)
    spr(048,58,100,1,1,true)
    --line(11,99,40,99,10)
    print("w pillar",14,97,7)

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
    print_centered("on the battlefield!", 64, 60, 1)
end


