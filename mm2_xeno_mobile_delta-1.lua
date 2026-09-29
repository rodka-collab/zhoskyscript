-- [[ MM2 MULTIHACK HUB FOR XENO — DELTA MOBILE EDITION ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Flags = {
    EspRoles     = false,
    CoinFarm     = false,
    CoinTpFast   = false,
    GunEsp       = false,
    AntiKill     = false,
    Fly          = false,
    SilentAim    = false,
    NoClip       = false,
    Chams        = false,
    NameEsp      = false,
    SpeedHack    = false,
    InfJump      = false,
    AutoGun      = false,
    AutoShoot    = false,
    KillAura     = false,
    AutoKill     = false,
    KillSheriff  = false,
    RvankaAll    = false,
    RvankaSheriff= false,
    RvankaMurder = false,
    -- Мобильный полёт — отдельные флаги для кнопок
    FlyForward   = false,
    FlyBack      = false,
    FlyLeft      = false,
    FlyRight     = false,
    FlyUp        = false,
    FlyDown      = false,
}

local Settings = {
    FlySpeed         = 45,
    WalkSpeed        = 28,
    HitboxSize       = 3,
    AimSmooth        = 6,
    AimFOV           = 200,
    CoinCollectSpeed = 35,
    KillAuraRange    = 15,
    RvankaSpeed      = 5,
}

-- ============================================================
-- [[ GUI ]]
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2_Xeno_Mobile"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function safeParentGui(gui)
    local ok = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not ok or not gui.Parent then
        local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            or LocalPlayer:WaitForChild("PlayerGui", 10)
        if pg then gui.Parent = pg end
    end
end
safeParentGui(ScreenGui)

-- Главная панель — увеличена для пальцев
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 500)
MainFrame.Position = UDim2.new(0.02, 0, 0.08, 0) -- левый верхний угол, удобнее на мобиле
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false -- отключаем, делаем своё тач-перетаскивание
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(100, 70, 190)
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

-- Шапка (Header) — увеличена для удобного перетаскивания пальцем
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 54)
Header.BackgroundColor3 = Color3.fromRGB(28, 24, 42)
Header.BorderSizePixel = 0
Header.Parent = MainFrame
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 14)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 14, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚡ MM2 XENO • MOBILE"
TitleLabel.TextColor3 = Color3.fromRGB(200, 170, 255)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 15
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = Header

-- Кнопка скрытия — большая, вместо клавиши [P]
local HideButton = Instance.new("TextButton")
HideButton.Size = UDim2.new(0, 64, 0, 36)
HideButton.Position = UDim2.new(1, -72, 0.5, -18)
HideButton.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
HideButton.Text = "▲ Скрыть"
HideButton.TextColor3 = Color3.fromRGB(200, 170, 255)
HideButton.Font = Enum.Font.GothamBold
HideButton.TextSize = 10
HideButton.Parent = Header
Instance.new("UICorner", HideButton).CornerRadius = UDim.new(0, 8)

-- Кнопка показа (когда меню скрыто) — маленькая плашка в углу
local ShowButton = Instance.new("TextButton")
ShowButton.Size = UDim2.new(0, 80, 0, 44)
ShowButton.Position = UDim2.new(0, 10, 0, 10)
ShowButton.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
ShowButton.Text = "⚡ МЕНЮ"
ShowButton.TextColor3 = Color3.fromRGB(200, 170, 255)
ShowButton.Font = Enum.Font.GothamBold
ShowButton.TextSize = 12
ShowButton.Visible = false
ShowButton.Parent = ScreenGui
Instance.new("UICorner", ShowButton).CornerRadius = UDim.new(0, 10)

HideButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    ShowButton.Visible = true
end)
ShowButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    ShowButton.Visible = false
end)

-- Тач-перетаскивание панели
local draggingFrame = false
local dragStartPos, frameStartPos

Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = true
        dragStartPos = input.Position
        frameStartPos = MainFrame.Position
    end
end)
Header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        draggingFrame = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingFrame and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStartPos
        local vp = workspace.CurrentCamera.ViewportSize
        local newX = math.clamp(
            frameStartPos.X.Offset + delta.X, 0, vp.X - MainFrame.AbsoluteSize.X)
        local newY = math.clamp(
            frameStartPos.Y.Offset + delta.Y, 0, vp.Y - MainFrame.AbsoluteSize.Y)
        MainFrame.Position = UDim2.new(0, newX, 0, newY)
    end
