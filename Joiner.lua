-- ===================================
-- SK JOINER V4 - ULTRA OTIMIZADO + HEX DECODER
-- 0 Delay + Auto ReconexÃ£o + SeguranÃ§a HEX
-- ===================================

-- ===================================
-- DECODIFICADOR HEX
-- ===================================
local function fromHex(hex)
    if not hex or hex == "" then return "" end
    
    local str = ""
    local ok, result = pcall(function()
        for i = 1, #hex, 2 do
            local byte = tonumber(hex:sub(i, i+1), 16)
            if byte then
                str = str .. string.char(byte)
            end
        end
        return str
    end)
    
    return ok and result or hex
end

local base64Decode = function(data)
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- ===================================
-- DETECTAR EXECUTOR
-- ===================================
local function detectExecutor()
    local name = "Unknown"
    
    if identifyexecutor then
        local ok, result = pcall(identifyexecutor)
        if ok and result then name = tostring(result):lower() end
    elseif getexecutorname then
        local ok, result = pcall(getexecutorname)
        if ok and result then name = tostring(result):lower() end
    end
    
    local isMobile = name:find("delta") or name:find("codex") or name:find("fluxus android")
    return isMobile and "MOBILE" or "PC", name
end

local execType, execName = detectExecutor()
print("ðŸ” Executor: " .. execType .. " (" .. execName .. ")")

-- ===================================
-- HTTP REQUEST UNIVERSAL
-- ===================================
local http_request = nil

local methods = {
    function() return syn and syn.request end,
    function() return request end,
    function() return http and http.request end,
    function() return http_request end
}

for _, method in ipairs(methods) do
    local ok, func = pcall(method)
    if ok and func and type(func) == "function" then
        http_request = func
        break
    end
end

if not http_request then
    http_request = function(opts)
        if opts.Method == "GET" then
            local s, r = pcall(game.HttpGet, game, opts.Url)
            return s and {StatusCode=200, Body=r} or {StatusCode=500, Body=""}
        elseif opts.Method == "POST" then
            local s, r = pcall(game.HttpPost, game, opts.Url, opts.Body or "", true, "application/json")
            return s and {StatusCode=200, Body=r} or {StatusCode=500, Body=""}
        end
        return {StatusCode=500, Body=""}
    end
end

print("âœ… HTTP configurado")

-- ===================================
-- WEBSOCKET COMPATÃVEL
-- ===================================
local WebSocketLib = nil

if WebSocket and WebSocket.connect then
    WebSocketLib = WebSocket
    print("âœ… WebSocket nativo (Mobile)")
elseif syn and syn.websocket and syn.websocket.connect then
    WebSocketLib = {
        connect = function(url)
            return syn.websocket.connect(url)
        end
    }
    print("âœ… syn.websocket (PC)")
elseif websocket and websocket.connect then
    WebSocketLib = websocket
    print("âœ… websocket global (PC)")
else
    warn("âš ï¸ WebSocket nÃ£o disponÃ­vel - Modo polling")
end

local wsUrl = base64Decode("d3NzOi8vYW5hcnF1aWNvaXNsdWF1LmRpc2Nsb3VkLmFwcC9hcGkvanNvbnM=")

-- ===================================
-- CONSTANTES
-- ===================================
local MINIMUM_PATCH_VALUE = 10000000
local POLL_INTERVAL = 2
local MAX_NOTIFICATIONS = 5
local RECONNECT_DELAY = 3
local HEARTBEAT_INTERVAL = 30

-- ===================================
-- SERVIÃ‡OS
-- ===================================
local plrs = game:GetService("Players")
local http = game:GetService("HttpService")
local cg = game:GetService("CoreGui")
local tp = game:GetService("TeleportService")
local uis = game:GetService("UserInputService")
local ts = game:GetService("TweenService")

-- ===================================
-- SISTEMA DE SAVE
-- ===================================
local saveFile = "SKJoiner.dat"

local function save(minVal, pos, notif)
    local data = {m=minVal, x=pos.X.Offset, y=pos.Y.Offset, n=notif}
    if writefile then
        pcall(writefile, saveFile, http:JSONEncode(data))
    end
