local RSGCore = exports['rsg-core']:GetCoreObject()

GlobalState.trapdoors = {}

local function updateTrapdoorState(modelName, state)
    local trapdoors = GlobalState.trapdoors
    trapdoors[modelName] = state
    GlobalState.trapdoors = trapdoors
end

RegisterServerEvent('movable_object:toggleObject')
AddEventHandler('movable_object:toggleObject', function(args)
    args.open = not args.open
    updateTrapdoorState(args.objectName, args.open)
    TriggerClientEvent('movable_object:setObjectPosition', -1, args)
end)

RSGCore.Functions.CreateCallback('movable_object:server:GetTrapdoorStates', function(source, cb)
    cb(GlobalState.trapdoors)
end)