end)

-- Вкладки
local TAB_NAMES = {"Визуал", "Боёвка", "Движение", "Утилиты"}
local tabButtons = {}
local tabContents = {}

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -16, 0, 40) -- выше для пальцев
TabBar.Position = UDim2.new(0, 8, 0, 58)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 5)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabBar

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -16, 1, -108)
ContentArea.Position = UDim2.new(0, 8, 0, 104)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local function switchTab(index)
    for i, btn in ipairs(tabButtons) do
        btn.BackgroundColor3 = i == index
            and Color3.fromRGB(100, 70, 180)
            or  Color3.fromRGB(30, 28, 40)
        btn.TextColor3 = i == index
            and Color3.fromRGB(255, 255, 255)
            or  Color3.fromRGB(120, 110, 140)
    end
    for i, c in ipairs(tabContents) do c.Visible = (i == index) end
end

for i, name in ipairs(TAB_NAMES) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 1, 0) -- шире для пальца
    btn.BackgroundColor3 = Color3.fromRGB(30, 28, 40)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(120, 110, 140)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.LayoutOrder = i
    btn.Parent = TabBar
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    tabButtons[i] = btn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 4 -- толще для пальца
    content.ScrollBarImageColor3 = Color3.fromRGB(100, 70, 180)
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.Visible = false
    content.Parent = ContentArea
    tabContents[i] = content

    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 8)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Parent = content

    local pad = Instance.new("UIPadding")
    pad.PaddingBottom = UDim.new(0, 8)
    pad.Parent = content

    btn.MouseButton1Click:Connect(function() switchTab(i) end)
end

switchTab(1)

-- ============================================================
-- [[ КОМПОНЕНТЫ UI — увеличены под мобиле ]]
-- ============================================================
local function createToggle(parent, name, flagName, order)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 48) -- выше для пальца
    Row.BackgroundColor3 = Color3.fromRGB(26, 24, 35)
    Row.LayoutOrder = order
    Row.Parent = parent
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(210, 200, 230)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextScaled = false
    Label.Parent = Row

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 48, 0, 26) -- крупнее переключатель
    Track.Position = UDim2.new(1, -58, 0.5, -13)
    Track.BackgroundColor3 = Color3.fromRGB(50, 45, 65)
    Track.Parent = Row
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20)
    Knob.Position = UDim2.new(0, 3, 0.5, -10)
    Knob.BackgroundColor3 = Color3.fromRGB(140, 120, 180)
    Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local toggled = false
    local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

    local function setToggle(state)
        toggled = state
        Flags[flagName] = state
        TweenService:Create(Track, tweenInfo, {
            BackgroundColor3 = state
                and Color3.fromRGB(100, 70, 180)
                or  Color3.fromRGB(50, 45, 65)
        }):Play()
        TweenService:Create(Knob, tweenInfo, {
            Position = state
                and UDim2.new(1, -23, 0.5, -10)
                or  UDim2.new(0, 3, 0.5, -10),
            BackgroundColor3 = state
                and Color3.fromRGB(255, 255, 255)
                or  Color3.fromRGB(140, 120, 180)
        }):Play()
    end

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Row
    Button.MouseButton1Click:Connect(function() setToggle(not toggled) end)
end