end

local function load()
    if isfile and isfile(saveFile) and readfile then
        local ok, data = pcall(function()
            return http:JSONDecode(readfile(saveFile))
        end)
        if ok and data then
            return {minValue=data.m or 0, hubPositionX=data.x or 0, hubPositionY=data.y or 0, notificationsEnabled=data.n or true}
        end
    end
    return {minValue=0, hubPositionX=0, hubPositionY=0, notificationsEnabled=true}
end

-- ===================================
-- VARIÃVEIS GLOBAIS
-- ===================================
local cfg = load()
local running = false
local notifEnabled = cfg.notificationsEnabled
local ws, wsConnected = nil, false
local minVal = cfg.minValue
local placeId = game.PlaceId
local localPlayer = plrs.LocalPlayer
local pollingActive = false
local reconnectThread = nil
local heartbeatThread = nil
local shouldBeConnected = false

-- ===================================
-- PARSE OTIMIZADO
-- ===================================
local multipliers = {T=1e12, B=1e9, M=1e6, K=1e3}

local function parseVal(v)
    if type(v) == "number" then return v end
    if not v or v == "" then return 0 end
    
    local str = tostring(v):upper():gsub("[%s$]", "")
    local num = tonumber(str:match("^([%d%.]+)"))
    if not num then return 0 end
    
    for suffix, mult in pairs(multipliers) do
        if str:find(suffix) then return num * mult end
    end
    return num
end

local function formatVal(n)
    if not n or n == 0 then return "$0" end
    if n >= 1e12 then return string.format("$%.1fT", n/1e12)
    elseif n >= 1e9 then return string.format("$%.1fB", n/1e9)
    elseif n >= 1e6 then return string.format("$%.1fM", n/1e6)
    elseif n >= 1e3 then return string.format("$%.1fK", n/1e3)
    else return string.format("$%d", math.floor(n)) end
end

-- ===================================
-- UI
-- ===================================
local sg = Instance.new("ScreenGui")
sg.Name = "SKUI_"..math.random(1e4,9e4)
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset = true

for _, g in ipairs(cg:GetChildren()) do
    if g.Name:match("SKUI_") then g:Destroy() end
end

sg.Parent = cg

-- NotificaÃ§Ãµes com limite
local notifCont = Instance.new("Frame")
notifCont.Name = "NC"
notifCont.Size = UDim2.new(0,280,0,300)
notifCont.Position = UDim2.new(0.5,-140,0,50)
notifCont.BackgroundTransparency = 1
notifCont.ClipsDescendants = false
notifCont.ZIndex = 100
notifCont.Parent = sg

local notifLayout = Instance.new("UIListLayout")
notifLayout.Padding = UDim.new(0,8)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.Parent = notifCont

local activeNotifications = {}

local function removeOldestNotification()
    if #activeNotifications > 0 then
        local oldest = table.remove(activeNotifications, 1)
        if oldest and oldest.Parent then
            ts:Create(oldest, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency=1}):Play()
            task.delay(0.2, function()
                if oldest.Parent then oldest:Destroy() end
            end)
        end
    end
end

