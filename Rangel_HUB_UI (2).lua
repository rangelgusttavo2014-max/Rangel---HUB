-- RANGEL HUB | UI base para Roblox Studio
-- Interface visual independente. Conecte callbacks apenas a funções do seu próprio jogo.
-- Coloque como LocalScript em StarterPlayerScripts ou StarterGui.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configure IDs de áudio que você tenha permissão para usar.
local CLICK_SOUND_ID = "" -- Ex.: "rbxassetid://123456789"
local OPEN_SOUND_ID = ""
local CLOSE_SOUND_ID = ""

local COLORS = {
    Background = Color3.fromRGB(20, 25, 30),
    Panel = Color3.fromRGB(31, 37, 43),
    Panel2 = Color3.fromRGB(45, 51, 58),
    Red = Color3.fromRGB(255, 45, 45),
    RedDark = Color3.fromRGB(105, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Muted = Color3.fromRGB(195, 201, 208),
    Green = Color3.fromRGB(70, 230, 115),
    Stroke = Color3.fromRGB(0, 0, 0),
}

local function make(className, props, parent)
    local obj = Instance.new(className)
    for k, v in pairs(props or {}) do obj[k] = v end
    obj.Parent = parent
    return obj
end

local function round(parent, radius)
    make("UICorner", {CornerRadius = UDim.new(0, radius or 10)}, parent)
end

local function stroke(parent, color, thickness, transparency)
    return make("UIStroke", {
        Color = color or COLORS.Stroke,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
    }, parent)
end

local function playSound(id, volume)
    if _G.RangelHubSoundsEnabled == false then return end
    if not id or id == "" then return end
    local sound = Instance.new("Sound")
    sound.SoundId = id
    sound.Volume = volume or 0.35
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Once(function() sound:Destroy() end)
    task.delay(5, function()
        if sound.Parent then sound:Destroy() end
    end)
end

local function tween(obj, duration, props, style)
    local t = TweenService:Create(obj, TweenInfo.new(
        duration or 0.18,
        style or Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), props)
    t:Play()
    return t
end

local gui = make("ScreenGui", {
    Name = "RangelHub",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local shade = make("Frame", {
    Name = "Backdrop",
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
    Visible = false,
}, gui)

local window = make("Frame", {
    Name = "MainWindow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.53),
    Size = UDim2.fromOffset(900, 560),
    BackgroundColor3 = COLORS.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, gui)
round(window, 5)
stroke(window, Color3.fromRGB(0, 0, 0), 3, 0)

local scale = make("UIScale", {Scale = 0.92}, window)

local top = make("Frame", {
    Name = "TopBar",
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
}, window)
make("Frame", {
    BackgroundColor3 = COLORS.Red,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -3),
    Size = UDim2.new(1, 0, 0, 3),
}, top)

local logo = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(20, 8),
    Size = UDim2.fromOffset(42, 44),
    Font = Enum.Font.GothamBlack,
    Text = "R",
    TextColor3 = COLORS.Red,
    TextSize = 36,
}, top)

local title = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(66, 10),
    Size = UDim2.fromOffset(250, 25),
    Font = Enum.Font.GothamBlack,
    Text = "RANGEL HUB",
    TextColor3 = COLORS.Text,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local subtitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(67, 35),
    Size = UDim2.fromOffset(300, 17),
    Font = Enum.Font.GothamMedium,
    Text = "PAINEL PERSONALIZÁVEL  •  V2.0",
    TextColor3 = COLORS.Muted,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, top)

local status = make("TextLabel", {
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -58, 0.5, 0),
    Size = UDim2.fromOffset(130, 24),
    Font = Enum.Font.GothamMedium,
    Text = "●  ONLINE",
    TextColor3 = COLORS.Green,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Right,
}, top)

local closeButton = make("TextButton", {
    Name = "Close",
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -15, 0.5, 0),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = COLORS.Panel2,
    BorderSizePixel = 0,
    Text = "×",
    TextColor3 = COLORS.Text,
    Font = Enum.Font.GothamBold,
    TextSize = 22,
    AutoButtonColor = false,
}, top)
round(closeButton, 9)

local sidebar = make("Frame", {
    Name = "Sidebar",
    Position = UDim2.fromOffset(0, 73),
    Size = UDim2.new(0, 190, 1, -73),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
}, window)

local sideTitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(17, 15),
    Size = UDim2.new(1, -34, 0, 20),
    Font = Enum.Font.GothamBold,
    Text = "MENU PRINCIPAL",
    TextColor3 = COLORS.Muted,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
}, sidebar)

local nav = make("Frame", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(10, 45),
    Size = UDim2.new(1, -20, 1, -60),
}, sidebar)
make("UIListLayout", {
    Padding = UDim.new(0, 7),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, nav)

local content = make("Frame", {
    Name = "PageContent",
    Position = UDim2.fromOffset(205, 88),
    Size = UDim2.new(1, -220, 1, -104),
    BackgroundTransparency = 1,
    ClipsDescendants = true,
}, window)

local pageTitle = make("TextLabel", {
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 34),
    Font = Enum.Font.GothamBold,
    Text = "Início",
    TextColor3 = COLORS.Text,
    TextSize = 22,
    TextXAlignment = Enum.TextXAlignment.Left,
}, content)

local pageDesc = make("TextLabel", {
    BackgroundTransparency = 1,
    Position = UDim2.fromOffset(0, 34),
    Size = UDim2.new(1, 0, 0, 22),
    Font = Enum.Font.Gotham,
    Text = "Atalhos e informações do painel.",
    TextColor3 = COLORS.Muted,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
}, content)

local cards = make("ScrollingFrame", {
    Name = "Cards",
    Position = UDim2.fromOffset(0, 68),
    Size = UDim2.new(1, 0, 1, -68),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = COLORS.Red,
    CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, content)
make("UIListLayout", {
    Padding = UDim.new(0, 9),
    SortOrder = Enum.SortOrder.LayoutOrder,
}, cards)
make("UIPadding", {
    PaddingRight = UDim.new(0, 5),
    PaddingBottom = UDim.new(0, 8),
}, cards)

local pages = {}
local currentPage
local callbacks = {}

local function clearCards()
    for _, child in ipairs(cards:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

local function addCard(labelText, descriptionText)
    local card = make("Frame", {
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -5, 0, 64),
    }, cards)
    round(card, 10)
    stroke(card, COLORS.Stroke, 1, 0.45)

    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 9),
        Size = UDim2.new(1, -28, 0, 21),
        Font = Enum.Font.GothamBold,
        Text = labelText,
        TextColor3 = COLORS.Text,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)

    make("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(14, 31),
        Size = UDim2.new(1, -28, 0, 22),
        Font = Enum.Font.Gotham,
        Text = descriptionText or "",
        TextColor3 = COLORS.Muted,
        TextSize = 11,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, card)
    return card
end

local function addButton(labelText, descriptionText, callbackName, callback)
    local card = addCard(labelText, descriptionText)
    local button = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(94, 32),
        BackgroundColor3 = COLORS.RedDark,
        BorderSizePixel = 0,
        Font = Enum.Font.GothamBold,
        Text = "EXECUTAR",
        TextColor3 = COLORS.Text,
        TextSize = 10,
        AutoButtonColor = false,
    }, card)
    round(button, 8)
    button.MouseEnter:Connect(function()
        tween(button, 0.12, {BackgroundColor3 = COLORS.Red})
    end)
    button.MouseLeave:Connect(function()
        tween(button, 0.12, {BackgroundColor3 = COLORS.RedDark})
    end)
    button.Activated:Connect(function()
        playSound(CLICK_SOUND_ID)
        tween(button, 0.08, {Size = UDim2.fromOffset(88, 29)})
        task.delay(0.09, function()
            if button.Parent then tween(button, 0.12, {Size = UDim2.fromOffset(94, 32)}) end
        end)
        if callback then
            local ok, err = pcall(callback)
            if not ok then warn("[Rangel HUB] Callback '" .. callbackName .. "' falhou: " .. tostring(err)) end
        end
    end)
    callbacks[callbackName] = callback
    return button
end