-- Слайдер с Touch-поддержкой
local function createSlider(parent, name, settingKey, minVal, maxVal, order)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 60) -- выше для удобства
    Row.BackgroundColor3 = Color3.fromRGB(26, 24, 35)
    Row.LayoutOrder = order
    Row.Parent = parent
    Instance.new("UICorner", Row).CornerRadius = UDim.new(0, 10)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 0, 24)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(210, 200, 230)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Row

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 58, 0, 24)
    ValueLabel.Position = UDim2.new(1, -66, 0, 6)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(Settings[settingKey])
    ValueLabel.TextColor3 = Color3.fromRGB(150, 120, 220)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 13
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Row

    local TrackBG = Instance.new("Frame")
    TrackBG.Size = UDim2.new(1, -24, 0, 8) -- толще трек
    TrackBG.Position = UDim2.new(0, 12, 0, 42)
    TrackBG.BackgroundColor3 = Color3.fromRGB(45, 40, 60)
    TrackBG.Parent = Row
    Instance.new("UICorner", TrackBG).CornerRadius = UDim.new(1, 0)

    local initT = math.clamp((Settings[settingKey] - minVal) / (maxVal - minVal), 0, 1)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(initT, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(100, 70, 180)
    Fill.Parent = TrackBG
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 20, 0, 20) -- крупнее ручка
    Knob.AnchorPoint = Vector2.new(0.5, 0.5)
    Knob.Position = UDim2.new(initT, 0, 0.5, 0)
    Knob.BackgroundColor3 = Color3.fromRGB(200, 170, 255)
    Knob.ZIndex = 5
    Knob.Parent = TrackBG
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local function updateFromX(screenX)
        local absPos = TrackBG.AbsolutePosition.X
        local absSize = TrackBG.AbsoluteSize.X
        local t = math.clamp((screenX - absPos) / absSize, 0, 1)
        local value = math.floor(minVal + t * (maxVal - minVal) + 0.5)
        Settings[settingKey] = value
        Fill.Size = UDim2.new(t, 0, 1, 0)
        Knob.Position = UDim2.new(t, 0, 0.5, 0)
        ValueLabel.Text = tostring(value)
    end

    local sliderDragging = false

    -- Touch поддержка для слайдера
    Knob.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
        end
    end)
    TrackBG.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = true
            updateFromX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            sliderDragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (
            input.UserInputType == Enum.UserInputType.Touch or
            input.UserInputType == Enum.UserInputType.MouseMove
        ) then
            updateFromX(input.Position.X)
        end
    end)
end

-- ============================================================
-- [[ НАПОЛНЕНИЕ ВКЛАДОК ]]
-- ============================================================
createToggle(tabContents[1], "ESP на роли",          "EspRoles",     1)
createToggle(tabContents[1], "Chams (сквозь стены)", "Chams",        2)
createToggle(tabContents[1], "Name ESP",             "NameEsp",      3)
createToggle(tabContents[1], "Подсветка пистолета",  "GunEsp",       4)
-- Drawing API (FOV круг и Tracer Lines) недоступны в Delta Mobile — убраны

createToggle(tabContents[2], "Silent Aim",            "SilentAim",    1)
createToggle(tabContents[2], "Авто-стрельба (Шериф)", "AutoShoot",    2)
createToggle(tabContents[2], "Kill Aura (Мардер)",    "KillAura",     3)
createToggle(tabContents[2], "Auto-Kill All (TP)",    "AutoKill",     4)
createToggle(tabContents[2], "Kill Sheriff",          "KillSheriff",  5)
createToggle(tabContents[2], "No Clip",               "NoClip",       6)
createToggle(tabContents[2], "Анти-килл",             "AntiKill",     7)
createToggle(tabContents[2], "Рванка всех",           "RvankaAll",    8)
createToggle(tabContents[2], "Рванка Шерифа",         "RvankaSheriff",9)
createToggle(tabContents[2], "Рванка Мардера",        "RvankaMurder", 10)
createSlider(tabContents[2], "Радиус Kill Aura",      "KillAuraRange",5, 30,  11)
createSlider(tabContents[2], "Плавность аима",        "AimSmooth",    1, 30,  12)
createSlider(tabContents[2], "Хитбокс игроков",       "HitboxSize",   1, 20,  13)
createSlider(tabContents[2], "Скорость рванки",       "RvankaSpeed",  1, 20,  14)

createToggle(tabContents[3], "Полёт",        "Fly",       1)
createToggle(tabContents[3], "Speed Hack",   "SpeedHack", 2)
createToggle(tabContents[3], "Infinite Jump","InfJump",   3)
createSlider(tabContents[3], "Скорость полёта", "FlySpeed",   10, 100, 4)
createSlider(tabContents[3], "Скорость бега",   "WalkSpeed",  16, 80,  5)

createToggle(tabContents[4], "Авто-сбор монет (Плавный)","CoinFarm",         1)
createToggle(tabContents[4], "Авто-сбор монет (Fast Tp)","CoinTpFast",        2)
createToggle(tabContents[4], "Авто-подбор пушки",        "AutoGun",           3)
createSlider(tabContents[4], "FOV аима",                 "AimFOV",    50,500, 4)
createSlider(tabContents[4], "Скорость сбора монет",     "CoinCollectSpeed",1,100,5)

