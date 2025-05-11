RSGCore = exports['rsg-core']:GetCoreObject()
local openTrapdoors = {}
Zones = {}

local trapdoorTimers = {}
Citizen.CreateThread(function()
    for object, config in pairs(Config.Trapdoors) do
        AssignModelEntity(config, false)
    end
end)

local function setTrapdoorPosition(modelName)
    local playerCoords = GetEntityCoords(PlayerPedId())
    local foundTrapdoorObject = 0

    foundTrapdoorObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 40.0,
        joaat(modelName), false,
        false, false)

    if DoesEntityExist(foundTrapdoorObject) and GlobalState.trapdoors[modelName] ~= nil and GlobalState.trapdoors[modelName] then
        local trapdoor = Config.Trapdoors[modelName]

        local currentPosition = LerpVector(trapdoor.closedPosition, trapdoor.openPosition, 1.0)
        local currentRotation = vector3(
            LerpAngle(math.rad(trapdoor.closedYaw.x), math.rad(trapdoor.openYaw.x), 1.0),
            LerpAngle(math.rad(trapdoor.closedYaw.y), math.rad(trapdoor.openYaw.y), 1.0),
            LerpAngle(math.rad(trapdoor.closedYaw.z), math.rad(trapdoor.openYaw.z), 1.0)
        )
        SetEntityCoords(foundTrapdoorObject, currentPosition.x, currentPosition.y, currentPosition.z, false, false, false, true)
        SetEntityRotation(foundTrapdoorObject, math.deg(currentRotation.x), math.deg(currentRotation.y),
            math.deg(currentRotation.z),
            2, true)

        openTrapdoors[modelName] = joaat(modelName)
    end
end

CreateThread(function()
    for modelname, zone in pairs(Config.TrapdoorZones) do
        Zones[modelname] = PolyZone:Create(zone.zones, {
            name = zone.name,
            minZ = zone.minz,
            maxZ = zone.maxz,
            debugPoly = false,
        })
        Zones[modelname]:onPlayerInOut(function(isPointInside)
            if isPointInside then
                setTrapdoorPosition(modelname)
            end
        end)
    end
end)


function LerpVector(a, b, t)
    return vector3(a.x + (b.x - a.x) * t, a.y + (b.y - a.y) * t, a.z + (b.z - a.z) * t)
end

function LerpQuaternion(a, b, t)
    local dot = a.x * b.x + a.y * b.y + a.z * b.z + a.w * b.w
    local blendI = 1.0 - t

    if dot < 0.0 then
        t = -t
    end

    local x = blendI * a.x + t * b.x
    local y = blendI * a.y + t * b.y
    local z = blendI * a.z + t * b.z
    local w = blendI * a.w + t * b.w
    local invLength = 1.0 / math.sqrt(x * x + y * y + z * z + w * w)

    return vector4(x * invLength, y * invLength, z * invLength, w * invLength)
end

function LerpAngle(a, b, t)
    local delta = math.fmod(b - a, 2 * math.pi)
    if delta > math.pi then
        delta = delta - 2 * math.pi
    elseif delta < -math.pi then
        delta = delta + 2 * math.pi
    end

    return a + delta * t
end

function setTimeout(callback, ms)
    local timer = {
        handle = nil,
        callback = callback
    }
    
    timer.handle = CreateThread(function()
        Wait(ms)
        if timer.callback then
            timer.callback()
        end
    end)
    
    return timer
end

function clearTimeout(timer)
    if timer and timer.handle then
        TerminateThread(timer.handle)
        timer.callback = nil
    end
end

function SmoothMoveObject(object, targetPosition, targetRotation, duration, config)
    local startPosition = GetEntityCoords(object)
    local startRotation = GetEntityRotation(object)
    local progress = 0.0
    
    
    
    RemoveTargetModel(config.objectName)
    
    
    if not DoesEntityExist(object) then
       
        return
    end

    
    SetEntityAsMissionEntity(object, true, true)

    while progress <= 1.0 do
        Citizen.Wait(0)
        progress = progress + (1.0 / (duration * 30.0))
        if progress > 1.0 then progress = 1.0 end
        
        local currentPosition = LerpVector(startPosition, targetPosition, progress)
        local currentRotation = vector3(
            LerpAngle(math.rad(startRotation.x), math.rad(targetRotation.x), progress),
            LerpAngle(math.rad(startRotation.y), math.rad(targetRotation.y), progress),
            LerpAngle(math.rad(startRotation.z), math.rad(targetRotation.z), progress)
        )
        
        if DoesEntityExist(object) then
            SetEntityCoords(object, currentPosition.x, currentPosition.y, currentPosition.z, false, false, false, true)
            SetEntityRotation(object, math.deg(currentRotation.x), math.deg(currentRotation.y), math.deg(currentRotation.z),
                2, true)
        else
            
            break
        end
    end

    
    
    if config.open then
       
        openTrapdoors[config.objectName] = object
    else
        
        openTrapdoors[config.objectName] = nil
    end
    
    
    local isTrackedAsOpen = (openTrapdoors[config.objectName] ~= nil)
   
    
    
    AssignModelEntity(config, false)
end

