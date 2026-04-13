-- MainV3 Utility Functions
local Utils = {}

-- Get all players in game
function Utils:GetPlayers()
    return game:GetService("Players"):GetPlayers()
end

-- Get player character
function Utils:GetCharacter(player)
    return player.Character or player.CharacterAdded:Wait()
end

-- Get humanoid from character
function Utils:GetHumanoid(character)
    return character:FindFirstChild("Humanoid")
end

-- Check if player is alive
function Utils:IsAlive(player)
    local character = player.Character
    if not character then return false end
    local humanoid = self:GetHumanoid(character)
    return humanoid and humanoid.Health > 0
end

-- Get player head position
function Utils:GetHeadPosition(player)
    local character = self:GetCharacter(player)
    local head = character:FindFirstChild("Head")
    return head and head.Position or character.PrimaryPart.Position
end

-- Check if two players are on same team
function Utils:IsSameTeam(player1, player2)
    return player1.Team == player2.Team
end

-- Distance between two vectors
function Utils:Distance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

-- Raycast to check if line of sight is clear
function Utils:HasLineOfSight(fromPos, toPos)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
    
    local result = workspace:Raycast(fromPos, (toPos - fromPos).Unit * 1000, raycastParams)
    return not result or result.Instance:IsDescendantOf(game.Players.LocalPlayer.Character)
end

-- Get closest player to local player
function Utils:GetClosestPlayer()
    local players = self:GetPlayers()
    local localPlayer = game.Players.LocalPlayer
    local closest = nil
    local closestDistance = math.huge
    
    for _, player in pairs(players) do
        if player ~= localPlayer and self:IsAlive(player) then
            local distance = self:Distance(localPlayer.Character.PrimaryPart.Position, self:GetHeadPosition(player))
            if distance < closestDistance then
                closestDistance = distance
                closest = player
            end
        end
    end
    
    return closest, closestDistance
end

-- Print debug message
function Utils:Debug(message)
    print("[MainV3-Debug] " .. tostring(message))
end

return Utils