-- ============================================================
-- [[ ВИРТУАЛЬНЫЙ ДЖОЙСТИК ПОЛЁТА ]]
-- Клавиши W/A/S/D недоступны на мобиле — заменяем на кнопки на экране
-- ============================================================
local FlyPad = Instance.new("Frame")
FlyPad.Size = UDim2.new(0, 180, 0, 180)
FlyPad.Position = UDim2.new(1, -195, 1, -195)
FlyPad.BackgroundTransparency = 1
FlyPad.Visible = false
FlyPad.ZIndex = 10
FlyPad.Parent = ScreenGui

local function makeFlyBtn(label, xOff, yOff, flagFwd, flagBwd, flagLft, flagRgt, flagUp_, flagDwn)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 54, 0, 54)
    b.Position = UDim2.new(0, xOff, 0, yOff)
    b.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    b.BackgroundTransparency = 0.3
    b.Text = label
    b.TextColor3 = Color3.fromRGB(220, 200, 255)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 18
    b.ZIndex = 11
    b.Parent = FlyPad
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

    -- Держим флаг пока палец на кнопке
    b.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            if flagFwd  then Flags.FlyForward = true  end
            if flagBwd  then Flags.FlyBack    = true  end
            if flagLft  then Flags.FlyLeft    = true  end
            if flagRgt  then Flags.FlyRight   = true  end
            if flagUp_  then Flags.FlyUp      = true  end
            if flagDwn  then Flags.FlyDown    = true  end
        end
    end)
    b.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch
        or i.UserInputType == Enum.UserInputType.MouseButton1 then
            if flagFwd  then Flags.FlyForward = false end
            if flagBwd  then Flags.FlyBack    = false end
            if flagLft  then Flags.FlyLeft    = false end
            if flagRgt  then Flags.FlyRight   = false end
            if flagUp_  then Flags.FlyUp      = false end
            if flagDwn  then Flags.FlyDown    = false end
        end
    end)
    return b
end

--       label   x    y     fwd    bwd    lft    rgt    up     dn
makeFlyBtn("▲",  63,  0,   true,  false, false, false, false, false)
makeFlyBtn("▼",  63, 122,  false, true,  false, false, false, false)
makeFlyBtn("◀",   0,  63,  false, false, true,  false, false, false)
makeFlyBtn("▶", 122,  63,  false, false, false, true,  false, false)
makeFlyBtn("↑",  63,  63,  false, false, false, false, true,  false) -- центр = вверх
-- кнопка вниз — маленькая, над паддом
local downBtn = Instance.new("TextButton")
downBtn.Size = UDim2.new(0, 54, 0, 36)
downBtn.Position = UDim2.new(1, -195, 1, -382)
downBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
downBtn.BackgroundTransparency = 0.3
downBtn.Text = "↓ Вниз"
downBtn.TextColor3 = Color3.fromRGB(220, 200, 255)
downBtn.Font = Enum.Font.GothamBold
downBtn.TextSize = 12
downBtn.ZIndex = 11
downBtn.Visible = false
downBtn.Parent = ScreenGui
Instance.new("UICorner", downBtn).CornerRadius = UDim.new(0, 10)
downBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        Flags.FlyDown = true
    end
end)
downBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch
    or i.UserInputType == Enum.UserInputType.MouseButton1 then
        Flags.FlyDown = false
    end
end)

-- Показываем/скрываем пад полёта вместе с флагом Fly
RunService.Heartbeat:Connect(function()
    FlyPad.Visible = Flags.Fly
    downBtn.Visible = Flags.Fly
end)

-- ============================================================
-- [[ ЛОГИКА ФУНКЦИЙ ]]
-- ============================================================

-- ESP Highlight
local function applyHighlight(char, color)
    local wantT = Flags.Chams and 0.2 or 0.5
    local old = char:FindFirstChild("XenoESP")
    if old then
        if old.FillColor == color and math.abs(old.FillTransparency - wantT) < 0.01 then return end
        old:Destroy()
    end
    local hi = Instance.new("Highlight")
    hi.Name = "XenoESP"
    hi.FillColor = color
    hi.OutlineColor = Color3.fromRGB(255, 255, 255)
    hi.FillTransparency = wantT
    hi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hi.Parent = char
end