local function addToggle(labelText, descriptionText, callbackName, defaultValue, callback)
    local card = addCard(labelText, descriptionText)
    local toggle = make("TextButton", {
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -13, 0.5, 0),
        Size = UDim2.fromOffset(48, 26),
        BackgroundColor3 = defaultValue and COLORS.Red or COLORS.Panel2,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
    }, card)
    round(toggle, 13)
    local knob = make("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = defaultValue and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0,
    }, toggle)
    round(knob, 9)

    local value = defaultValue == true
    local function setValue(newValue)
        value = newValue == true
        tween(toggle, 0.16, {BackgroundColor3 = value and COLORS.Red or COLORS.Panel2})
        tween(knob, 0.16, {Position = value and UDim2.new(1, -22, 0.5, 0) or UDim2.new(0, 4, 0.5, 0)})
        if callback then
            local ok, err = pcall(callback, value)
            if not ok then warn("[Rangel HUB] Toggle '" .. callbackName .. "' falhou: " .. tostring(err)) end
        end
    end
    toggle.Activated:Connect(function()
        playSound(CLICK_SOUND_ID)
        setValue(not value)
    end)
    callbacks[callbackName] = setValue
    return function() return value end
end

local function addPage(name, icon, description, build)
    local button = make("TextButton", {
        Name = name .. "Button",
        BackgroundColor3 = COLORS.Panel,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 42),
        Font = Enum.Font.GothamSemibold,
        Text = "   " .. icon .. "   " .. name,
        TextColor3 = COLORS.Muted,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutoButtonColor = false,
    }, nav)
    round(button, 3)

    local page = {name = name, description = description, build = build, button = button}
    pages[name] = page

    button.MouseEnter:Connect(function()
        if currentPage ~= name then tween(button, 0.12, {BackgroundColor3 = COLORS.Panel2}) end
    end)
    button.MouseLeave:Connect(function()
        if currentPage ~= name then tween(button, 0.12, {BackgroundColor3 = COLORS.Panel}) end
    end)
    button.Activated:Connect(function()
        playSound(CLICK_SOUND_ID)
        if currentPage == name then return end
        currentPage = name
        for otherName, other in pairs(pages) do
            local selected = otherName == name
            tween(other.button, 0.14, {
                BackgroundColor3 = selected and COLORS.RedDark or COLORS.Panel,
                TextColor3 = selected and COLORS.Text or COLORS.Muted,
            })
        end
        pageTitle.Text = name
        pageDesc.Text = description
        clearCards()
        if build then build() end
        cards.CanvasPosition = Vector2.zero
        cards.Position = UDim2.fromOffset(12, 68)
        cards.BackgroundTransparency = 1
        tween(cards, 0.22, {Position = UDim2.fromOffset(0, 68), BackgroundTransparency = 0})
    end)
end

addPage("Início", "⌂", "Visão geral do Rangel HUB.", function()
    addCard("Bem-vindo ao Rangel HUB", "Interface escura, detalhes vermelhos e animações suaves.")
    addCard("Atalhos", "Use RightShift para mostrar ou esconder o painel.")
    addCard("Callbacks", "Os controles podem ser conectados a funções legítimas do seu próprio jogo.")
    addButton("Testar animação", "Reproduz uma animação visual de confirmação.", "TestAnimation", function()
        tween(logo, 0.18, {Rotation = 12, TextColor3 = Color3.fromRGB(255, 95, 110)})
        task.delay(0.2, function()
            if logo.Parent then tween(logo, 0.2, {Rotation = 0, TextColor3 = COLORS.Red}) end
        end)
    end)
end)

addPage("Visual", "◈", "Preferências visuais do painel.", function()
    addToggle("Efeito de brilho", "Ativa um destaque no contorno do painel.", "VisualGlow", false, function(enabled)
        tween(window, 0.2, {BackgroundColor3 = enabled and Color3.fromRGB(23, 16, 22) or COLORS.Background})
        local s = window:FindFirstChildOfClass("UIStroke")
        if s then tween(s, 0.2, {Thickness = enabled and 2.5 or 1.4, Color = enabled and COLORS.Red or COLORS.RedDark}) end
    end)
    addToggle("Sons da interface", "Ative/desative os sons configurados no topo do script.", "InterfaceSounds", true, function(enabled)
        _G.RangelHubSoundsEnabled = enabled
    end)
    addButton("Restaurar tema", "Volta às cores padrão preto e vermelho.", "ResetTheme", function()
        window.BackgroundColor3 = COLORS.Background
        local s = window:FindFirstChildOfClass("UIStroke")
        if s then s.Color = COLORS.RedDark; s.Thickness = 1.4 end
    end)
end)

