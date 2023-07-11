pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

readybit = 0

pl = {
    world_x=0,
    world_y=0,
    world_h=16,
    world_w=11,
    world_xflip=false,
    battle_x=0,
    battle_y=0,
    battle_h=16,
    battle_w=11,
    battle_xflip=false,
    ani_state='stand',
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

frames = {
    ['front'] = {0, 0, 11, 16},
    ['frontstep'] = {12, 0, 11, 16}
}

cycles = {
    ['walk'] = {
        {'front', 8},
        {'frontstep', 8},
        {'front', 8},
        {'frontstep', 8},
        {'front', 8},
        {'frontstep', 8},
        {'front', 8},
        {'frontstep', 8},
        {'front', 8},
        {'frontstep', 8},

    }
}

function anim_cycle()
    i = flr(rnd(2)+1)
    local frame = cycles['walk'][i][1]
    --cycles['walk'][1][2] -= 1
    --if cycles['walk'][1][2] == 0 then
        --deli(cycles['walk'][1])
    --end
    animate_player(frame)
end

function animate_player(f)
    local c = frames[f]
    sspr(c[1], c[2], c[3], c[4], pl.world_x, pl.world_y, pl.world_w, pl.world_h, pl.world_xflip, false)
    sspr(0, 0, 11, 16, pl.world_x+16, pl.world_y+16, pl.world_w, pl.world_h, pl.world_xflip, false)
end

function world_p_update()
    world_p_move()
end

function world_p_draw()
    --animate_player('front')
    anim_cycle()
    print_centered('test', 60, 60, 7)
end

function world_p_move()
    local spd = 0.5
    local dx, dy = direction_control()
    if dx != 0 and dy != 0 then
        dx = 0
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
    spells['60'] = {name = 'rock toss', cat = 'm', power = 30}
    spells['61'] = {name = 'wind burst', cat = 'm', power = 30}
    spells['62'] = {name = 'fire embers', cat = 'm', power = 30}
    spells['63'] = {name = 'water spout', cat = 'm', power = 30}
    spells['600'] = {name = 'rock throw', cat = 'm', power = 30}
    spells['611'] = {name = 'wind blast', cat = 'm', power = 30}
    spells['622'] = {name = 'fire blaze', cat = 'm', power = 30}
    spells['633'] = {name = 'water geyser', cat = 'm', power = 30}
    
spell_index = '6'

function spell_control()
    local ix, iy = direction_control()
    local out
    if ix == 0 and iy == 0 then
        readybit = 1
    end
    if readybit == 1 then      
        if btnp(0) then nextindex, readybit = '0', 0 end
        if btnp(1) then nextindex, readybit = '1', 0 end
        if btnp(2) then nextindex, readybit = '2', 0 end
        if btnp(3) then nextindex, readybit = '3', 0 end
        if z_btn.is_pressed then nextindex, readybit = 'back', 0 end
    end
    if nextindex != nil and nextindex != 'back' then
        if #spell_index < 4 then
            spell_index = spell_index..nextindex
        end
    end
    if nextindex == 'back' and spell_index != '6' then
        spell_index = sub(spell_index, 1, -2)
    end  
    
    local spell = spells[spell_index]
    if spell == nil then
        spell = spells['6'] 
    end

    nextindex = nil
    return spell
end

function current_spell()
    if spells[spell_index] != nil then
        return spells[spell_index]
    end
    local unknown = {name= '???'}
    return unknown
end

function spell_n_earth()
    if spells[spell_index..'0'] != nil then
        return spells[spell_index..'0']
    end
    local unknown = {name= '???'}
    return unknown
end

function spell_n_air()
    if spells[spell_index..'1'] != nil then
        return spells[spell_index..'1']
    end
    local unknown = {name= '???'}
    return unknown
end

function spell_n_fire()
    if spells[spell_index..'2'] != nil then
        return spells[spell_index..'2']
    end
    local unknown = {name= '???'}
    return unknown
end

function spell_n_water()
    if spells[spell_index..'3'] != nil then
        return spells[spell_index..'3']
    end
    local unknown = {name= '???'}
    return unknown
end