local function updateNameEsp(player, color)
    local char = player.Character; if not char then return end
    local head = char:FindFirstChild("Head"); if not head then return end
    local old = char:FindFirstChild("XenoNameBillboard")
    if Flags.NameEsp then
        if not old then
            local bb = Instance.new("BillboardGui")
            bb.Name = "XenoNameBillboard"
            bb.Size = UDim2.new(0, 130, 0, 32)
            bb.StudsOffset = Vector3.new(0, 2.5, 0)
            bb.AlwaysOnTop = true
            bb.Parent = head
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 1, 0)
            lbl.BackgroundTransparency = 1
            lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 14
            lbl.TextStrokeTransparency = 0
            lbl.Parent = bb
            old = bb
        end
        local lbl = old:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.Text = player.Name; lbl.TextColor3 = color end
    else
        if old then old:Destroy() end
    end
end

task.spawn(function()
    while task.wait(0.4) do
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local char = player.Character
                    local bp = player:FindFirstChild("Backpack")
                    local hasKnife = char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))
                    local hasGun   = char:FindFirstChild("Gun")   or (bp and bp:FindFirstChild("Gun"))
                    local color = hasKnife and Color3.fromRGB(255, 60, 60)
                        or hasGun and Color3.fromRGB(60, 140, 255)
                        or Color3.fromRGB(60, 230, 100)

                    if Flags.EspRoles or Flags.Chams then
                        applyHighlight(char, color)
                    else
                        local old = char:FindFirstChild("XenoESP")
                        if old then old:Destroy() end
                    end
                    updateNameEsp(player, color)
                end
            end
        end)
    end
end)

-- Gun ESP
RunService.RenderStepped:Connect(function()
    pcall(function()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj.Name:lower():find("gun") then
                local old = obj:FindFirstChild("GunXenoESP")
                if Flags.GunEsp then
                    if not old then
                        local hi = Instance.new("Highlight")
                        hi.Name = "GunXenoESP"
                        hi.FillColor = Color3.fromRGB(255, 215, 0)
                        hi.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hi.Parent = obj
                    end
                else
                    if old then old:Destroy() end
                end
            end
        end
    end)
end)

-- NoClip
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    if Flags.NoClip then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    else
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                p.CanCollide = true
            end
        end
    end
end)

-- Поиск цели
local function getBestTarget(killerOnly)
    local cam = workspace.CurrentCamera
    if not cam then return nil, math.huge end
    local center = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y / 2)
    local best, bestDist = nil, Settings.AimFOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local bp = player:FindFirstChild("Backpack")
                local hasKnife = char:FindFirstChild("Knife") or (bp and bp:FindFirstChild("Knife"))
                if (not killerOnly) or hasKnife then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local sp, onScreen = cam:WorldToScreenPoint(head.Position)
                        if onScreen then
                            local dist = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                            if dist < bestDist then bestDist = dist; best = head end
                        end
                    end
                end
            end
        end
    end
    return best, bestDist
end

-- Silent Aim + AutoShoot
RunService.RenderStepped:Connect(function()
    if not Flags.SilentAim and not Flags.AutoShoot then return end
    local target = getBestTarget(Flags.AutoShoot)
    if not target then return end
    local cam = workspace.CurrentCamera
    if Flags.SilentAim then
        local sf = math.clamp(Settings.AimSmooth / 100, 0.005, 1)
        cam.CFrame = cam.CFrame:Lerp(CFrame.new(cam.CFrame.Position, target.Position), sf)
    end
    if Flags.AutoShoot then
        local char = LocalPlayer.Character
        local gun = char and char:FindFirstChild("Gun")
        if gun then
            pcall(function()
                local remote = gun:FindFirstChildOfClass("RemoteEvent")
                    or gun:FindFirstChild("ShootEvent")
                    or gun:FindFirstChild("Fire")
                if remote then remote:FireServer()
                else gun:Activate() end
            end)
        end
    end
end)

