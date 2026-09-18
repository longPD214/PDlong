--// CẤU HÌNH VÀ BẢO MẬT KEY SYSTEM
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
                delfile(FILE_NAME)
            end
        end
    end
    return false
end

--// HÀM CHẠY SCRIPT CHÍNH (REDZ UI CHUẨN)
local function InitMainHub()
    task.spawn(function()
        local TweenService = game:GetService("TweenService")
        local VirtualUser = game:GetService("VirtualUser")
        local Players = game:GetService("Players")
        local Workspace = game:GetService("Workspace")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local LocalPlayer = Players.LocalPlayer

        -- Anti-AFK
        task.spawn(function()
            LocalPlayer.Idled:Connect(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)

        -- Auto Fast Attack (CheemBanana)
        task.spawn(function()
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-Meoz/LuaCyder-Meoz/refs/heads/main/BF-CheemBanana.lua"))()
            end)
        end)

        -- Tải Redz Library V5
        local RedzLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/redz-hub/RedzLibV5/main/Source.Lua"))()

        local Window = RedzLib:MakeWindow({
            Title = "longturboTV hub | Blox Fruits",
            SubTitle = "Main Version",
            SaveFolder = "longturbo_config.json"
        })

        -- NÚT BẬT/TẮT MENU NỔI (KÉO THẢ DỄ DÀNG)
        local ToggleScreen = Instance.new("ScreenGui")
        local ToggleButton = Instance.new("ImageButton")
        local UICorner = Instance.new("UICorner")

        ToggleScreen.Name = "longturbo_ToggleGui"
        ToggleScreen.Parent = game:GetService("CoreGui")
        ToggleScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        ToggleButton.Name = "ToggleButton"
        ToggleButton.Parent = ToggleScreen
        ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        ToggleButton.Position = UDim2.new(0.05, 0, 0.2, 0)
        ToggleButton.Size = UDim2.new(0, 45, 0, 45)
        ToggleButton.Image = "rbxassetid://7193356002"
        ToggleButton.Active = true
        ToggleButton.Draggable = true

        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = ToggleButton

        ToggleButton.MouseButton1Click:Connect(function()
            RedzLib:ToggleUI()
        end)

        -- Tạo các Tab
        local MainTab = Window:MakeTab({"Main Farm", "home"})
        local ItemTab = Window:MakeTab({"Auto Material", "shopping-bag"})
        local CakeTab = Window:MakeTab({"Cake Prince", "cake"})
        local SeaTab = Window:MakeTab({"Sea Quests", "compass"})

        -- Biến trạng thái Logic
        _G.AutoFarmLevel = false
        _G.AutoQuest = false
        _G.AutoFarmBone = false
        _G.AutoRandomBone = false
        _G.AutoFarmMaterial = false
        _G.SelectedMaterial = "Bones"
        _G.AutoCakePrince = false
        _G.AutoDoughKing = false
        _G.AutoSea1ToSea2 = false
        _G.AutoSea2ToSea3 = false
        _G.TweenSpeed = 190

        local MaterialMobs = {
            ["Bones"] = {"Reborn Skeleton", "Living Zombie", "Demonic Soul", "Posseessed Mummy"},
            ["Conjured Cocoa"] = {"Cocoa Warrior", "Chocolate Bar Battler"},
            ["Dragon Scale"] = {"Dragon Crew Archer", "Dragon Crew Warrior"},
            ["Fish Tail"] = {"Fishman Warrior", "Fishman Commando", "Fishman Raider", "Fishman Captain"},
            ["Angel Wings"] = {"God's Guard", "Shanda", "Royal Squad"},
            ["Magma Ore"] = {"Military Soldier", "Military Spy", "Magma Ninja"},
            ["Leather"] = {"Pirate", "Brute"},
            ["Gunpowder"] = {"Pistol Billionaire", "Mercenary"}
        }

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

        -- 1. TAB MAIN FARM
        MainTab:AddToggle({
            Name = "Auto Farm Level",
            Default = false,
            Callback = function(Value) _G.AutoFarmLevel = Value end
        })

        MainTab:AddToggle({
            Name = "Auto Nhận Quest",
            Default = false,
            Callback = function(Value) _G.AutoQuest = Value end
        })

        MainTab:AddSlider({
            Name = "Tốc Độ Bay",
            Min = 100,
            Max = 350,
            Increase = 10,
            Default = 190,
            Callback = function(Value) _G.TweenSpeed = Value end
        })

        -- 2. TAB AUTO MATERIAL
        ItemTab:AddToggle({
            Name = "Auto Farm Bone",
            Default = false,
            Callback = function(Value) _G.AutoFarmBone = Value end
        })

        ItemTab:AddToggle({
            Name = "Auto Roll Bone",
            Default = false,
            Callback = function(Value) _G.AutoRandomBone = Value end
        })

        ItemTab:AddDropdown({
            Name = "Chọn Loại Nguyên Liệu",
            Options = {"Bones", "Conjured Cocoa", "Dragon Scale", "Fish Tail", "Angel Wings", "Magma Ore", "Leather", "Gunpowder"},
            Default = "Bones",
            Callback = function(Option) _G.SelectedMaterial = Option end
        })

        ItemTab:AddToggle({
            Name = "Auto Farm Nguyên Liệu Đã Chọn",
            Default = false,
            Callback = function(Value) _G.AutoFarmMaterial = Value end
        })

        -- 3. TAB CAKE PRINCE
        CakeTab:AddToggle({
            Name = "Auto Cake Prince",
            Default = false,
            Callback = function(Value) _G.AutoCakePrince = Value end
        })

        CakeTab:AddToggle({
            Name = "Auto Dough King",
            Default = false,
            Callback = function(Value) _G.AutoDoughKing = Value end
        })

        -- 4. TAB SEA QUESTS
        SeaTab:AddToggle({
            Name = "Auto Quest Sea 1 -> Sea 2",
            Default = false,
            Callback = function(Value) _G.AutoSea1ToSea2 = Value end
        })

        SeaTab:AddToggle({
            Name = "Auto Quest Sea 2 -> Sea 3",
            Default = false,
            Callback = function(Value) _G.AutoSea2ToSea3 = Value end
        })

        -- VÒNG LẶP LOGIC AUTO FARM MATERIAL
        task.spawn(function()
            while task.wait(0.1) do
                if _G.AutoFarmMaterial then
                    pcall(function()
                        local targets = MaterialMobs[_G.SelectedMaterial]
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and targets then
                            for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                                for _, mobName in ipairs(targets) do
                                    if string.find(enemy.Name, mobName) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        repeat
                                            task.wait(0.05)
                                            if not _G.AutoFarmMaterial then break end
                                            local targetCFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                            local dist = (hrp.Position - targetCFrame.Position).Magnitude
                                            TweenService:Create(hrp, TweenInfo.new(dist / _G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
                                            MagnetEnemies(enemy.HumanoidRootPart.Position, targets)
                                            VirtualUser:CaptureController()
                                            VirtualUser:Button1Down(Vector2.new())
                                        until not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0 or not _G.AutoFarmMaterial
                                    end
                                end
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
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if not hrp then return end

                        local boss = Workspace.Enemies:FindFirstChild("Cake Prince") or Workspace.Enemies:FindFirstChild("Dough King")
                        if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                            repeat
                                task.wait(0.05)
                                if not (_G.AutoCakePrince or _G.AutoDoughKing) then break end
                                local targetCFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 12, 0)
                                local dist = (hrp.Position - targetCFrame.Position).Magnitude
                                TweenService:Create(hrp, TweenInfo.new(dist / _G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
                                VirtualUser:CaptureController()
                                VirtualUser:Button1Down(Vector2.new())
                            until not boss or not boss:FindFirstChild("Humanoid") or boss.Humanoid.Health <= 0
                        else
                            local cakeMobs = {"Cookie Crafter", "Cake Guard", "Baking Staff", "Head Baker"}
                            for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                                for _, mobName in ipairs(cakeMobs) do
                                    if enemy.Name == mobName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                        repeat
                                            task.wait(0.05)
                                            if not (_G.AutoCakePrince or _G.AutoDoughKing) then break end
                                            local targetCFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                                            local dist = (hrp.Position - targetCFrame.Position).Magnitude
                                            TweenService:Create(hrp, TweenInfo.new(dist / _G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
                                            MagnetEnemies(enemy.HumanoidRootPart.Position, cakeMobs)
                                            VirtualUser:CaptureController()
                                            VirtualUser:Button1Down(Vector2.new())
                                        until not enemy or not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0
                                    end
                                end
                            end
                        end
                    end)
                end
            end
        end)
    end)
end

--// BẢNG GET KEY (RAYFIELD UI)
if CheckSavedKey() then
    InitMainHub()
else
    local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

    local KeyWindow = Rayfield:CreateWindow({
        Name = "longturboTV Hub | Key System",
        LoadingTitle = "Key Verification",
        LoadingSubtitle = "Vui lòng nhập Key để mở Hub",
        ConfigurationSaving = { Enabled = false },
        KeySystem = false
    })

    local KeyTab = KeyWindow:CreateTab("Nhập Key", 4483362458)
    local InputtedKey = ""

    KeyTab:CreateInput({
        Name = "Nhập Key Tại Đây",
        PlaceholderText = "Dán Key của bạn...",
        RemoveTextOnFocus = false,
        Callback = function(Text)
            InputtedKey = Text
        end,
    })

    KeyTab:CreateButton({
        Name = "Sao Chép Link Get Key (GitHub)",
        Callback = function()
            setclipboard(GITHUB_GET_KEY_URL)
            Rayfield:Notify({
                Title = "Thông Báo",
                Content = "Đã sao chép link Get Key vào Khay nhớ tạm!",
                Duration = 3,
                Image = 4483362458,
            })
        end,
    })

    KeyTab:CreateButton({
        Name = "Xác Nhận Key",
        Callback = function()
            if InputtedKey == MY_SECRET_KEY then
                SaveKeyData(InputtedKey)
                
                Rayfield:Notify({
                    Title = "Thành Công",
                    Content = "Key chính xác! Đang tải Redz Hub...",
                    Duration = 2,
                    Image = 4483362458,
                })
                
                -- Khởi chạy Hub trước rồi ẩn/xóa Rayfield sau để tránh đứng luồng
                InitMainHub()
                task.wait(1)
                Rayfield:Destroy()
            else
                Rayfield:Notify({
                    Title = "Thất Bại",
                    Content = "Key không chính xác, vui lòng thử lại!",
                    Duration = 3,
                    Image = 4483362458,
                })
            end
        end,
    })
end