local function notify(name, value, sid)
    if not notifEnabled then return end
    
    if #activeNotifications >= MAX_NOTIFICATIONS then
        removeOldestNotification()
    end
    
    local n = Instance.new("Frame")
    n.Name = "N"..tick()
    n.Size = UDim2.new(0,280,0,0)
    n.BackgroundColor3 = Color3.fromRGB(20,20,25)
    n.BackgroundTransparency = 0.05
    n.BorderSizePixel = 0
    n.ZIndex = 101
    n.LayoutOrder = #activeNotifications + 1
    n.Parent = notifCont
    
    table.insert(activeNotifications, n)
    
    local corner = Instance.new("UICorner", n)
    corner.CornerRadius = UDim.new(0,8)
    
    local stroke = Instance.new("UIStroke", n)
    stroke.Color = Color3.fromRGB(200,40,50)
    stroke.Thickness = 1.5
    
    local content = Instance.new("Frame", n)
    content.Size = UDim2.new(1,-16,1,0)
    content.Position = UDim2.new(0,8,0,0)
    content.BackgroundTransparency = 1
    content.ZIndex = 102
    
    local nameL = Instance.new("TextLabel", content)
    nameL.Size = UDim2.new(0.6,0,1,0)
    nameL.BackgroundTransparency = 1
    nameL.Font = Enum.Font.GothamBold
    nameL.Text = name
    nameL.TextColor3 = Color3.fromRGB(240,240,240)
    nameL.TextSize = 12
    nameL.TextXAlignment = Enum.TextXAlignment.Left
    nameL.TextTruncate = Enum.TextTruncate.AtEnd
    nameL.ZIndex = 103
    
    local valL = Instance.new("TextLabel", content)
    valL.Size = UDim2.new(0.4,0,1,0)
    valL.Position = UDim2.new(0.6,0,0,0)
    valL.BackgroundTransparency = 1
    valL.Font = Enum.Font.GothamBold
    valL.Text = value
    valL.TextColor3 = Color3.fromRGB(255,90,100)
    valL.TextSize = 12
    valL.TextXAlignment = Enum.TextXAlignment.Right
    valL.ZIndex = 103
    
    local btn = Instance.new("TextButton", n)
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 104
    
    btn.MouseButton1Click:Connect(function()
        if sid and sid ~= "" then
            pcall(function()
                tp:TeleportToPlaceInstance(placeId, sid, localPlayer)
            end)
        end
    end)
    
    task.spawn(function()
        n:TweenSize(UDim2.new(0,280,0,36), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
        task.wait(7)
        
        for i, notif in ipairs(activeNotifications) do
            if notif == n then
                table.remove(activeNotifications, i)
                break
            end
        end
        
        ts:Create(n, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency=1}):Play()
        task.wait(0.3)
        if n.Parent then n:Destroy() end
    end)
end

-- ===================================
-- HUB
-- ===================================
local hub = Instance.new("Frame")
hub.Size = UDim2.new(0,180,0,140)

if cfg.hubPositionX ~= 0 and cfg.hubPositionY ~= 0 then
    local vs = workspace.CurrentCamera.ViewportSize
    local px = math.clamp(cfg.hubPositionX, 10, vs.X-200)
    local py = math.clamp(cfg.hubPositionY, 10, vs.Y-160)
    hub.Position = UDim2.new(0, px, 0, py)
else
    hub.Position = UDim2.new(1,-200,0,20)
end

hub.BackgroundColor3 = Color3.fromRGB(15,15,20)
hub.BackgroundTransparency = 0.15
hub.BorderSizePixel = 0
hub.ZIndex = 10
hub.Active = true
hub.Parent = sg

local hubCorner = Instance.new("UICorner", hub)
hubCorner.CornerRadius = UDim.new(0,12)

local header = Instance.new("Frame", hub)
header.Size = UDim2.new(1,0,0,40)
header.BackgroundColor3 = Color3.fromRGB(10,10,15)
header.BorderSizePixel = 0
header.ZIndex = 11
header.Active = true

local headerCorner = Instance.new("UICorner", header)
headerCorner.CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Text = "SK JOINER"
title.TextColor3 = Color3.fromRGB(220,20,30)
title.TextSize = 18
title.ZIndex = 12

-- Drag
local dragging, mousePos, framePos = false, nil, nil

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        mousePos = input.Position
        framePos = hub.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                save(minVal, hub.Position, notifEnabled)
            end
        end)
    end
end)

uis.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - mousePos
        hub.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
    end
end)

