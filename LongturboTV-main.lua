--====================================================--
-- CẤU HÌNH BẢO MẬT VÀ LƯU KEY
--====================================================--
local GITHUB_RAW_URL = "https://raw.githubusercontent.com/longPD214/PDlong/refs/heads/main/Key-longturbohub.key" 
local GITHUB_GET_KEY_URL = "https://raw.githubusercontent.com/longPD214/PDlong/refs/heads/main/Key-longturbohub.key" 
local FILE_NAME = "longturbo_key_data.json"
local EXPIRE_TIME = 86400 -- 24 tiếng

local MY_SECRET_KEY = "longturbo-12345678910-2014"
pcall(function()
    local downloadedKey = game:HttpGet(GITHUB_RAW_URL):gsub("%s+", "")
    if downloadedKey and downloadedKey ~= "" then
        MY_SECRET_KEY = downloadedKey
    end
end)

local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local function SaveKeyData(key)
    if writefile then
        writefile(FILE_NAME, HttpService:JSONEncode({Key = key, Time = os.time()}))
    end
end

local function CheckSavedKey()
    if isfile and isfile(FILE_NAME) then
        local success, result = pcall(function()
            return HttpService:JSONDecode(readfile(FILE_NAME))
        end)
        if success and result and result.Key and result.Time then
            if (os.time() - result.Time) < EXPIRE_TIME and result.Key == MY_SECRET_KEY then
                return true
            else
                if delfile then delfile(FILE_NAME) end
            end
        end
    end
    return false
end

