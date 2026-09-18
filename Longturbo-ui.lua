--====================================================--
-- REALKID HUB UI LIBRARY (CÓ NÚT BẬT/TẮT MENU)
--====================================================--
local RealKidUI = {}
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

function RealKidUI:CreateWindow(Config)
    local Window = {}
    
    if CoreGui:FindFirstChild("RealKidHubUI") then
        CoreGui.RealKidHubUI:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RealKidHubUI"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false

    -- 1. NÚT BẬT / TẮT MENU (FLOATING TOGGLE BUTTON)
    local ToggleBtn = Instance.new("ImageButton")
    ToggleBtn.Name = "ToggleButton"
    ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
    ToggleBtn.Position = UDim2.new(0, 15, 0.15, 0)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
    ToggleBtn.Image = "rbxassetid://18751483361" -- Icon Hub
    ToggleBtn.Parent = ScreenGui

    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 10)
    local BtnStroke = Instance.new("UIStroke", ToggleBtn)
    BtnStroke.Color = Color3.fromRGB(0, 140, 255)
    BtnStroke.Thickness = 2

    -- Kéo thả Nút Bật/Tắt trên màn hình
    local BtnDragging, BtnDragStart, BtnStartPos
    ToggleBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            BtnDragging = true; BtnDragStart = input.Position; BtnStartPos = ToggleBtn.Position
        end
    end)
    ToggleBtn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            BtnDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if BtnDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - BtnDragStart
            ToggleBtn.Position = UDim2.new(BtnStartPos.X.Scale, BtnStartPos.X.Offset + delta.X, BtnStartPos.Y.Scale, BtnStartPos.Y.Offset + delta.Y)
        end
    end)

    -- 2. KHUNG MENU CHÍNH
    local Main = Instance.new("Frame")
    Main.Name = "MainFrame"
    Main.Size = UDim2.new(0, 620, 0, 360)
    Main.Position = UDim2.new(0.5, -310, 0.5, -180)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Main.BorderSizePixel = 0
    Main.ClipsDescendants = true
    Main.Parent = ScreenGui

    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
    local Stroke = Instance.new("UIStroke", Main)
    Stroke.Color = Color3.fromRGB(35, 35, 45)

    -- CHỨC NĂNG BẬT / TẮT MENU
    local MenuVisible = true
    local function ToggleMenu()
        MenuVisible = not MenuVisible
        Main.Visible = MenuVisible
    end

    -- Bật/tắt khi bấm vào Nút Nổi
    ToggleBtn.MouseButton1Click:Connect(ToggleMenu)

    -- Bật/tắt bằng phím tắt Ctrl Trái (LeftControl)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.LeftControl then
            ToggleMenu()
        end
    end)

    -- Xử lý Kéo thả Main Frame
    local Dragging, DragStart, StartPos
    Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true; DragStart = input.Position; StartPos = Main.Position
        end
    end)
    Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - DragStart
            Main.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
        end
    end)

    -- Sidebar & Search
    local Sidebar = Instance.new("Frame", Main)
    Sidebar.Size = UDim2.new(0, 170, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(14, 14, 17)

    local SearchBox = Instance.new("TextBox", Sidebar)
    SearchBox.Size = UDim2.new(1, -16, 0, 28)
    SearchBox.Position = UDim2.new(0, 8, 0, 8)
    SearchBox.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "🔍 Search section..."
    SearchBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    SearchBox.Font = Enum.Font.SourceSans
    SearchBox.TextSize = 13
    SearchBox.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 5)
    Instance.new("UIPadding", SearchBox).PaddingLeft = UDim.new(0, 8)

    local TabScroll = Instance.new("ScrollingFrame", Sidebar)
    TabScroll.Size = UDim2.new(1, 0, 1, -44)
    TabScroll.Position = UDim2.new(0, 0, 0, 44)
    TabScroll.BackgroundTransparency = 1
    TabScroll.ScrollBarThickness = 2

    local TabList = Instance.new("UIListLayout", TabScroll)
    TabList.Padding = UDim.new(0, 2)

    -- Header Title
    local HeaderTitle = Instance.new("TextLabel", Main)
    HeaderTitle.Size = UDim2.new(1, -185, 0, 35)
    HeaderTitle.Position = UDim2.new(0, 185, 0, 0)
    HeaderTitle.Text = Config.Title or "RealKid Hub"
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderTitle.Font = Enum.Font.SourceSansBold
    HeaderTitle.TextSize = 16
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.BackgroundTransparency = 1

    local ContainerFolder = Instance.new("Frame", Main)
    ContainerFolder.Size = UDim2.new(1, -180, 1, -40)
    ContainerFolder.Position = UDim2.new(0, 175, 0, 35)
    ContainerFolder.BackgroundTransparency = 1

    local Tabs = {}
    local FirstTab = true

    function Window:CreateTab(TabName)
        local TabObj = {}

        local TabBtn = Instance.new("TextButton", TabScroll)
        TabBtn.Size = UDim2.new(1, -12, 0, 28)
        TabBtn.Position = UDim2.new(0, 6, 0, 0)
        TabBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
        TabBtn.Text = "   " .. TabName
        TabBtn.TextColor3 = Color3.fromRGB(160, 160, 175)
        TabBtn.Font = Enum.Font.SourceSans
        TabBtn.TextSize = 13
        TabBtn.TextXAlignment = Enum.TextXAlignment.Left
        Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

        local TabPage = Instance.new("ScrollingFrame", ContainerFolder)
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.Visible = false
        TabPage.ScrollBarThickness = 3

        local PageList = Instance.new("UIListLayout", TabPage)
        PageList.Padding = UDim.new(0, 8)

        if FirstTab then
            FirstTab = false
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            HeaderTitle.Text = TabName
        end

        TabBtn.MouseButton1Click:Connect(function()
            for _, t in pairs(Tabs) do
                t.Page.Visible = false
                t.Btn.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
                t.Btn.TextColor3 = Color3.fromRGB(160, 160, 175)
            end
            TabPage.Visible = true
            TabBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
            TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            HeaderTitle.Text = TabName
        end)

        table.insert(Tabs, {Btn = TabBtn, Page = TabPage})

        function TabObj:AddSection(Title)
            local Sec = Instance.new("Frame", TabPage)
            Sec.Size = UDim2.new(1, -10, 0, 20)
            Sec.BackgroundTransparency = 1
            local Text = Instance.new("TextLabel", Sec)
            Text.Size = UDim2.new(1, 0, 1, 0)
            Text.Text = Title
            Text.TextColor3 = Color3.fromRGB(140, 140, 160)
            Text.Font = Enum.Font.SourceSansBold
            Text.TextSize = 12
            Text.TextXAlignment = Enum.TextXAlignment.Center
            Text.BackgroundTransparency = 1
        end

        function TabObj:AddToggle(Config)
            local Frame = Instance.new("Frame", TabPage)
            Frame.Size = UDim2.new(1, -10, 0, 40)
            Frame.BackgroundColor3 = Color3.fromRGB(24, 24, 30)
            Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 5)

            local Label = Instance.new("TextLabel", Frame)
            Label.Size = UDim2.new(0.8, 0, 0, 18)
            Label.Position = UDim2.new(0, 10, 0, 3)
            Label.Text = Config.Name or "Toggle"
            Label.TextColor3 = Color3.fromRGB(255, 255, 255)
            Label.Font = Enum.Font.SourceSansBold
            Label.TextSize = 13
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1

            local Box = Instance.new("TextButton", Frame)
            Box.Size = UDim2.new(0, 16, 0, 16)
            Box.Position = UDim2.new(1, -26, 0.5, -8)
            Box.BackgroundColor3 = Config.Default and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(15, 15, 20)
            Box.Text = ""
            Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 3)

            local Toggled = Config.Default or false
            Box.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                Box.BackgroundColor3 = Toggled and Color3.fromRGB(0, 140, 255) or Color3.fromRGB(15, 15, 20)
                if Config.Callback then Config.Callback(Toggled) end
            end)
        end

        return TabObj
    end

    return Window
end

-- TẠO GIAO DIỆN MẪU
local Window = RealKidUI:CreateWindow({Title = "longturbo Hub | Blox Fruits"})
local FarmTab = Window:CreateTab("Farm")
FarmTab:AddSection("Event")
FarmTab:AddToggle({Name = "Auto Secret Quest", Callback = function(val) print(val) end})