-- Criar toggle
local function createToggle(parent, posY, label, state)
    local cont = Instance.new("Frame", parent)
    cont.Size = UDim2.new(1,-20,0,40)
    cont.Position = UDim2.new(0,10,0,posY)
    cont.BackgroundColor3 = Color3.fromRGB(25,25,30)
    cont.BorderSizePixel = 0
    cont.ZIndex = 11
    
    Instance.new("UICorner", cont).CornerRadius = UDim.new(0,8)
    
    if label then
        local lbl = Instance.new("TextLabel", cont)
        lbl.Size = UDim2.new(0.5,0,1,0)
        lbl.Position = UDim2.new(0,5,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamMedium
        lbl.Text = label
        lbl.TextColor3 = Color3.fromRGB(200,200,200)
        lbl.TextSize = 14
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.ZIndex = 12
    end
    
    local btn = Instance.new("TextButton", cont)
    btn.Size = UDim2.new(0,60,0,30)
    btn.Position = UDim2.new(1,-70,0.5,-15)
    btn.BackgroundColor3 = state and Color3.fromRGB(220,20,30) or Color3.fromRGB(40,40,45)
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 12
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1,0)
    
    local circle = Instance.new("Frame", btn)
    circle.Size = UDim2.new(0,24,0,24)
    circle.Position = state and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12)
    circle.BackgroundColor3 = state and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,150)
    circle.BorderSizePixel = 0
    circle.ZIndex = 13
    
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1,0)
    
    return cont, btn, circle
end

-- OpÃ§Ã£o 1: Auto Joiner
local opt1, btn1, circle1 = createToggle(hub, 50, nil, running)

local input = Instance.new("TextBox", opt1)
input.Size = UDim2.new(0,70,0,30)
input.Position = UDim2.new(0,5,0.5,-15)
input.BackgroundColor3 = Color3.fromRGB(35,35,40)
input.BorderSizePixel = 0
input.Font = Enum.Font.GothamMedium
input.Text = formatVal(minVal)
input.TextColor3 = Color3.fromRGB(255,255,255)
input.TextSize = 13
input.TextXAlignment = Enum.TextXAlignment.Center
input.PlaceholderText = "$0"
input.ClearTextOnFocus = false
input.ZIndex = 12

Instance.new("UICorner", input).CornerRadius = UDim.new(0,6)

input.FocusLost:Connect(function()
    local newVal = parseVal(input.Text)
    if newVal >= 0 then
        minVal = newVal
        input.Text = formatVal(minVal)
        save(minVal, hub.Position, notifEnabled)
    else
        input.Text = formatVal(minVal)
    end
end)

-- OpÃ§Ã£o 2: NotificaÃ§Ãµes
local opt2, btn2, circle2 = createToggle(hub, 95, "Notifs", notifEnabled)

-- ===================================
-- PROCESSAMENTO INSTANTÃ‚NEO COM HEX (0 DELAY)
-- ===================================
local processedIds = {}
local maxCacheSize = 100

local function processData(data)
    local name, value, sidHex
    
    if data.type == "event" and data.payload then
        local p = data.payload
        name = p.brainrotName or "Unknown"
        value = p.patchValue
        sidHex = p.serverId -- RECEBE HEX
    elseif data.type == "brainrot_found" then
        name = data.name or "Unknown"
        value = data.value
        sidHex = data.jobId -- RECEBE HEX
    else
        return
    end
    
    if not name or not value or name == "Unknown" or not sidHex then return end
    
    -- DECODIFICAR HEX PARA JOBID REAL
    local sid = fromHex(sidHex)
    
    if not sid or sid == "" then return end
    
    -- Evitar duplicatas
    if processedIds[sid] then return end
    processedIds[sid] = true
    
    -- Limpar cache
    local count = 0
    for _ in pairs(processedIds) do count = count + 1 end
    if count > maxCacheSize then
        local toRemove = {}
        local i = 0
        for id in pairs(processedIds) do
            i = i + 1
            if i > maxCacheSize / 2 then break end
            table.insert(toRemove, id)
        end
        for _, id in ipairs(toRemove) do
            processedIds[id] = nil
        end
    end
    
    local numVal = type(value) == "number" and value or parseVal(value)
    
    if numVal < MINIMUM_PATCH_VALUE then return end
    
    local fval = formatVal(numVal)
    
    -- NotificaÃ§Ã£o instantÃ¢nea
    if notifEnabled then
        notify(name, fval, sid)
    end
    
    -- Auto join instantÃ¢neo
    if running and numVal >= minVal and minVal > 0 then
        task.spawn(function()
            local ok = pcall(function()
                tp:TeleportToPlaceInstance(placeId, sid, localPlayer)
            end)
            if ok then
                print("âœ… Entrando: " .. name .. " - " .. fval)
            end
        end)
    end
