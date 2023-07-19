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
    earth=0,
    water=0,
    wind=0,
    fire=0,
    patk=10,
    matk=10,
    hp=30,
    mp=30,
    def=10,
    agi=10,
    ani_state='',
    ani_next='',
    ani_frame=1,
    ani_cycle={}
}

frames = {
    ['ustepright1'] = {0, 0, 11, 16, false},
    ['ustepright2'] = {12, 0, 11, 16, false},
    ['ustepleft1'] = {0, 0, 11, 16, true},
    ['ustepleft2'] = {12, 0, 11, 16, true},
    ['dstepright1'] = {24, 0, 11, 16, false},
    ['dstepright2'] = {36, 0, 11, 16, false},
    ['dstepleft1'] = {24, 0, 11, 16, true},
    ['dstepleft2'] = {36, 0, 11, 16, true},
    ['lstep1'] = {47, 0, 9, 16, false},
    ['lstep2'] = {57, 0, 9, 16, false},
    ['lstep3'] = {67, 0, 9, 16, false},
    ['rstep1'] = {48, 0, 8, 16, true},
    ['rstep2'] = {57, 0, 9, 16, true},
    ['rstep3'] = {67, 0, 9, 16, true},
    ['idle1'] = {0, 0, 11, 16, false},
    ['idle2'] = {77, 0, 11, 16, false}
}

cycles = {
    ['uwalk'] = {
        {'ustepright2', 16},
        {'ustepright1', 12},
        {'ustepleft2', 16},
        {'ustepleft1', 12}
    },
    ['dwalk'] = {
        {'dstepright2', 16},
        {'dstepright1', 12},
        {'dstepleft2', 16},
        {'dstepleft1', 12}
    },
    ['lwalk'] = {
        {'lstep2', 16},
        {'lstep1', 12},
        {'lstep3', 16},
        {'lstep1', 12}
    },
    ['rwalk'] = {
        {'rstep2', 16},
        {'rstep1', 12},
        {'rstep3', 16},
        {'rstep1', 12}
    },
    ['idle'] = {
        {'idle1', 30},
        {'idle2', 16}
    }
}

function init_ani_cycle()
    pl.ani_state = 'idle'
    for i = 1, #cycles['idle'] do
        len = cycles['idle'][i][2]
        for j = 1, len do
            add(pl.ani_cycle, tostr(cycles['idle'][i][1]))
        end
    end
end

function set_ani_cycle(cycle)
    if pl.ani_state != cycle then
        pl.ani_cycle = {}
        pl.ani_frame = 1
        pl.ani_state = cycle
        for i = 1, #cycles[cycle] do
            len = cycles[cycle][i][2]
            for j = 1, len do
                add(pl.ani_cycle, tostr(cycles[cycle][i][1]))
            end
        end
    end
end

function animate_player()
    local c = frames[pl.ani_cycle[pl.ani_frame]]
    sspr(c[1], c[2], c[3], c[4], pl.world_x, pl.world_y, c[3], c[4], c[5], false)
    pl.ani_frame+=1
    if pl.ani_frame >= #pl.ani_cycle then pl.ani_frame = 1 end
end

function world_p_update()
    world_p_move()
    set_ani_cycle(pl.ani_next)
end

function world_p_draw()
    animate_player()
    print_centered(tostr(pl.ani_frame), 60, 60, 7)
    print_centered(tostr(#pl.ani_cycle), 60, 68, 7)

end

function world_p_move()
    local spd = 0.45
    local dx, dy = direction_control()
    if dx != 0 and dy != 0 then
        dx = 0
    end
    pl.world_x += dx * spd
    pl.world_y += dy * spd
    if dx == -1 then pl.ani_next = 'lwalk' end
    if dx == 1 then pl.ani_next = 'rwalk' end
    if dy == -1 then pl.ani_next = 'dwalk' end
    if dy == 1 then pl.ani_next = 'uwalk' end
    if dx == 0 and dy == 0 then pl.ani_next = 'idle' end
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