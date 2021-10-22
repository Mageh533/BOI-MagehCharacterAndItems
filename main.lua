local magehMoneys = RegisterMod("Mageh's Character and Items", 1)

magehMoneys.COLLECTIBLE_MONEY_POT = Isaac.GetItemIdByName("Money Pot")
magehMoneys.COLLECTIBLE_INVEST = Isaac.GetItemIdByName("Invest")
magehMoneys.COLLECTIBLE_DEBT = Isaac.GetItemIdByName("Debt")

-- I know global variables are bad but i cant be bothered to try another method

moneyDamage = false -- global variable to keep track of moneypot passive

local magehHair = Isaac.GetCostumeIdByPath("gfx/characters/magehHair.anm2")
local magehBHair = Isaac.GetCostumeIdByPath("gfx/characters/magehBHair.anm2")
local normalMageh = Isaac.GetPlayerTypeByName("Mageh")
local taintedMageh = Isaac.GetPlayerTypeByName("Mageh",true)
debt = 0
spawnCount = 0

local function IsPlayerMageh( player, includeNormal, includeTainted ) -- Thanks to the creator of mei i can tell the game how to apply hair for its tainted variant
	if includeNormal == nil then includeNormal = true end
	if includeTainted == nil then includeTainted = true end
	if player and ((player:GetPlayerType() == normalMageh and includeNormal) or player:GetPlayerType() == taintedMageh and includeTainted) then
		return true
	end
	return false
end

function magehMoneys:OnUpdate(player)
	-- If the player is mageh it will apply the hair
    debt = 0
	if player:GetName() == "Mageh" then
        if IsPlayerMageh( player, true, false ) then
		    player:AddNullCostume(magehHair)
		    costumeEquipped = true
            player:AddCollectible(magehMoneys.COLLECTIBLE_MONEY_POT)
            player:AddCollectible(magehMoneys.COLLECTIBLE_INVEST)
            player.Damage = player.Damage + 1
        elseif IsPlayerMageh( player, false, true ) then -- Apply different hair for its tainted variant
            player:AddNullCostume(magehBHair)
            player:SetPocketActiveItem(magehMoneys.COLLECTIBLE_DEBT)
		    costumeEquipped = true
        end
	end
end

magehMoneys:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, magehMoneys.OnUpdate)

function magehMoneys:onUseActive(_Type, RNG)
    --Invest Active Item code
    local player = Isaac.GetPlayer(0)
    birthRightPresent = false
    if player:HasCollectible(619) then
        birthRightPresent = true
    end
    if birthRightPresent == true and player:GetPlayerType() == normalMageh then
        player:AddCoins(-6)
    else
        player:AddCoins(-12)
    end
    local pos = player.Position -- Gets the player's position to know where to spawn the item
    drop = math.random(0,10) -- 50% chance nothing happens, 30% chance it drops a consumable, 20% chance it drops an item from the current pool
    if drop >= 8 then
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, 0,  pos, Vector(0,0), nil)
        SFXManager():Play(SoundEffect.SOUND_THUMBSUP)
     elseif drop < 8 and drop >= 5 then
        consumable = math.random(0,3)
        if consumable == 0 then
             Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, 0,  pos, Vector(0,0), nil) 
        elseif consumable == 1 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_KEY, 0,  pos, Vector(0,0), nil) 
        elseif consumable == 2 then
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_BOMB, 0,  pos, Vector(0,0), nil) 
        else
            Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TAROTCARD, 0,  pos, Vector(0,0), nil) 
        end               
        SFXManager():Play(SoundEffect.SOUND_THUMBSUP)                    
    else
        SFXManager():Play(SoundEffect.SOUND_THUMBS_DOWN)
    end
    inv = 0        
    return true -- Plays the active use animation
end

function magehMoneys:moneyPotDropPassive()
    --Money pot item code
    local player = Isaac.GetPlayer(0)
    local pos = player.Position
    local pos2 = Isaac.GetFreeNearPosition(pos, 10)
    if player:HasCollectible(magehMoneys.COLLECTIBLE_MONEY_POT) and moneyDamage == false then -- Checks if the player has the passive item and hasnt took damage for the current room, if so award 2 random coins
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,  pos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, 0,  pos2, Vector(0,0), nil)
    end
    moneyDamage = false -- resets it back to false for the next room
end

function magehMoneys:moneyPotCheckDamage()
    moneyDamage = true -- sets to true if player recieves damage
end

