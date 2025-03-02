love.graphics.setDefaultFilter("nearest", "nearest")
local Player = require("player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")
local Stone = require("stone")
local Camera = require("camera")
local Enemy = require("enemy")
local Map = require("map")

-- Declare cameraPosition outside of any function (but it will be assigned in love.update)
cameraPosition = 0

function love.load()
    Enemy.loadAssets()
    Map:load()
    background = love.graphics.newImage("assets/background.png")
    GUI:load()
    Player:load()
end


function love.update(dt)
    World:update(dt)
    Player:update(dt)
    Coin.updateAll(dt)
    Spike.updateAll(dt)
    Stone.updateAll(dt)
    Enemy.updateAll(dt)
    GUI:update(dt)

    Map:update(dt)  -- Important: Update the map *before* checking the level

    -- Check the map level and set cameraPosition *every frame*
    if Map.currentLevel == 2 then
        cameraPosition = 740
    else
        cameraPosition = 0
    end

    Camera:setPosition(Player.x, cameraPosition) -- Use the updated cameraPosition
end

function love.draw()
    -- Get screen dimensions
    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    -- Get background dimensions
    local bgWidth = background:getWidth()
    local bgHeight = background:getHeight()

    -- Calculate scaling factors
    local scaleX = screenWidth / bgWidth
    local scaleY = screenHeight / bgHeight

    -- Draw the background scaled to fit the screen
    love.graphics.draw(background, 0, 0, 0, scaleX, scaleY)

    -- Draw the map and other game elements
    Map.level:draw(-Camera.x, -Camera.y, Camera.scale, Camera.scale)
    Camera:apply()
    Player:draw()
    Enemy.drawAll()
    Coin.drawAll()
    Spike.drawAll()
    Stone.drawAll()
    Camera:clear()
    GUI:draw()
end

function love.keypressed(key)
    Player:jump(key)
end

function beginContact(a, b, collision)
    if Coin.beginContact(a, b, collision) then return end
    if Spike.beginContact(a, b, collision) then return end
    Enemy.beginContact(a, b, collision)
    Player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
    Player:endContact(a, b, collision)
end