--====================================================--
-- TẠO SCRIPT CHÍNH (SỬ DỤNG COMPKILLER UI LIBRARY)
--====================================================--
local function InitMainHub()
    -- Anti-AFK
    task.spawn(function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end)

    -- Fast Attack (CheemBanana Logic)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-Meoz/LuaCyder-Meoz/refs/heads/main/BF-CheemBanana.lua"))()
        end)
    end)

    -- Tải CompKiller UI Library
    local CompKillerLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Swiftz/UI-Library/refs/heads/main/Libraries/CompKiller%20-%20Example.lua"))()
    local Window = CompKillerLib:CreateWindow("longturboTV Hub | Blox Fruits (Update 30)")

    -- BIẾN TOÀN CỤC BẢO TOÀN TRẠNG THÁI
    _G.AutoFarmLevel = false
    _G.AutoQuest = true
    _G.AutoFarmBone = false
    _G.AutoRandomBone = false
    _G.AutoFarmMaterial = false
    _G.SelectedMaterial = "Bones"
    _G.AutoCakePrince = false
    _G.AutoDoughKing = false
    _G.AutoSea1ToSea2 = false
    _G.AutoSea2ToSea3 = false
    _G.TweenSpeed = 190

    -- DANH SÁCH DỮ LIỆU MATERIAL
    local MaterialMobs = {
        ["Bones"] = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Possessed Mummy"},
        ["Conjured Cocoa"] = {"Cocoa Warrior", "Chocolate Bar Battler"},
        ["Dragon Scale"] = {"Dragon Crew Archer", "Dragon Crew Warrior"},
        ["Fish Tail"] = {"Fishman Warrior", "Fishman Commando", "Fishman Raider", "Fishman Captain"},
        ["Angel Wings"] = {"God's Guard", "Shanda", "Royal Squad"},
        ["Magma Ore"] = {"Military Soldier", "Military Spy", "Magma Ninja"},
        ["Leather"] = {"Pirate", "Brute"},
        ["Gunpowder"] = {"Pistol Billionaire", "Mercenary"}
    }

    -- HÀM BAY TWEEN AN TOÀN
    local function TweenTo(cframe)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local dist = (char.HumanoidRootPart.Position - cframe.Position).Magnitude
            local info = TweenInfo.new(dist / math.max(_G.TweenSpeed, 10), Enum.EasingStyle.Linear)
            local tween = TweenService:Create(char.HumanoidRootPart, info, {CFrame = cframe})
            tween:Play()
            return tween
        end
    end

    -- LOGIC MAGNET QUÁI (GOM QUÁI UPDATE 30)
    local function MagnetEnemies(targetPos, mobNames)
        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                local isTarget = false
                if type(mobNames) == "table" then
                    for _, name in ipairs(mobNames) do
                        if string.find(enemy.Name, name) then isTarget = true; break end
                    end
                elseif type(mobNames) == "string" and string.find(enemy.Name, mobNames) then
                    isTarget = true
                end

                if isTarget and (enemy.HumanoidRootPart.Position - targetPos).Magnitude <= 350 then
                    enemy.HumanoidRootPart.CFrame = CFrame.new(targetPos)
                    enemy.HumanoidRootPart.CanCollide = false
                    enemy.Humanoid.WalkSpeed = 0
                end
            end
        end
    end

    -- DATA AUTO FARM LEVEL CHUẨN UPDATE 30 (MAX LEVEL 2800)
    local function GetQuestData()
        local level = 1
        pcall(function() level = LocalPlayer.Data.Level.Value end)
        
        -- SEA 1
        if level >= 1 and level < 10 then
            return "BanditQuest1", 1, "Bandit", CFrame.new(1059, 16, 1549), CFrame.new(1145, 16, 1634)
        elseif level >= 10 and level < 15 then
            return "JungleQuest", 1, "Monkey", CFrame.new(-1598, 36, 153), CFrame.new(-1623, 21, 142)
        elseif level >= 15 and level < 30 then
            return "JungleQuest", 2, "Gorilla", CFrame.new(-1598, 36, 153), CFrame.new(-1237, 6, -486)
        elseif level >= 30 and level < 40 then
            return "BuggyQuest1", 1, "Pirate", CFrame.new(-1141, 4, 3856), CFrame.new(-1205, 4, 3915)
        elseif level >= 40 and level < 60 then
            return "BuggyQuest1", 2, "Brute", CFrame.new(-1141, 4, 3856), CFrame.new(-1140, 14, 4320)
        elseif level >= 60 and level < 90 then
            return "DesertQuest", 1, "Desert Bandit", CFrame.new(894, 6, 4388), CFrame.new(992, 6, 4441)
        elseif level >= 90 and level < 120 then
            return "SnowQuest", 1, "Snow Bandit", CFrame.new(1385, 87, -1298), CFrame.new(1287, 105, -1429)
        elseif level >= 120 and level < 150 then
            return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-5039, 28, 4324), CFrame.new(-4880, 22, 4260)
        elseif level >= 150 and level < 190 then
            return "SkyQuest", 1, "Sky Bandit", CFrame.new(-4839, 717, -2619), CFrame.new(-4972, 720, -2875)
        elseif level >= 190 and level < 250 then
            return "PrisonerQuest", 1, "Prisoner", CFrame.new(5308, 1, 474), CFrame.new(5340, 1, 474)
        elseif level >= 250 and level < 300 then
            return "ColosseumQuest", 1, "Toga Warrior", CFrame.new(-1588, 7, -2982), CFrame.new(-1800, 50, -2700)
        elseif level >= 300 and level < 375 then
            return "MagmaQuest", 1, "Military Soldier", CFrame.new(-5315, 12, 8515), CFrame.new(-5400, 11, 8500)
        elseif level >= 375 and level < 450 then
            return "FishmanQuest", 1, "Fishman Warrior", CFrame.new(61122, 18, 1569), CFrame.new(60800, 18, 1500)
        elseif level >= 450 and level < 625 then
            return "SkyQuest2", 1, "God's Guard", CFrame.new(-7860, 5545, -380), CFrame.new(-7700, 5560, -400)
        elseif level >= 625 and level < 700 then
            return "FountainQuest", 1, "Galley Pirate", CFrame.new(5259, 38, 4050), CFrame.new(5500, 38, 4000)

        -- SEA 2
        elseif level >= 700 and level < 775 then
            return "Area1Quest", 1, "Raider", CFrame.new(-425, 73, 1837), CFrame.new(-800, 80, 1600)
        elseif level >= 775 and level < 875 then
            return "Area1Quest", 2, "Mercenary", CFrame.new(-425, 73, 1837), CFrame.new(-900, 80, 1400)
        elseif level >= 875 and level < 1000 then
            return "Area2Quest", 1, "Swan Pirate", CFrame.new(638, 73, 918), CFrame.new(800, 100, 1100)
        elseif level >= 1000 and level < 1100 then
            return "FactoryQuest", 1, "Factory Staff", CFrame.new(295, 73, -56), CFrame.new(100, 73, -100)
        elseif level >= 1100 and level < 1250 then
            return "ShipQuest1", 1, "Ship Officer", CFrame.new(-502, 14, -3172), CFrame.new(-700, 14, -3200)
        elseif level >= 1250 and level < 1350 then
            return "FrostQuest", 1, "Snow Trooper", CFrame.new(5660, 28, -6480), CFrame.new(5800, 28, -6300)
        elseif level >= 1350 and level < 1425 then
            return "IceFireQuest", 1, "Magma Ninja", CFrame.new(-5920, 15, -5150), CFrame.new(-5800, 15, -5300)
        elseif level >= 1425 and level < 1500 then
            return "IceFireQuest", 2, "Lava Pirate", CFrame.new(-5920, 15, -5150), CFrame.new(-5200, 15, -5100)

        -- SEA 3 & UPDATE 30 (SUBMERGED ISLAND)
        elseif level >= 1500 and level < 1575 then
            return "PiratePortQuest", 1, "Pirate Millionaire", CFrame.new(-290, 44, 5580), CFrame.new(-350, 44, 5400)
        elseif level >= 1575 and level < 1700 then
            return "AmazonQuest", 1, "Pistol Billionaire", CFrame.new(5833, 52, -1105), CFrame.new(5400, 60, -1000)
        elseif level >= 1700 and level < 1825 then
            return "MarineTreeQuest", 1, "Marine Commodore", CFrame.new(2180, 29, -6740), CFrame.new(2400, 29, -6800)
        elseif level >= 1825 and level < 1975 then
            return "DeepForestIslandQuest", 1, "Jungle Pirate", CFrame.new(-13230, 332, -7625), CFrame.new(-13400, 332, -7800)
        elseif level >= 1975 and level < 2075 then
            return "HauntedQuest1", 1, "Reborn Skeleton", CFrame.new(-9480, 142, 5565), CFrame.new(-8800, 142, 5500)
        elseif level >= 2075 and level < 2200 then
            return "PeanutQuest", 1, "Peanut Scout", CFrame.new(-2150, 40, -10120), CFrame.new(-2000, 40, -10300)
        elseif level >= 2200 and level < 2325 then
            return "IceCreamQuest", 1, "Ice Cream Chef", CFrame.new(-820, 65, -10960), CFrame.new(-900, 65, -11100)
        elseif level >= 2325 and level < 2450 then
            return "ChocolatQuest", 1, "Cocoa Warrior", CFrame.new(230, 25, -12200), CFrame.new(300, 25, -12400)
        elseif level >= 2450 and level < 2550 then
            return "TikiQuest1", 1, "Isle Outlaw", CFrame.new(-16550, 55, -170), CFrame.new(-16300, 55, -200)
        elseif level >= 2550 and level < 2600 then
            return "TikiQuest2", 1, "Serpent Hunter", CFrame.new(-16550, 55, -170), CFrame.new(-16700, 60, 400)
        elseif level >= 2600 and level < 2675 then
            return "SubmergedQuest1", 1, "Reef Bandit", CFrame.new(28500, -1200, 14500), CFrame.new(28700, -1200, 14700)
        else
            return "SubmergedQuest2", 1, "Sea Chanter", CFrame.new(28500, -1200, 14500), CFrame.new(29000, -1200, 15000)
        end
    end

    -- TAO TAB CHÍNH
    local MainTab = Window:CreateTab("Main Farm")
    local MaterialTab = Window:CreateTab("Materials")
    local BossTab = Window:CreateTab("Bosses & Sea")

    -- TẠO COMPONENT COMPKILLER UI
    MainTab:CreateToggle("Auto Farm Level", function(Val) _G.AutoFarmLevel = Val end)
    MainTab:CreateToggle("Auto Nhận Quest", function(Val) _G.AutoQuest = Val end)
    MainTab:CreateSlider("Tốc Độ Bay", 100, 350, 190, function(Val) _G.TweenSpeed = Val end)

    MaterialTab:CreateToggle("Auto Farm Bone", function(Val) _G.AutoFarmBone = Val end)
    MaterialTab:CreateToggle("Auto Roll Bone", function(Val) _G.AutoRandomBone = Val end)
    MaterialTab:CreateDropdown("Chọn Nguyên Liệu", {"Bones", "Conjured Cocoa", "Dragon Scale", "Fish Tail", "Angel Wings", "Magma Ore", "Leather", "Gunpowder"}, function(Option)
        _G.SelectedMaterial = Option
    end)
    MaterialTab:CreateToggle("Auto Farm Nguyên Liệu", function(Val) _G.AutoFarmMaterial = Val end)

    BossTab:CreateToggle("Auto Cake Prince", function(Val) _G.AutoCakePrince = Val end)
    BossTab:CreateToggle("Auto Dough King", function(Val) _G.AutoDoughKing = Val end)

    -- VÒNG LẶP LOGIC AUTO FARM LEVEL
    task.spawn(function()
        while task.wait(0.1) do
            if _G.AutoFarmLevel then
                pcall(function()
                    local questName, questLevel, mobName, questCFrame, mobCFrame = GetQuestData()
                    local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                    local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible

                    if not hasQuest and _G.AutoQuest then
                        TweenTo(questCFrame)
                        if (LocalPlayer.Character.HumanoidRootPart.Position - questCFrame.Position).Magnitude < 15 then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", questName, questLevel)
                        end
                    else
                        local targetMob = nil
                        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                            if enemy.Name == mobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                targetMob = enemy
                                break
                            end
                        end

                        if targetMob then
                            repeat
                                task.wait()
                                if not _G.AutoFarmLevel then break end
                                TweenTo(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0))
                                MagnetEnemies(targetMob.HumanoidRootPart.Position, mobName)
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new())
                            until not _G.AutoFarmLevel or not targetMob.Parent or targetMob.Humanoid.Health <= 0
                        else
                            TweenTo(mobCFrame)
                        end
                    end
                end)
            end
        end
    end)

    -- VÒNG LẶP LOGIC AUTO FARM MATERIAL
    task.spawn(function()
        while task.wait(0.1) do
            if _G.AutoFarmMaterial then
                pcall(function()
                    local targets = MaterialMobs[_G.SelectedMaterial]
                    if targets then
                        local targetMob = nil
                        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                            for _, mobName in ipairs(targets) do
                                if string.find(enemy.Name, mobName) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                    targetMob = enemy
                                    break
                                end
                            end
                            if targetMob then break end
                        end

                        if targetMob then
                            repeat
                                task.wait()
                                if not _G.AutoFarmMaterial then break end
                                TweenTo(targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0))
                                MagnetEnemies(targetMob.HumanoidRootPart.Position, targets)
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new())
                            until not _G.AutoFarmMaterial or not targetMob.Parent or targetMob.Humanoid.Health <= 0
                        end
                    end
                end)
            end
        end
    end)

    -- VÒNG LẶP LOGIC CAKE PRINCE & DOUGH KING
    task.spawn(function()
        while task.wait(0.1) do
            if _G.AutoCakePrince or _G.AutoDoughKing then
                pcall(function()
                    local boss = Workspace.Enemies:FindFirstChild("Cake Prince") or Workspace.Enemies:FindFirstChild("Dough King")
                    if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        repeat
                            task.wait()
                            if not (_G.AutoCakePrince or _G.AutoDoughKing) then break end
                            TweenTo(boss.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0))
                            VirtualUser:CaptureController()
                            VirtualUser:Button1Down(Vector2.new())
                        until not boss.Parent or boss.Humanoid.Health <= 0
                    else
                        local cakeMobs = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
                        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                            for _, mobName in ipairs(cakeMobs) do
                                if enemy.Name == mobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
                                        if not (_G.AutoCakePrince or _G.AutoDoughKing) then break end
                                        TweenTo(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0))
                                        MagnetEnemies(enemy.HumanoidRootPart.Position, cakeMobs)
                                        VirtualUser:CaptureController()
                                        VirtualUser:Button1Down(Vector2.new())
                                    until not enemy.Parent or enemy.Humanoid.Health <= 0
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)

    -- VÒNG LẶP LOGIC BONE ROLL
    task.spawn(function()
        while task.wait(1) do
            if _G.AutoRandomBone then
                pcall(function()
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
                end)
            end
        end
    end)
