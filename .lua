-- Lâm Vĩ Misc UI™ v1.0 (Loadstring-ready)
-- Features:
--  - Toggle black circular button (left middle)
--  - Glassy gray translucent main panel, draggable
--  - Fade + slight slide when open/close
--  - Close (X) button top-right
--  - 3 buttons: Giảm Lag / Shader / Các câu nói hay
--  - Each button runs a loadstring from a URL (placeholders)
--  - Loading spinner (rotating char) + "Đang xử lý..." -> "Hoàn tất ✅"
-- USAGE: replace URL_* with your raw URLs, then run in exploit. Test on alt account.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- cleanup old
local EXIST = PlayerGui:FindFirstChild("LamViMiscGui_v1")
if EXIST then EXIST:Destroy() end

local function new(class, props)
    local o = Instance.new(class)
    props = props or {}
    for k,v in pairs(props) do
        if k == "Parent" then o.Parent = v else o[k] = v end
    end
    return o
end

-- ROOT
local screenGui = new("ScreenGui", {Name = "LamViMiscGui_v1", Parent = PlayerGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
screenGui.ResetOnSpawn = false

-- Toggle button (black, left middle)
local toggle = new("TextButton", {
    Name = "ToggleBtn",
    Parent = screenGui,
    Size = UDim2.new(0,50,0,50),
    Position = UDim2.new(0,8,0.5,-25),
    BackgroundColor3 = Color3.fromRGB(10,10,10),
    Text = "",
    AutoButtonColor = true,
    ZIndex = 100
})
new("UICorner", {Parent = toggle, CornerRadius = UDim.new(1,0)})
new("UIStroke", {Parent = toggle, Thickness = 1, Color = Color3.fromRGB(150,150,150)})

-- MAIN FRAME
local main = new("Frame", {
    Name = "MainFrame",
    Parent = screenGui,
    Size = UDim2.new(0,480,0,280),
    Position = UDim2.new(0.1,0,0.28,0),
    BackgroundColor3 = Color3.fromRGB(30,30,30),
    BackgroundTransparency = 0.6,
    Active = true,
    Visible = true,
    ZIndex = 90
})
new("UICorner", {Parent = main, CornerRadius = UDim.new(0,16)})
new("UIStroke", {Parent = main, Thickness = 1, Color = Color3.fromRGB(190,190,190), Transparency = 0.75})

-- subtle inner overlay to mimic glass
local overlay = new("Frame", {
    Parent = main,
    Size = UDim2.new(1,0,1,0),
    Position = UDim2.new(0,0,0,0),
    BackgroundColor3 = Color3.fromRGB(40,40,40),
    BackgroundTransparency = 0.75,
    ZIndex = 91
})
new("UICorner", {Parent = overlay, CornerRadius = UDim.new(0,16)})

-- Header + Close
local header = new("TextLabel", {
    Parent = main,
    Size = UDim2.new(1,-24,0,36),
    Position = UDim2.new(0,12,0,8),
    BackgroundTransparency = 1,
    Text = "Lâm Vĩ Hub™ — Misc",
    TextColor3 = Color3.fromRGB(240,240,240),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 92
})

local closeBtn = new("TextButton", {
    Parent = main,
    Size = UDim2.new(0,36,0,36),
    Position = UDim2.new(1,-48,0,8),
    AnchorPoint = Vector2.new(0,0),
    Text = "X",
    BackgroundColor3 = Color3.fromRGB(20,20,20),
    TextColor3 = Color3.fromRGB(240,240,240),
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    ZIndex = 92,
    AutoButtonColor = true
})
new("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = closeBtn, Color = Color3.fromRGB(150,150,150), Transparency = 0.8})

-- Content area
local content = new("Frame", {
    Parent = main,
    Size = UDim2.new(1,-24,1,-64),
    Position = UDim2.new(0,12,0,48),
    BackgroundTransparency = 1,
    ZIndex = 92
})

local layout = new("UIListLayout", {Parent = content, Padding = UDim.new(0,12), FillDirection = Enum.FillDirection.Vertical})
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- Button factory
local function makeBtn(text)
    local b = new("TextButton", {
        Parent = content,
        Size = UDim2.new(0.94, 0, 0, 48),
        BackgroundColor3 = Color3.fromRGB(36,36,36),
        TextColor3 = Color3.fromRGB(240,240,240),
        Font = Enum.Font.Gotham,
        TextSize = 16,
        Text = text,
        AutoButtonColor = true,
        ZIndex = 93
    })
    new("UICorner", {Parent = b, CornerRadius = UDim.new(0,10)})
    local stroke = new("UIStroke", {Parent = b, Color = Color3.fromRGB(150,150,150), Transparency = 0.85, Thickness = 1})
    -- hover glow
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.4}):Play()
    end)
    return b
end

local btnLag = makeBtn("1. Giảm Lag")
local btnShader = makeBtn("2. Shader")
local btnQuotes = makeBtn("3. Các câu nói hay")

-- Loading overlay (inside main, centered)
local loader = new("Frame", {
    Parent = main,
    Size = UDim2.new(0,180,0,60),
    Position = UDim2.new(0.5,-90,0.5,-30),
    BackgroundColor3 = Color3.fromRGB(22,22,22),
    BackgroundTransparency = 0.15,
    Visible = false,
    ZIndex = 200
})
new("UICorner", {Parent = loader, CornerRadius = UDim.new(0,10)})
new("UIStroke", {Parent = loader, Color = Color3.fromRGB(150,150,150), Transparency = 0.8, Thickness = 1})

