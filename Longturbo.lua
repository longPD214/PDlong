--// CẤU HÌNH VÀ BẢO MẬT KEY SYSTEM
local GITHUB_RAW_URL = "https://raw.githubusercontent.com/longPD214/PDlong/refs/heads/main/Key-longturbohub.key" 
local GITHUB_GET_KEY_URL = "https://raw.githubusercontent.com/longPD214/PDlong/refs/heads/main/Key-longturbohub.key" 
local FILE_NAME = "longturbo_key_data.json"
local EXPIRE_TIME = 86400 -- 24 tiếng (tính bằng giây)

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

--// HÀM CHẠY SCRIPT CHÍNH (SỬ DỤNG PANDA UI LIBRARY)
local function InitMainHub()
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

    -- Auto Fast Attack (CheemBanana Logic)
    task.spawn(function()
        pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Dev-Meoz/LuaCyder-Meoz/refs/heads/main/BF-CheemBanana.lua"))()
        end)
    end)

    -- Tải Panda UI Library từ link của bạn
    local Library = loadstring(game:HttpGet("https://pandevelopment.net/virtual/file/aa11f3e4e6499f05"))()
    local Window = Library:Window("longturboTV Hub | Blox Fruits")

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

    -- GIAO DIỆN CHÍNH PANDA UI
    Window:Toggle("Auto Farm Level", false, function(Val) _G.AutoFarmLevel = Val end)
    Window:Toggle("Auto Nhận Quest", false, function(Val) _G.AutoQuest = Val end)
    Window:Slider("Tốc Độ Bay", 100, 350, 190, function(Val) _G.TweenSpeed = Val end)
    
    Window:Toggle("Auto Farm Bone", false, function(Val) _G.AutoFarmBone = Val end)
    Window:Toggle("Auto Roll Bone", false, function(Val) _G.AutoRandomBone = Val end)
    Window:Dropdown("Chọn Nguyên Liệu", {"Bones", "Conjured Cocoa", "Dragon Scale", "Fish Tail", "Angel Wings", "Magma Ore", "Leather", "Gunpowder"}, function(Option)
        _G.SelectedMaterial = Option
    end)
    Window:Toggle("Auto Farm Nguyên Liệu Đã Chọn", false, function(Val) _G.AutoFarmMaterial = Val end)

    Window:Toggle("Auto Cake Prince", false, function(Val) _G.AutoCakePrince = Val end)
    Window:Toggle("Auto Dough King", false, function(Val) _G.AutoDoughKing = Val end)

    Window:Toggle("Auto Quest Sea 1 -> Sea 2", false, function(Val) _G.AutoSea1ToSea2 = Val end)
    Window:Toggle("Auto Quest Sea 2 -> Sea 3", false, function(Val) _G.AutoSea2ToSea3 = Val end)

    -- Phím tắt Ẩn/Hiện Menu
    Library:Keybind("RightControl")

    -- VÒNG LẶP LOGIC AUTO FARM MATERIAL
    task.spawn(function()
        while task.wait() do
            if _G.AutoFarmMaterial then
                pcall(function()
                    local targets = MaterialMobs[_G.SelectedMaterial]
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and targets then
                        for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
                            for _, mobName in ipairs(targets) do
                                if string.find(enemy.Name, mobName) and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                    repeat
                                        task.wait()
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
        while task.wait() do
            if _G.AutoCakePrince or _G.AutoDoughKing then
                pcall(function()
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end

                    local boss = Workspace.Enemies:FindFirstChild("Cake Prince") or Workspace.Enemies:FindFirstChild("Dough King")
                    if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                        repeat
                            task.wait()
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
                                        task.wait()
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
end

--// BẢNG GET KEY (RAYFIELD UI)
if CheckSavedKey() then
    -- Nếu đã có Key lưu hợp lệ -> Mở thẳng Hub
    InitMainHub()
else
    -- Chưa có Key -> Tải Rayfield UI để hiển thị Bảng Nhập Key
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
                
                -- Thông báo thành công
                Rayfield:Notify({
                    Title = "Thành Công",
                    Content = "Key chính xác! Đang xóa bảng Key và khởi chạy Hub...",
                    Duration = 2,
                    Image = 4483362458,
                })
                
                task.wait(1.5)
                
                -- XÓA HOÀN TOÀN BẢNG RAYFIELD GET KEY
                Rayfield:Destroy()
                
                -- KHỞI CHẠY PANDA UI HUBSCRIPT CHÍNH
                InitMainHub()
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
