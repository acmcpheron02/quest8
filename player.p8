pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

readybit = 0

pl = {
    world_x=0,
    world_y=0,
    world_h=8,
    world_w=7,
    world_xflip=false,
    battle_x=0,
    battle_y=0,
    battle_h=16,
    battle_w=11,
    battle_xflip=false,
    earth=0,
    water=0,
    wind=0,
    fire=0,
    patk=10,
    matk=10,
    hp=30,
    mp=30,
    def=10,
    agi=10
}
function world_p_update()
    world_p_move()
end

function world_p_draw()
    sspr(56,0,pl.world_w, pl.world_h, pl.world_x, pl.world_y, pl.world_w, pl.world_h, pl.world_xflip)
    sspr(0,0,pl.battle_w, pl.battle_h, pl.world_x+16, pl.world_y+16, pl.battle_w, pl.battle_h, pl.battle_xflip)
    print(pl.world_x, 10, 10, 9)

end

function world_p_move()
    local spd = 0.5
    local dx, dy = direction_control()
    if dx != 0 and dy != 0 and (pl.world_x%1 != pl.world_y%1) then
        pl.world_x = flr(pl.world_x + 0.5)
        pl.world_y = flr(pl.world_y + 0.5)
    end
    pl.world_x += dx * spd
    pl.world_y += dy * spd
end

--[[
0 = left, earth
1 = right, air
2 = up, fire
3 = down, water
--]]

spells = {}

    spells['6'] = {name = 'strike', cat = 'p', power = 30}
    spells['60'] = {name = 'rock throw', cat = 'm', power = 30}
    spells['61'] = {name = 'wind cutter', cat = 'm', power = 30}
    spells['62'] = {name = 'fireball', cat = 'm', power = 30}
    spells['63'] = {name = 'water pillar', cat = 'm', power = 30}


function spell_control()
    local ix, iy = direction_control()
    local out
    if ix == 0 and iy == 0 then
        readybit = 1
    end
    if readybit == 1 then      
        if btn(0) then out, readybit = '0', 0 end
        if btn(1) then out, readybit = '1', 0 end
        if btn(2) then out, readybit = '2', 0 end
        if btn(3) then out, readybit = '3', 0 end
        if z_btn.is_pressed then out, readybit = 'back', 0 end
    end
    return out
end

spell_index = '6'
function current_spell()
    nextindex = spell_control()
    if nextindex != nil and nextindex != 'back' then
        spell_index = spell_index..nextindex
    end
    if nextindex == 'back' and spell_index != '6' then
        spell_index = sub(spell_index, 1, -2)
    end   
    local spell = spells[spell_index]
    if spell == nil then
        spell = spells['6'] 
    end
    nextindex = nil
    return spell.name
end