end

--====================================================--
-- TẠO PEPSI KEY SYSTEM MENU
--====================================================--
if CheckSavedKey() then
    InitMainHub()
else
    local PepsiLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Swiftz/UI-Library/refs/heads/main/Libraries/Pepsi%20-%20Example.lua"))()

    local KeySystemWindow = PepsiLib:CreateWindow({
        Name = "Pepsi Key System - LongTurbo",
        Theme = "Dark",
        Size = UDim2.new(0, 420, 0, 260)
    })

    local KeyTab = KeySystemWindow:CreateTab({ Name = "Get Key System" })
    local InputtedKey = ""

    KeyTab:CreateInput({
        Name = "Nhập Key",
        Placeholder = "Dán Key vào đây...",
        Callback = function(text)
            InputtedKey = text
        end
    })

    KeyTab:CreateButton({
        Name = "Xác Nhận Key",
        Callback = function()
            if InputtedKey == MY_SECRET_KEY then
                SaveKeyData(InputtedKey)
                print("Key Chính Xác!")
                pcall(function() KeySystemWindow:Destroy() end)
                InitMainHub()
            else
                warn("Key không chính xác!")
            end
        end
    })

    KeyTab:CreateButton({
        Name = "Sao Chép Link Get Key",
        Callback = function()
            if setclipboard then
                setclipboard(GITHUB_GET_KEY_URL)
                print("Đã copy link get key thành công!")
            end
        end
    })
end