local spinner = new("TextLabel", {
    Parent = loader,
    Size = UDim2.new(0,28,0,28),
    Position = UDim2.new(0,8,0.5,-14),
    BackgroundTransparency = 1,
    Text = "⟳",
    Font = Enum.Font.GothamBold,
    TextSize = 24,
    TextColor3 = Color3.fromRGB(200,200,200),
    ZIndex = 201
})

local loadText = new("TextLabel", {
    Parent = loader,
    Size = UDim2.new(1,-48,1,0),
    Position = UDim2.new(0,44,0,0),
    BackgroundTransparency = 1,
    Text = "Đang xử lý...",
    Font = Enum.Font.Gotham,
    TextSize = 14,
    TextColor3 = Color3.fromRGB(230,230,230),
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 201
})

-- spinner control
local spinning = false
local spinConn
local function startSpinner()
    if spinning then return end
    spinning = true
    spinner.Rotation = 0
    spinConn = RunService.RenderStepped:Connect(function(dt)
        spinner.Rotation = (spinner.Rotation + 480 * dt) % 360 -- fast spin
    end)
end
local function stopSpinner()
    if spinConn then spinConn:Disconnect() spinConn = nil end
    spinning = false
    spinner.Rotation = 0
end

-- placeholder URLs - replace with raw links
local URL_LAGFIX   = "https://raw.githubusercontent.com/Luongdaynetroi/Free/refs/heads/main/FixLag/roblox/.lua"
local URL_SHADER   = "https://raw.githubusercontent.com/Luongdaynetroi/shaderfl/refs/heads/main/mini.lua"
local URL_QUOTES   = "https://raw.githubusercontent.com/Luongdaynetroi/Testscript/refs/heads/main/.lua"

-- notifier (SetCore safe pcall)
local function notify(msg, t)
    t = t or 2
    pcall(function()
        if game:GetService("StarterGui").SetCore then
            game:GetService("StarterGui"):SetCore("SendNotification", {Title = "Lâm Vĩ Hub", Text = msg, Duration = t})
        end
    end)
end

-- safe http get
local function httpGet(url)
    local ok, body = pcall(function()
        if syn and syn.request then
            local r = syn.request({Url = url, Method = "GET"})
            return r.Body
        elseif http_request then
            local r = http_request({Url = url, Method = "GET"})
            return r.Body
        else
            return game:HttpGet(url)
        end
    end)
    if ok then return body end
    return nil
end

-- loader with UI feedback
local function runURL(url)
    if not url or url == "" then
        notify("URL chưa setup!", 2)
        return
    end
    loader.Visible = true
    startSpinner()
    loadText.Text = "Đang xử lý..."
    -- small fake delay for UX
    local body = httpGet(url)
    if not body then
        loadText.Text = "Lấy script thất bại"
        wait(1.2)
        stopSpinner()
        loader.Visible = false
        return
    end
    -- try execute
    local ok, err = pcall(function()
        local f, e = loadstring(body)
        if not f then error(e) end
        f()
    end)
    if ok then
        loadText.Text = "Hoàn tất ✅"
    else
        loadText.Text = "Lỗi: "..tostring(err)
    end
    wait(1.2)
    stopSpinner()
    loader.Visible = false
end

-- connect buttons
btnLag.MouseButton1Click:Connect(function()
    notify("Đang load Giảm Lag...", 1.5)
    spawn(function() runURL(URL_LAGFIX) end)
end)
btnShader.MouseButton1Click:Connect(function()
    notify("Đang load Shader...", 1.5)
    spawn(function() runURL(URL_SHADER) end)
end)
btnQuotes.MouseButton1Click:Connect(function()
    notify("Đang load Quotes...", 1.5)
    spawn(function() runURL(URL_QUOTES) end)
end)

-- close behavior
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(main, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
    TweenService:Create(main, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {Position = UDim2.new(-0.8,0, main.Position.Y.Scale, main.Position.Y.Offset)}):Play()
    delay(0.22, function() main.Visible = false end)
end)

-- open/close via toggle (fade + slide)
local isOpen = true
local openPos = main.Position
local closedPos = UDim2.new(-0.8,0, main.Position.Y.Scale, main.Position.Y.Offset)
local function openUI()
    main.Visible = true
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart), {Position = openPos, BackgroundTransparency = 0.6}):Play()
    isOpen = true
end
local function closeUI()
    TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quart), {Position = closedPos, BackgroundTransparency = 1}):Play()
    delay(0.28, function() if not isOpen then main.Visible = false end end)
    isOpen = false
end

toggle.MouseButton1Click:Connect(function()
    if isOpen then
        isOpen = false
        closeUI()
    else
        isOpen = true
        openUI()
    end
end)

-- draggable main
local dragging, dragInput, dragStart, startPos
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = inp.Position
        startPos = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
main.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = inp
    end
end)
UserInputService.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local delta = inp.Position - dragStart
        main.Position = startPos + UDim2.new(0, delta.X, 0, delta.Y)
        openPos = main.Position -- remember last pos for reopen
    end
end)

-- initial open animation
main.Position = closedPos
openUI()

print("[Lâm Vĩ Misc UI v1.0] loaded. Remember to replace URL_* placeholders with your raw script URLs.")