function magehMoneys:onPickUpCoin()
    local player = Isaac.GetPlayer(0)
    birthRightPresent = false
    if player:HasCollectible(619) then
        birthRightPresent = true
    end
    if player:HasCollectible(magehMoneys.COLLECTIBLE_INVEST) and (birthRightPresent == false or player:GetPlayerType() ~= normalMageh) then -- Automatically removes any coin from the player if the invest item isnt charged
        coins = player:GetNumCoins()
        if coins == 1 and (player:GetActiveCharge() < 12) then -- Please dont hate me, i am new at coding
            player:SetActiveCharge(1)
        elseif coins == 2 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(2)
        elseif coins == 3 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(3)
        elseif coins == 4 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(4)
        elseif coins == 5 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(5)
        elseif coins == 6 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(6)
        elseif coins == 7 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(7)
        elseif coins == 8 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(8)
        elseif coins == 9 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(9)
        elseif coins == 10 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(10)
        elseif coins == 11 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(11)
        elseif coins > 11 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(12)
        elseif coins == "" and (player:GetActiveCharge() < 12) then
            player:DischargeActiveItem()
        end
    elseif birthRightPresent == true and player:HasCollectible(magehMoneys.COLLECTIBLE_INVEST) and player:GetPlayerType() == normalMageh then -- Birthright effect halves the money needed, only works with normal mageh
        coins = player:GetNumCoins()
        if coins == 1 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(2)
        elseif coins == 2 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(4)
        elseif coins == 3 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(6)
        elseif coins == 4 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(8)
        elseif coins == 5 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(10)
        elseif coins > 5 and (player:GetActiveCharge() < 12) then
            player:SetActiveCharge(12)   
        elseif coins == "" and (player:GetActiveCharge() < 12) then
            player:DischargeActiveItem()     
        end
    end
end

function magehMoneys:onUseTaintedActive(_Type, RNG)
    --Debt Item code
    entities = Isaac.GetRoomEntities() -- Gets all entities in the room, if it finds an item it makes it pickable for free
    local player = Isaac.GetPlayer(0)
    playerPos = player.Position
    for i, entity in ipairs(entities) do
        if entity.Type == 5 then
            if entity:ToPickup().Price > 0 then
                debt = debt + entity:ToPickup().Price
                entity:ToPickup().Price = 0
                changeDebt = true
            end
        end
    end
    return true
end

function magehMoneys:OnEnterTreasureRoomAsTaintedMageh()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() == taintedMageh then
        currentRoom = Game():GetRoom():GetType()  
        if currentRoom == RoomType.ROOM_TREASURE then -- Item room
            entities = Isaac.GetRoomEntities()
            for i, entity in ipairs(entities) do
                if entity.Type == 5 and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then
                    entity:ToPickup().Price = 15
                end
            end
        end
    end
end

function magehMoneys:OnEnterDevilRoomAsTaintedMageh()
    local player = Isaac.GetPlayer(0)
    if player:GetPlayerType() == taintedMageh then
        currentRoom = Game():GetRoom():GetType() 
        if currentRoom == RoomType.ROOM_DEVIL then -- Devil room
            entities = Isaac.GetRoomEntities()
            for i, entity in ipairs(entities) do
                if entity.Type == 5 and entity.Variant == PickupVariant.PICKUP_COLLECTIBLE then -- Sala del demonio
                    if entity:ToPickup().Price == PickupPrice.PRICE_ONE_HEART then
                        entity:ToPickup().Price = 15
                    elseif entity:ToPickup().Price == PickupPrice.PRICE_TWO_HEARTS or entity:ToPickup().Price == PickupPrice.PRICE_THREE_SOULHEARTS then
                        entity:ToPickup().Price = 30
                    end
                end
            end
        end
    end
end
 
function magehMoneys:displayDebt()
    local player = Isaac.GetPlayer(0)
    local f = Font()
    local icon = Sprite()
    f:Load("font/pftempestasevencondensed.fnt")
    icon:Load("gfx/ui/debt.anm2", true)
    icon:SetFrame("Idle", 0)
    if player:HasCollectible(magehMoneys.COLLECTIBLE_DEBT) then -- Draws a sprite and text to show the player their debt
        f:DrawString(debt,450,213,KColor(1,1,1,1,0,0,0),0,true)
        icon:Render(Vector(427,212),Vector(0,0),Vector(0,0))
    end
end