end

-- ===================================
-- WEBSOCKET COM RECONEXÃƒO AUTOMÃTICA
-- ===================================
local function stopHeartbeat()
    if heartbeatThread then
        task.cancel(heartbeatThread)
        heartbeatThread = nil
    end
end

local function startHeartbeat()
    stopHeartbeat()
    
    if not ws or not wsConnected then return end
    
    heartbeatThread = task.spawn(function()
        while wsConnected and shouldBeConnected do
            task.wait(HEARTBEAT_INTERVAL)
            
            if ws and wsConnected then
                local ok = pcall(function()
                    ws:Send(http:JSONEncode({type="ping"}))
                end)
                
                if not ok then
                    warn("âš ï¸ Heartbeat falhou - reconectando...")
                    wsConnected = false
                end
            end
        end
    end)
end

local function connectWS()
    if not shouldBeConnected then return end
    if wsConnected then return end
    
    if not WebSocketLib then
        warn("âš ï¸ WebSocket indisponÃ­vel")
        return
    end
    
    task.spawn(function()
        local ok, result = pcall(function()
            return WebSocketLib.connect(wsUrl)
        end)
        
        if not ok or not result then
            warn("âŒ WebSocket falhou")
            return
        end
        
        ws = result
        wsConnected = true
        print("âœ… WebSocket conectado + HEX Decoder!")
        
        startHeartbeat()
        
        -- PROCESSA MENSAGENS INSTANTANEAMENTE
        ws.OnMessage:Connect(function(msg)
            local ok, data = pcall(function()
                return http:JSONDecode(msg)
            end)
            
            if ok and data then
                processData(data)
            end
        end)
        
        ws.OnClose:Connect(function()
            wsConnected = false
            stopHeartbeat()
            warn("âš ï¸ WebSocket fechado")
            
            if shouldBeConnected then
                print("ðŸ”„ Reconectando em " .. RECONNECT_DELAY .. "s...")
                task.wait(RECONNECT_DELAY)
                connectWS()
            end
        end)
    end)
end

local function disconnectWS()
    shouldBeConnected = false
    stopHeartbeat()
    
    if ws then
        pcall(function() ws:Close() end)
        ws = nil
    end
    
    wsConnected = false
    print("ðŸ”Œ Desconectado")
end

-- ===================================
-- EVENTOS DOS BOTÃ•ES
-- ===================================
btn1.MouseButton1Click:Connect(function()
    running = not running
    
    btn1.BackgroundColor3 = running and Color3.fromRGB(220,20,30) or Color3.fromRGB(40,40,45)
    circle1.BackgroundColor3 = running and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,150)
    circle1:TweenPosition(running and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    
    if running then
        shouldBeConnected = true
        connectWS()
    else
        if not notifEnabled then
            disconnectWS()
        end
    end
end)

btn2.MouseButton1Click:Connect(function()
    notifEnabled = not notifEnabled
    
    btn2.BackgroundColor3 = notifEnabled and Color3.fromRGB(220,20,30) or Color3.fromRGB(40,40,45)
    circle2.BackgroundColor3 = notifEnabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(150,150,150)
    circle2:TweenPosition(notifEnabled and UDim2.new(1,-27,0.5,-12) or UDim2.new(0,3,0.5,-12), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.2, true)
    
    if notifEnabled then
        shouldBeConnected = true
        connectWS()
    else
        if not running then
            disconnectWS()
        end
    end
    
    save(minVal, hub.Position, notifEnabled)
end)

-- ===================================
-- LIMPEZA AO SAIR
-- ===================================
game:GetService("Players").PlayerRemoving:Connect(function(p)
    if p == localPlayer then
        disconnectWS()
    end
end)

-- ===================================
-- INICIALIZAÃ‡ÃƒO
-- ===================================
if notifEnabled or running then
    shouldBeConnected = true
    connectWS()
end

print("âœ… SK JOINER V4 ULTRA [0 DELAY | HEX SECURITY | AUTO RECONEXÃƒO]")
