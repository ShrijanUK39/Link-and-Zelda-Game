PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.player = Player {
        animations = ENTITY_DEFS['player'].animations,
        walkSpeed = ENTITY_DEFS['player'].walkSpeed,
        hitbox = ENTITY_DEFS['player'].hitbox,
        hurtbox = ENTITY_DEFS['player'].hurtbox,

        x = PLAYER_START_X,
        y = PLAYER_START_Y,

        width = 16,
        height = 22,

       
        health = PLAYER_MAX_HEALTH,
        offsetY = 5
    }

    self.dungeon = Dungeon(self.player)
    self.currentRoom = self.dungeon.currentRoom

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player, self.dungeon) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['swing-sword'] = function() return PlayerSwingSwordState(self.player, self.dungeon) end,
        ['damage'] = function() return PlayerDamageState(self.player) end,
        ['lift'] = function() return PlayerLiftState(self.player) end,
        ['throw'] = function() return PlayerThrowState(self.player) end
    }
    self.player:changeState('idle')
end

function PlayState:enter(params)

end

function PlayState:update(dt)
    if love.keyboard.wasPressed('escape') then
     love.event.quit()
    end

    self.dungeon:update(dt)
end

function PlayState:render()
   
    love.graphics.push()
    self.dungeon:render()
    love.graphics.pop()

   
    local healthLeft = self.player.health
    local heartFrame = 1

    for i = 1, 3 do
        if healthLeft > 1 then
            heartFrame = 5
        elseif healthLeft == 1 then
            heartFrame = 3
        else
            heartFrame = 1
        end

        love.graphics.draw(gTextures['hearts'], gFrames['hearts'][heartFrame],
            (i - 1) * (TILE_SIZE + 1), 2)

        healthLeft = healthLeft - 2
    end
end
