ESX = nil

local bendingMachines = {-654402915}
local openedVendingMachine = false
local distX, distY, distZ = 0,0,0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if not openedVendingMachine then
            local ped = GetPlayerPed(-1)
            local pos = GetEntityCoords(ped)

            for i = 1, #bendingMachines do
                local bendingMachine = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, bendingMachines[i], false, false, false)
                local bendingMachinesPos = GetEntityCoords(bendingMachine)
                local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, bendingMachinesPos.x, bendingMachinesPos.y, bendingMachinesPos.z, true)


                if dist < 1.8 then
                    local loc = vector3(bendingMachinesPos.x, bendingMachinesPos.y, bendingMachinesPos.z)
                    
                    ESX.Game.Utils.DrawText3D(loc, Config.DrawText3D, 0.7)
                    if IsControlJustReleased(0, Config.PressedKey) then
                        distX, distY, distZ = bendingMachinesPos.x, bendingMachinesPos.y, bendingMachinesPos.z 
                    
                        VendingMachineMenu()
                        openedVendingMachine = true
                    end
                else
                    Citizen.Wait(1500)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)

        if openedVendingMachine then
            local ped = PlayerPedId()
            local pos = GetEntityCoords(ped)

            local dist = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, distX, distY, distZ, true)

            if dist > 1.8 and openedVendingMachine then
                openedVendingMachine = false
                ESX.UI.Menu.CloseAll()
            end
        end
    end
end)

VendingMachineMenu = function()

    openedVendingMachine = true

	local elements = {}
    
    for k,v in pairs(Config.candybox) do
		table.insert(elements,{label = v.label .. ' | <font color=red>'..Config.PaymentSymbol..v.price..' - ('..v.keyValue..')</font>', value = v.value, price = v.price})
    end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "esx_tgo_vendingmachines_main_menu",
	{
		title    = Config.CandyBoxTitle,
		align    = Config.TitleAlign,
		elements = elements
	},
	function(data, menu)
        TriggerServerEvent("esx_tgo_vendingmachines:buyVendingItem",data.current.price,data.current.value)

	end, function(data, menu)
        menu.close()
        openedVendingMachine = false
	end, function(data, menu)
	end)
end

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		if openedVendingMachine then
			ESX.UI.Menu.CloseAll()
		end
	end
end)

AddEventHandler('esx:onPlayerDeath', function()
	openedVendingMachine = false
end)