-- Хитбоксы
local lastHitboxSize = -1
local hitboxesActive = false
RunService.Heartbeat:Connect(function()
    local expand = Settings.HitboxSize >= 4
    local changed = Settings.HitboxSize ~= lastHitboxSize
    if not expand then
        if hitboxesActive then
            hitboxesActive = false
            for _, player in ipairs(Players:GetPlayers()) do
                if player.Character then
                    for _, hb in ipairs(player.Character:GetDescendants()) do
                        if hb.Name == "XenoHitbox" then hb:Destroy() end
                    end
                end
            end
        end
        if changed then lastHitboxSize = Settings.HitboxSize end
        return
    end
    hitboxesActive = true
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "XenoHitbox" then
                    local hb = part:FindFirstChild("XenoHitbox")
                    if not hb then
                        hb = Instance.new("Part")
                        hb.Name = "XenoHitbox"
                        hb.Transparency = 1
                        hb.CanCollide = false
                        hb.Anchored = false
                        hb.Massless = true
                        hb.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                        hb.Parent = part
                        local w = Instance.new("WeldConstraint")
                        w.Part0 = part; w.Part1 = hb; w.Parent = hb
                    elseif changed then
                        hb.Size = Vector3.new(Settings.HitboxSize, Settings.HitboxSize, Settings.HitboxSize)
                    end
                end
            end
        end
    end
    if changed then lastHitboxSize = Settings.HitboxSize end
end)