function magehMoneys:debtSystem()
    local player = Isaac.GetPlayer(0)
    if player:GetNumCoins() > 0 and debt > 0 then
        player:AddCoins(-1)
        debt = debt - 1
        changeDebt = true
    end
    if player:HasCollectible(619) and player:GetPlayerType() == taintedMageh and changeDebt == true then -- Birthright halves your debt
        debt = debt / 2
        changeDebt = false
    end
end

function magehMoneys:onEnterNewRoomWithDebt() -- Code to spawn gapers when the player is in debt
    local playerDoor = Game():GetLevel().EnterDoor
    local doorFound = false
    local noDoorFound = 0 -- A Failsafe incase the player enters a room with only 1 door
    local enemySpawn = true
    local randomPos = 0
    spawnCount = spawnCount + 1
    while(doorFound == false) do
        checkDoorPos = Game():GetRoom():GetDoor(randomPos)
        if checkDoorPos ~= nil and randomPos ~= playerDoor then
            freePos = Game():GetRoom():GetDoorSlotPosition(randomPos)
            noDoorFound = 0
            doorFound = true
        else
            randomPos = randomPos + 1
            noDoorFound = noDoorFound + 1
        end
        if noDoorFound > 10 then -- If no valid door is found simply disables their spawns
            enemySpawn = false
            doorFound = true
        end
    end
    if debt >= 15 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 30 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 45 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 60 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED_GAPER, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 90 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 100 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED, 0, 0, freePos, Vector(0,0), nil)
        Isaac.Spawn(EntityType.ENTITY_GREED, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 130 and enemySpawn == true and spawnCount < 2 then
        Isaac.Spawn(EntityType.ENTITY_GREED, 0, 0, freePos, Vector(0,0), nil)
    end
    if debt >= 200 and enemySpawn == true then
        Isaac.Spawn(EntityType.ENTITY_ULTRA_GREED, 0, 0, Vector(320,280), Vector(0,0), nil)
    end
    if spawnCount > 2 then
        spawnCount = 0
    end
end

function ultraGreedKilled()
    debt = 0
end

magehMoneys:AddCallback(ModCallbacks.MC_USE_ITEM, magehMoneys.onUseActive, magehMoneys.COLLECTIBLE_INVEST)
magehMoneys:AddCallback(ModCallbacks.MC_USE_ITEM, magehMoneys.onUseTaintedActive, magehMoneys.COLLECTIBLE_DEBT)
magehMoneys:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, magehMoneys.moneyPotDropPassive)
magehMoneys:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, magehMoneys.moneyPotCheckDamage, EntityType.ENTITY_PLAYER)
magehMoneys:AddCallback(ModCallbacks.MC_POST_UPDATE, magehMoneys.onPickUpCoin)
magehMoneys:AddCallback(ModCallbacks.MC_POST_UPDATE, magehMoneys.debtSystem)
magehMoneys:AddCallback(ModCallbacks.MC_POST_RENDER, magehMoneys.displayDebt)
magehMoneys:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, magehMoneys.onEnterNewRoomWithDebt)
magehMoneys:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, magehMoneys.OnEnterDevilRoomAsTaintedMageh)
magehMoneys:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, magehMoneys.OnEnterTreasureRoomAsTaintedMageh)
magehMoneys:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, ultraGreedKilled, EntityType.ENTITY_ULTRA_GREED)

if EID then
    EID:addCollectible(magehMoneys.COLLECTIBLE_MONEY_POT, "Awards 2 random coins when clearing a room without taking damage", "Money Pot")
    EID:addCollectible(magehMoneys.COLLECTIBLE_INVEST, "When holding one coin it will add 1 charge to it with a maximum of 12#When fully charged and used it will take away 12 coins and it can do one of the following:#50% Chance nothing happens#30% Chance it drops a bomb, key, heart or tarot card#20% chance it spawns a pedestal item from the current item pool", "Invest")
    EID:addCollectible(magehMoneys.COLLECTIBLE_MONEY_POT, "Suelta 2 monedas aleatorias cuando limpias una sala sin recibir daño", "Money Pot", "spa")
    EID:addCollectible(magehMoneys.COLLECTIBLE_INVEST, "Tener monedas carga el activo dependiendo de las monedas que tengas con un maximo de 12 cargas#Cuando este cargado al maximo puede pasar lo siguiente:#50% de probabilidad que pase nada#30% de probabilidad que suelte una bomba, llave, corazon o carta#20% de probabilidad que te de un objeto de la pool de la sala actual", "Invest", "spa")
end