pico-8 cartridge // http://www.pico-8.com
version 39
__lua__

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

spells = {
    {id = '6', name = 'strike', cat = 'p', power = 30},
    {id = '0', name = 'rock throw', cat = 'm', power = 30},
    {id = '1', name = 'wind cutter', cat = 'p', power = 30},
    {id = '2', name = 'fireball', cat = 'p', power = 30},
    {id = '3', name = 'water pillar', cat = 'p', power = 30}
}