addPage("Ferramentas", "⚙", "Ações de exemplo para conectar ao seu próprio projeto.", function()
    addButton("Notificação de teste", "Mostra uma mensagem dentro do painel.", "TestNotification", function()
        local toast = make("TextLabel", {
            AnchorPoint = Vector2.new(1, 1),
            Position = UDim2.new(1, -20, 1, -20),
            Size = UDim2.fromOffset(260, 52),
            BackgroundColor3 = COLORS.Panel2,
            BorderSizePixel = 0,
            Font = Enum.Font.GothamSemibold,
            Text = "  Rangel HUB  •  Tudo certo!",
            TextColor3 = COLORS.Text,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 20,
        }, gui)
        round(toast, 10); stroke(toast, COLORS.Red, 1)
        toast.Position = UDim2.new(1, 280, 1, -20)
        tween(toast, 0.25, {Position = UDim2.new(1, -20, 1, -20)})
        task.delay(2.5, function()
            if toast.Parent then
                tween(toast, 0.2, {Position = UDim2.new(1, 280, 1, -20)})
                task.delay(0.25, function() if toast.Parent then toast:Destroy() end end)
            end
        end)
    end)
    addButton("Recarregar página", "Reconstrói os cartões desta página.", "RefreshPage", function()
        local p = pages["Ferramentas"]
        clearCards()
        if p and p.build then p.build() end
    end)
end)

addPage("Configurações", "☷", "Controles gerais da interface.", function()
    addToggle("Abrir ao iniciar", "Define se o painel aparece ao carregar.", "ShowOnStart", true, function(v)
        _G.RangelHubShowOnStart = v
    end)
    addButton("Fechar painel", "Esconde a janela sem descarregar a interface.", "HidePanel", function()
        shade.Visible = false
        tween(scale, 0.18, {Scale = 0.88})
        task.delay(0.18, function() window.Visible = false end)
        playSound(CLOSE_SOUND_ID)
    end)
    addButton("Descarregar interface", "Remove o painel e seus elementos visuais.", "UnloadUI", function()
        gui:Destroy()
    end)
end)

local function setOpen(open)
    if not gui.Parent then return end
    if open then
        window.Visible = true
        shade.Visible = true
        shade.BackgroundTransparency = 1
        scale.Scale = 0.88
        window.Position = UDim2.fromScale(0.5, 0.53)
        tween(shade, 0.18, {BackgroundTransparency = 0.48})
        tween(scale, 0.24, {Scale = 1})
        tween(window, 0.24, {Position = UDim2.fromScale(0.5, 0.5)})
        playSound(OPEN_SOUND_ID)
    else
        tween(shade, 0.16, {BackgroundTransparency = 1})
        tween(scale, 0.16, {Scale = 0.9})
        playSound(CLOSE_SOUND_ID)
        task.delay(0.17, function()
            if gui.Parent then
                window.Visible = false
                shade.Visible = false
            end
        end)
    end
end

local isOpen = true
closeButton.Activated:Connect(function()
    isOpen = false
    setOpen(false)
    task.delay(0.18, function()
        if gui.Parent then mini.Visible = true end
    end)
end)

local mini = make("TextButton", {
    Name = "RangelHubMiniButton",
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 18, 0.5, 0),
    Size = UDim2.fromOffset(52, 52),
    BackgroundColor3 = COLORS.Panel,
    BorderSizePixel = 0,
    Text = "R",
    TextColor3 = COLORS.Red,
    Font = Enum.Font.GothamBlack,
    TextSize = 26,
    AutoButtonColor = false,
    Visible = false,
}, gui)
round(mini, 18)
stroke(mini, COLORS.Red, 1.5)

mini.Activated:Connect(function()
    isOpen = true
    setOpen(true)
end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        isOpen = not isOpen
        if isOpen then
            mini.Visible = false
            setOpen(true)
        else
            setOpen(false)
            task.delay(0.18, function()
                if gui.Parent then mini.Visible = true end
            end)
        end
    end
end)

-- Arrastar a janela pela barra superior (mouse e toque).
do
    local dragging = false
    local dragInput, dragStart, startPosition
    top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    top.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            window.Position = UDim2.new(
                startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

-- Começa na página inicial.
pages["Início"].button:Activate()
print("[Rangel HUB] Interface carregada. RightShift abre/fecha o painel.")
