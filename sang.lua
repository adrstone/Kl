repeat task.wait() until game:IsLoaded()
repeat task.wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
getgenv().Key = "leminhsang123"  -- Đây là key của người dùng
-- Danh sách các key và HWID đã gán
local keyHWIDMapping = {
    ["leminhsang123"] = nil,
    ["trantrongkim123"] = nil,
    ["19072011"] = nil
}

-- Lấy HWID của người dùng
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local userKey = getgenv().Key or ""

-- Kiểm tra key có tồn tại
if keyHWIDMapping[userKey] then
    if keyHWIDMapping[userKey] == hwid then
        print("Key hợp lệ! HWID trùng khớp.")
        -- Thực thi script tại đây
    else
        game.Players.LocalPlayer:Kick("Key này đã được dùng trên thiết bị khác.")
    end
elseif keyHWIDMapping[userKey] == nil then
    -- Gán HWID mới cho key chưa từng dùng
    keyHWIDMapping[userKey] = hwid
    print("Key mới được gán cho thiết bị này. Script sẽ chạy.")
    -- Thực thi script tại đây
else
    game.Players.LocalPlayer:Kick("Key không hợp lệ.")
end
 
local furina = loadstring(Game:HttpGet("https://raw.githubusercontent.com/adrstone/furina/refs/heads/main/furina.lua", true))()

local Window = Fluent:CreateWindow({
    Title = "Sanghub",
    SubTitle = "By ms",
    TabWidth = 160,
    Size = UDim2.fromOffset(500, 350),
    Acrylic = false,
    Theme = "Dark",
    Center = true,
    IsDraggable = true
})

local Tab = Window:AddTab({ Title = "Main", Icon = "home" })

Tab:AddButton({
    Title = "men men",
    Description = "redeem alll code",
    Callback = function()
        local codes = {
    "WOW850",
    "860KHYPEE",
    "870OMG!",
    "LOLX880K!",
    "IAMLEOPARD",
    "BIGUPDATE20",
    "ANTICIPATION",
    "BIGDAY",
    "MAGNIFICENT890K!!",
    "OMG9HUNDRED!",
    "WOWZER910",
    "HYPEE920K!"
}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Replicator = ReplicatedStorage:WaitForChild("Replicator") -- Đảm bảo tên đúng

for _, code in ipairs(codes) do
    local args = {
        [1] = "Codes",
        [2] = "Redeem",
        [3] = {
            ["Code"] = code
        }
    }

    local result
    pcall(function()
        result = Replicator:InvokeServer(unpack(args))
    end)

    print("Đã thử code:", code, "=> Kết quả:", result)
    wait(1) -- tránh spam quá nhanh
end
    end
})

-- Biến điều khiển
_G.autoSkill = false
_G.autoTeleport = false

local autoSkillThread
local autoTeleportThread

-- Biến điều khiển toàn cục
_G.autoSkill = false
_G.autoTeleport = false
_G.autoFollowMarco = false

local autoSkillThread
local autoTeleportThread
local autoFollowThread

-- Toggle 1: Auto Skill
local SkillToggle = Tab:AddToggle("SkillToggle", {
    Title = "Auto Skill Rumble",
    Description = "Tự động sử dụng kỹ năng",
    Default = false,
    Callback = function(state)
        _G.autoSkill = state

        if state then
            autoSkillThread = task.spawn(function()
                local skills = {
                     "VoltageUp",
                    "LightningPalm",
                    "CrashingThunder",
                    "ProjectedBurst",
                    "CrushingJudgment",
                    "Raigo"
                }

                while _G.autoSkill do
                    for _, skill in ipairs(skills) do
                        if not _G.autoSkill then break end
                        local args = {
                            [1] = "Lightning",
                            [2] = skill,
                            [3] = {}
                        }
                        game:GetService("ReplicatedStorage"):WaitForChild("ReplicatorNoYield"):FireServer(unpack(args))
                        wait(0.1)
                    end
                end
            end)
        else
            if autoSkillThread then task.cancel(autoSkillThread) end
        end
    end
})

-- Toggle 2: Auto Teleport
local TeleportToggle = Tab:AddToggle("TeleportToggle", {
    Title = "Auto Teleport",
    Description = "Dịch chuyển về vị trí sau mỗi 18 giây",
    Default = false,
    Callback = function(state)
        _G.autoTeleport = state

        if state then
            autoTeleportThread = task.spawn(function()
                local player = game.Players.LocalPlayer

                while _G.autoTeleport do
                    local character = player.Character or player.CharacterAdded:Wait()
                    local hrp = character:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = CFrame.new(-1420, 798.9317626953125, -85.00000762939453)
                    wait(18)
                end
            end)
        else
            if autoTeleportThread then task.cancel(autoTeleportThread) end
        end
    end
})

-- Toggle 3: Auto Follow Marco
local function followMarco(marco)
    local marcoHRP = marco:FindFirstChild("HumanoidRootPart")
    local humanoid = marco:FindFirstChild("Humanoid")
    if not marcoHRP or not humanoid then return end

    -- Dịch chuyển ban đầu
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = marcoHRP.CFrame + Vector3.new(0, 5, 0)

    autoFollowThread = task.spawn(function()
        while _G.autoFollowMarco and humanoid.Health > 0 do
            local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = marcoHRP.CFrame + Vector3.new(0, 5, 0)
            end
            wait(0.1)
        end
    end)
end

local function listenForMarco()
    local NPCsFolder = workspace:WaitForChild("Characters"):WaitForChild("NPCs")

    NPCsFolder.ChildAdded:Connect(function(child)
        if child.Name == "Marco" and _G.autoFollowMarco then
            followMarco(child)
        end
    end)

    local marco = NPCsFolder:FindFirstChild("Marco")
    if marco and _G.autoFollowMarco then
        task.delay(1, function()
            followMarco(marco)
        end)
    end
end

local MarcoToggle = Tab:AddToggle("MarcoToggle", {
    Title = "Auto Follow Marco",
    Description = "Tự động đi theo NPC Marco khi xuất hiện",
    Default = false,
    Callback = function(state)
        _G.autoFollowMarco = state

        if state then
            listenForMarco()
        else
            if autoFollowThread then task.cancel(autoFollowThread) end
        end
    end
})