-- Kill Aura
task.spawn(function()
    while task.wait(0.05) do
        if Flags.KillAura then
            pcall(function()
                local char = LocalPlayer.Character
                local knife = char and char:FindFirstChild("Knife")
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                if not knife or not myHRP then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local tc = player.Character
                        local th = tc:FindFirstChild("HumanoidRootPart")
                        local hum = tc:FindFirstChildOfClass("Humanoid")
                        if th and hum and hum.Health > 0 then
                            if (myHRP.Position - th.Position).Magnitude <= Settings.KillAuraRange then
                                pcall(function() knife:Activate() end)
                                pcall(function()
                                    local h = knife:FindFirstChild("Handle")
                                    if h then
                                        firetouchinterest(h, th, 0)
                                        firetouchinterest(h, th, 1)
                                    end
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Auto-Kill All
task.spawn(function()
    while task.wait(0.15) do
        if Flags.AutoKill then
            pcall(function()
                local char = LocalPlayer.Character
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local knife = (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                if not knife or not myHRP then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if not Flags.AutoKill then break end
                    if player ~= LocalPlayer and player.Character then
                        local tc = player.Character
                        local th = tc:FindFirstChild("HumanoidRootPart")
                        local hum = tc:FindFirstChildOfClass("Humanoid")
                        if th and hum and hum.Health > 0 then
                            myHRP.CFrame = th.CFrame * CFrame.new(0, 0, 1.2)
                            pcall(function() knife:Activate() end)
                            pcall(function()
                                local h = knife:FindFirstChild("Handle")
                                if h then firetouchinterest(h, th, 0); firetouchinterest(h, th, 1) end
                            end)
                            task.wait(0.12)
                        end
                    end
                end
            end)
        end
    end
end)

-- Kill Sheriff
task.spawn(function()
    while task.wait(0.15) do
        if Flags.KillSheriff then
            pcall(function()
                local char = LocalPlayer.Character
                local bp = LocalPlayer:FindFirstChild("Backpack")
                local knife = (char and char:FindFirstChild("Knife")) or (bp and bp:FindFirstChild("Knife"))
                local myHRP = char and char:FindFirstChild("HumanoidRootPart")
                if not knife or not myHRP then return end
                local sheriff = nil
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local pbp = player:FindFirstChild("Backpack")
                        if player.Character:FindFirstChild("Gun") or (pbp and pbp:FindFirstChild("Gun")) then
                            sheriff = player; break
                        end
                    end
                end
                if sheriff and sheriff.Character then
                    local tc = sheriff.Character
                    local th = tc:FindFirstChild("HumanoidRootPart")
                    local hum = tc:FindFirstChildOfClass("Humanoid")
                    if th and hum and hum.Health > 0 then
                        myHRP.CFrame = th.CFrame * CFrame.new(0, 0, 1.2)
                        pcall(function() knife:Activate() end)
                        pcall(function()
                            local h = knife:FindFirstChild("Handle")
                            if h then firetouchinterest(h, th, 0); firetouchinterest(h, th, 1) end
                        end)
                    end
                end
            end)
        end
    end
end)

-- Рванка
local function applyRvanka(targetChar)
    if not targetChar then return end
    local th = targetChar:FindFirstChild("HumanoidRootPart")
    local hum = targetChar:FindFirstChildOfClass("Humanoid")
    if not th or not hum or hum.Health <= 0 then return end
    local myChar = LocalPlayer.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myHRP then return end
    local force = Settings.RvankaSpeed * 80
    pcall(function()
        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local dir = (th.Position - myHRP.Position).Unit
        bv.Velocity = (dir + Vector3.new(0, 0.6, 0)) * force
        bv.Parent = th
        game:GetService("Debris"):AddItem(bv, 0.12)
    end)
    pcall(function()
        for _, part in ipairs(targetChar:GetDescendants()) do
            if part:IsA("BasePart") then
                for _, mp in ipairs(myChar:GetDescendants()) do
                    if mp:IsA("BasePart") then
                        firetouchinterest(mp, part, 0)
                        firetouchinterest(mp, part, 1)
                    end
                end
            end
        end
    end)
    pcall(function()
        hum.PlatformStand = true
        task.delay(0.4, function()
            pcall(function() if hum and hum.Parent then hum.PlatformStand = false end end)
        end)
    end)
end

task.spawn(function()
    while task.wait(0.08) do
        if Flags.RvankaAll then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then applyRvanka(p.Character) end
                end
            end)
        end
    end
end)
task.spawn(function()
    while task.wait(0.08) do
        if Flags.RvankaSheriff then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local pb = p:FindFirstChild("Backpack")
                        if p.Character:FindFirstChild("Gun") or (pb and pb:FindFirstChild("Gun")) then
                            applyRvanka(p.Character)
                        end
                    end
                end
            end)
        end
    end
end)
task.spawn(function()
    while task.wait(0.08) do
        if Flags.RvankaMurder then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local pb = p:FindFirstChild("Backpack")
                        if p.Character:FindFirstChild("Knife") or (pb and pb:FindFirstChild("Knife")) then
                            applyRvanka(p.Character)
                        end
                    end
                end
            end)
        end
    end
end)

-- Anti-Kill
local SAFE_POSITIONS = {Vector3.new(0,5,0), Vector3.new(30,5,30), Vector3.new(-30,5,-30)}
task.spawn(function()
    local lastEscape = 0
    while task.wait(0.1) do
        if Flags.AntiKill then
            pcall(function()
                local myHRP = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHRP then return end
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                        if hrp and player.Character:FindFirstChild("Knife") and (tick()-lastEscape)>2 then
                            if (myHRP.Position - hrp.Position).Magnitude < 25 then
                                lastEscape = tick()
                                myHRP.CFrame = CFrame.new(SAFE_POSITIONS[math.random(1,#SAFE_POSITIONS)])
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- Полёт — вместо IsKeyDown используем Flags.Fly* от кнопок
task.spawn(function()
    local lv, att = nil, nil
    while task.wait(0.05) do
        pcall(function()
            local char = LocalPlayer.Character
            local hp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if Flags.Fly and hp and hum then
                if not lv or not lv.Parent then
                    if lv  then pcall(function() lv:Destroy()  end) end
                    if att then pcall(function() att:Destroy() end) end
                    att = Instance.new("Attachment"); att.Parent = hp
                    lv = Instance.new("LinearVelocity")
                    lv.Attachment0 = att
                    lv.MaxForce = math.huge
                    lv.VectorVelocity = Vector3.new(0,0,0)
                    lv.Parent = hp
                end
                hum.WalkSpeed = 0
                hum.PlatformStand = true
                local cam = workspace.CurrentCamera
                local dir = Vector3.new(0,0,0)
                if Flags.FlyForward then dir = dir + cam.CFrame.LookVector  end
                if Flags.FlyBack    then dir = dir - cam.CFrame.LookVector  end
                if Flags.FlyLeft    then dir = dir - cam.CFrame.RightVector end
                if Flags.FlyRight   then dir = dir + cam.CFrame.RightVector end
                if Flags.FlyUp      then dir = dir + Vector3.new(0,1,0)     end
                if Flags.FlyDown    then dir = dir - Vector3.new(0,1,0)     end
                lv.VectorVelocity = dir * Settings.FlySpeed
            else
                if lv  then pcall(function() lv:Destroy()  end); lv  = nil end
                if att then pcall(function() att:Destroy() end); att = nil end
                if hum then
                    hum.WalkSpeed = Flags.SpeedHack and Settings.WalkSpeed or 16
                    hum.PlatformStand = false
                end
            end
        end)
    end
end)

-- Speed Hack
RunService.Heartbeat:Connect(function()
    pcall(function()
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and not Flags.Fly then
            hum.WalkSpeed = Flags.SpeedHack and Settings.WalkSpeed or 16
        end
    end)
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Flags.InfJump then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- ============================================================
-- КЭШИРОВАНИЕ МОНЕТ: вместо GetDescendants каждые 0.1с —
-- один раз собираем список и обновляем его редко (каждые 3с)
-- Это убирает лаги и перегрев на мобиле
-- ============================================================
local coinCache = {}
local coinCacheTime = 0
local COIN_CACHE_TTL = 3 -- обновлять кэш раз в 3 секунды

local function refreshCoinCache()
    coinCache = {}
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart")
            and (obj.Name:lower():find("coin") or obj.Name:lower():find("snow"))
            and obj.Transparency < 1
        then
            table.insert(coinCache, obj)
        end
    end
    coinCacheTime = tick()
end

-- Следим за появлением новых монет через DescendantAdded
workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("BasePart")
        and (obj.Name:lower():find("coin") or obj.Name:lower():find("snow"))
    then
        table.insert(coinCache, obj)
    end
end)
-- Убираем из кэша удалённые монеты
workspace.DescendantRemoving:Connect(function(obj)
    for i, c in ipairs(coinCache) do
        if c == obj then table.remove(coinCache, i); break end
    end
end)

-- Первичное заполнение кэша
task.spawn(refreshCoinCache)

-- Плавный фарм монет — используем кэш
task.spawn(function()
    while task.wait(0.1) do
        if Flags.CoinFarm and not Flags.CoinTpFast then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                -- Отключаем коллизии только для HRP и Torso, не всего персонажа
                local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                if hrp then hrp.CanCollide = false end
                if torso then torso.CanCollide = false end

                -- Обновляем кэш если устарел
                if (tick() - coinCacheTime) > COIN_CACHE_TTL then
                    refreshCoinCache()
                end

                for _, obj in ipairs(coinCache) do
                    if not Flags.CoinFarm then break end
                    if obj and obj.Parent and obj.Transparency < 1 then
                        local targetCF = CFrame.new(obj.Position + Vector3.new(0,1,0))
                        local v = math.clamp(Settings.CoinCollectSpeed,1,100)
                        local lerpK = 0.05 + (v/100)*0.55
                        for step = 1, 12 do
                            if not Flags.CoinFarm then break end
                            hrp.CFrame = hrp.CFrame:Lerp(targetCF, lerpK)
                            if (hrp.Position - obj.Position).Magnitude < 1.5 then break end
                            task.wait(0.02)
                        end
                        task.wait(0.06)
                    end
                end
            end)
        end
    end
end)

-- Fast TP фарм монет — тоже через кэш
task.spawn(function()
    while task.wait(0.2) do
        if Flags.CoinTpFast and not Flags.CoinFarm then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end

                if (tick() - coinCacheTime) > COIN_CACHE_TTL then
                    refreshCoinCache()
                end

                for _, obj in ipairs(coinCache) do
                    if not Flags.CoinTpFast then break end
                    if obj and obj.Parent and obj.Transparency < 1 then
                        hrp.CFrame = CFrame.new(obj.Position + Vector3.new(0,1,0))
                        task.wait(0.15)
                    end
                end
            end)
        end
    end
end)

-- Авто-подбор оружия
local function checkDroppedGun(child)
    if not Flags.AutoGun then return end
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local function tryPickup(obj)
            if obj:IsA("Model") and (obj.Name:lower():find("gun") or obj.Name == "GunDrop") then
                local part = obj:FindFirstChildWhichIsA("BasePart")
                if part then hrp.CFrame = part.CFrame + Vector3.new(0,2,0); return true end
            end
            return false
        end
        if child then tryPickup(child)
        else
            for _, obj in ipairs(workspace:GetChildren()) do
                if tryPickup(obj) then break end
            end
        end
    end)
end
workspace.ChildAdded:Connect(function(child)
    task.wait(0.05)
    if child and child.Parent == workspace then checkDroppedGun(child) end
end)
task.spawn(function()
    while task.wait(1) do checkDroppedGun(nil) end
end)