CreateThread(function()
    while true do
        Wait(3000) 
        
        
        RSGCore.Functions.TriggerCallback('movable_object:server:GetTrapdoorStates', function(states)
            if states then
                
                for modelName, isOpen in pairs(states) do
                    
                    local config = Config.Trapdoors[modelName]
                    if config then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local foundTrapdoorObject = GetClosestObjectOfType(
                            playerCoords.x, playerCoords.y, playerCoords.z, 
                            100.0, joaat(modelName), false, false, false
                        )
                        
                        
                        if isOpen then
                            if not openTrapdoors[modelName] and DoesEntityExist(foundTrapdoorObject) then
                                openTrapdoors[modelName] = foundTrapdoorObject
                                
                               
                                SetEntityCoords(foundTrapdoorObject, 
                                    config.openPosition.x, 
                                    config.openPosition.y, 
                                    config.openPosition.z, 
                                    false, false, false, true)
                                SetEntityRotation(foundTrapdoorObject, 
                                    config.openYaw.x, 
                                    config.openYaw.y, 
                                    config.openYaw.z, 
                                    2, true)
                                
                                
                                AssignModelEntity(config, false)
                            end
                        else
                            if openTrapdoors[modelName] then
                                openTrapdoors[modelName] = nil
                                
                                
                                if DoesEntityExist(foundTrapdoorObject) then
                                    SetEntityCoords(foundTrapdoorObject, 
                                        config.closedPosition.x, 
                                        config.closedPosition.y, 
                                        config.closedPosition.z, 
                                        false, false, false, true)
                                    SetEntityRotation(foundTrapdoorObject, 
                                        config.closedYaw.x, 
                                        config.closedYaw.y, 
                                        config.closedYaw.z, 
                                        2, true)
                                end
                                
                                
                                AssignModelEntity(config, false)
                            end
                        end
                    end
                end
            end
        end)
        
        Wait(3000)
    end
end)

function RemoveTargetModel(modelName)
   
    exports.ox_target:removeModel(joaat(modelName))
end

Citizen.CreateThread(function()
    
    Wait(1000)
    
    for object, config in pairs(Config.Trapdoors) do
        
        if GlobalState.trapdoors and GlobalState.trapdoors[object] then
            
            local playerCoords = GetEntityCoords(PlayerPedId())
            local foundObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 100.0,
                joaat(object), false, false, false)
                
            if DoesEntityExist(foundObject) then
                openTrapdoors[object] = foundObject
            end
        end
        
       
        AssignModelEntity(config, false)
    end
end)

function AssignModelEntity(config, inProgress)
    
    RemoveTargetModel(config.objectName)
    
    
    
    
    if not inProgress then
        local options = {}
        local isCurrentlyOpen = openTrapdoors[config.objectName] ~= nil
        
        
        if isCurrentlyOpen then
            
            
            options[#options+1] = {
                name = 'close_trapdoor_' .. config.objectName,
                icon = 'fas fa-hand',
                label = 'Close',
                onSelect = function()
                    
                    MoveTrapdoor(config.objectName, config)
                end,
                distance = config.interactRange or 2.0
            }
        else
            
            
            options[#options+1] = {
                name = 'open_trapdoor_' .. config.objectName,
                icon = 'fas fa-hand',
                label = 'Open',
                onSelect = function()
                   
                    MoveTrapdoor(config.objectName, config)
                end,
                distance = config.interactRange or 2.0
            }
        end
        
        exports.ox_target:addModel(joaat(config.objectName), options)
    end
end

function LoadAnimDict(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(0)
    end
end

function MoveTrapdoor(trapdoorObject, config)
    
    
    local playerCoords = GetEntityCoords(PlayerPedId())
    local foundTrapdoorObject = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 40.0,
        joaat(trapdoorObject), false, false, false)
    
    
    
    
    local trapdoorOpen = (openTrapdoors[trapdoorObject] ~= nil)
    
    
    
    
    if DoesEntityExist(foundTrapdoorObject) then
        local currentPos = GetEntityCoords(foundTrapdoorObject)
        local currentRot = GetEntityRotation(foundTrapdoorObject)
        
        
        
        local objectCoords = GetEntityCoords(foundTrapdoorObject)
        if Vdist(playerCoords, objectCoords) <= config.interactRange then
            local playerPed = PlayerPedId()

            LoadAnimDict("mech_cover@env@doors@unlocked@generic@base@push_return@bow@left@no_lean")

            TaskPlayAnim(playerPed, "mech_cover@env@doors@unlocked@generic@base@push_return@bow@left@no_lean", "open",
                8.0, -8.0, -1, 0, 0, false, false, false)

            local args = {
                open = trapdoorOpen,
                objectName = trapdoorObject,
                objectHash = foundTrapdoorObject,
                openPosition = config.openPosition,
                closedPosition = config.closedPosition,
                openYaw = config.openYaw,
                closedYaw = config.closedYaw,
                interactRange = config.interactRange
            }

           
            TriggerServerEvent('movable_object:toggleObject', args)
        else
           
        end
    else
        
    end
end

RegisterNetEvent('movable_object:setObjectPosition')
AddEventHandler('movable_object:setObjectPosition', function(args)
    local isOpen = args.open
    local newPosition = isOpen and args.openPosition or args.closedPosition
    local newYaw = isOpen and args.openYaw or args.closedYaw
    local duration = 10
    
    
    
  
    if DoesEntityExist(args.objectHash) then
        
        SmoothMoveObject(args.objectHash, newPosition, newYaw, duration, args)
    else
       
        local playerCoords = GetEntityCoords(PlayerPedId())
        local foundObject = GetClosestObjectOfType(
            playerCoords.x, playerCoords.y, playerCoords.z, 
            100.0, joaat(args.objectName), false, false, false
        )
        
        if DoesEntityExist(foundObject) then
            
            args.objectHash = foundObject
            SmoothMoveObject(foundObject, newPosition, newYaw, duration, args)
        else
            
        end
    end
end)