-- â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
-- â•‘         Laced Notifier  V2               â•‘
-- â•‘   Steal a Brainrot  â€¢  Auto Joiner       â•‘
-- â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

local HttpService     = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players         = game:GetService("Players")
local CoreGui         = game:GetService("CoreGui")
local TweenService    = game:GetService("TweenService")
local UIS             = game:GetService("UserInputService")
local SoundService    = game:GetService("SoundService")

local WS_URL    = "wss://ws1.burgerharbor.uk/?token=ceMhY2gpBs%2BjzcJRLLffGEIXV%2B4O4VIcV6q%2BsL1TEeBkmc6MGWdTd2YivYEF7y9B"
local PLACE_ID  = 109983668079237
local SAVE_FILE = "LacedNotifierV2.json"
local SOUND_ID  = 139308638407157

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- SOUND PLAYER
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function playNotificationSound()
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://" .. SOUND_ID
    sound.Volume = 0.5
    sound.Parent = SoundService
    sound:Play()
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
    task.delay(5, function()
        if sound and sound.Parent then sound:Destroy() end
    end)
end

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- BRAINROT LIST
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local ALL_BRAINROTS = {
    "Noobini Pizzanini","Lirili Larila","Tim Cheese","FluriFlura","Talpa Di Fero",
    "Svinina Bombardino","Pipi Kiwi","Racooni Jandelini","Pipi Corni","Noobini Santanini",
    "Trippi Troppi","Gangster Footera","Bandito Bobritto","Boneca Ambalabu",
    "Cacto Hipopotamo","Ta Ta Ta Ta Sahur","Tric Trac Baraboom","Pipi Avocado","Frogo Elfo",
    "Cappuccino Assassino","Brr Brr Patapim","Trulimero Trulicina","Bambini Crostini",
    "Bananita Dolphinita","Perochello Lemonchello","Brri Brri Bicus Dicus Bombicus",
    "Avocadini Guffo","Salamino Penguino","Ti Ti Ti Sahur","Penguin Tree","Penguino Cocosino",
    "Burbaloni Loliloli","Chimpazini Bananini","Ballerina Cappuccina","Chef Crabracadabra",
    "Lionel Cactuseli","Glorbo Fruttodrillo","Blueberrini Octopusini","Strawberelli Flamingelli",
    "Pandaccini Bananini","Cocosini Mama","Sigma Boy","Sigma Girl","Pi Pi Watermelon",
    "Chocco Bunny","Sealo Regalo",
    "Frigo Camelo","Orangutini Ananassini","Rhino Toasterino","Bombardiro Crocodilo",
    "Bombombini Gusini","Cavallo Virtuso","Gorillo Watermelondrillo","Avocadorilla",
    "Tob Tobi Tobi","Ganganzelli Trulala","Cachorrito Melonito","Elefanto Frigo",
    "Toiletto Focaccino","Te Te Te Sahur","Tracoducotulu Delapeladustuz","Lerulerulerule",
    "Jingle Jingle Sahur","Tree Tree Tree Sahur","Carloo","Spioniro Golubiro",
    "Zibra Zubra Zibralini","Tigrilini Watermelini","Carrotini Brainini","Bananito Bandito",
    "Coco Elefanto","Girafa Celestre","Gattatino Nyanino","Chihuanini Taconini","Matteo",
    "Tralalero Tralala","Espresso Signora","Odin Din Din Dun","Statutino Libertino",
    "Trenostruzzo Turbo 3000","Ballerino Lololo","Los Orcalitos","Dug dug dug",
    "Tralalita Tralala","Urubini Flamenguini","Los Bombinitos","Trigoligre Frutonni",
    "Orcalero Orcala","Bulbito Bandito Traktorito","Los Crocodillitos","Piccione Macchina",
    "Trippi Troppi Troppa Trippa","Los Tungtungtungcitos","Tukanno Bananno","Alessio",
    "Tipi Topi Taco","Extinct Ballerina","Capi Taco","Gattito Tacoto","Pakrahmatmamat",
    "Tractoro Dinosauro","Corn Corn Corn Sahur","Squalanana","Los Tipi Tacos",
    "Bombardini Tortinii","Pop pop Sahur","Ballerina Peppermintina","Yeti Claus",
    "Ginger Globo","Frio Ninja","Ginger Cisterna","Cacasito Satalito","Aquanaut",
    "Tartaruga Cisterna",
    "Las Sis","La Vacca Staturno Saturnita","Chimpanzini Spiderini","Extinct Tralalero",
    "Extinct Matteo","Los Tralaleritos","La Karkerkar Kombinasin","Karker Sahur",
    "Las Tralaleritas","Job Job Job Sahur","Los Spyderrinis","Perrito Burrito",
    "Graipuss Medussi","Los Jobcitos","La Grande Kombinasin","Tacorita Bicicleta",
    "Nuclearo Dinossauro","Los 67","Money Money Puggy","Chillin Chili","La Extinct Grande",
    "Los Tacoritas","Los Tortus","Tang Tang Kelentang","Garama and Madundung",
    "La Secret Kombinasin","Torrtuginni Dragonfruitini","Pot Hotspot","To to to Sahur",
    "Las Vaquitas Saturnitas","Chicleteira Bicicleteira","Agarrini la Palini",
    "Mariachi Corazoni","Dragon Cannelloni","Los Kombinasinas","La Cucaracha",
    "Karkerkar Kurkur","Los Hotspotsitos","La Sahur Kombinasin","Quesadilla Crocodila",
    "Esok Sekolah","Los Matteos","Dul Dul Dul","Blackhole Goat","Nooo My Hotspot",
    "Sammyini Spyderini","Spaghetti Tualetti","67","Los Noo My Hotspotsitos",
    "Celularcini Viciosini","Tralaledon","Tictac Sahur","La Supreme Kombinasin",
    "Ketupat Kepat","Ketchuru and Musturu","Burguro and Fryuro","Please my Present",
    "La Grande","La Vacca Prese Presente","Ho Ho Ho Sahur","Chicleteira Noelteira",
    "Cooki and Milki","La Jolly Grande","Capitano Moby","Cerberus",
    "Skibidi Toilet","Strawberry Elephant","Meowl",
}

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- CONFIG
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local cfg = {
    autoJoin         = false, -- OFF by default
    toastEnabled     = true,
    minMoneyIndex    = 1,
    retryIndex       = 2,
    whitelistEnabled = false,
    whitelist        = {},
    startMinimized   = false, -- Start minimized when executing
}

local moneyOptions = {
    {label="None", value=0},
    {label="10M",  value=10000000},
    {label="20M",  value=20000000},
    {label="30M",  value=30000000},
    {label="40M",  value=40000000},
    {label="50M",  value=50000000},
    {label="100M", value=100000000},
}
local retryOptions = {1,3,5,10,20}

local function saveConfig()
    pcall(function()
        writefile(SAVE_FILE, HttpService:JSONEncode(cfg))
    end)
end

local function loadConfig()
    local ok, data = pcall(function()
        if isfile and isfile(SAVE_FILE) then
            return HttpService:JSONDecode(readfile(SAVE_FILE))
        end
    end)
    if ok and type(data) == "table" then
        for k,v in pairs(data) do 
            if k ~= "autoJoin" then -- Don't load autoJoin from saved config, force it to be false
                cfg[k] = v 
            end
        end
    end
end
loadConfig()
cfg.autoJoin = false -- FORCE auto join OFF regardless of saved config

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- HELPERS
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function fmtMoney(n)
    if n >= 1e9  then return string.format("$%.2fB", n/1e9)
    elseif n >= 1e6 then return string.format("$%.2fM", n/1e6)
    elseif n >= 1e3 then return string.format("$%.1fK", n/1e3)
    end
    return "$"..tostring(n)
end

local function getTS() return os.date("%H:%M:%S") end

local function namePassesWhitelist(name)
    if not cfg.whitelistEnabled or #cfg.whitelist == 0 then return true end
    local low = name:lower()
    for _, w in ipairs(cfg.whitelist) do
        if low:find(w:lower(), 1, true) then return true end
    end
    return false
end

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- DUAL FORMAT PARSER
-- Format A: { name, money, jobid, players, maxplayers }
-- Format B: base64 { name, money, job_id, players, player_limit, detected_pets }
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local function isBase64(s)
    if type(s) ~= "string" or #s == 0 then return false end
    if #s % 4 ~= 0 then return false end
    return s:match("^[A-Za-z0-9+/=]+$") ~= nil
end

local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function decodeB64(str)
    local lk = {}
    for i = 1, #b64 do lk[b64:sub(i,i)] = i-1 end
    lk["="] = 0
    local out = {}
    for i = 1, #str, 4 do
        local a,b,c,d = lk[str:sub(i,i)],lk[str:sub(i+1,i+1)],lk[str:sub(i+2,i+2)],lk[str:sub(i+3,i+3)]
        if a and b then
            table.insert(out, string.char(bit32.bor(bit32.lshift(a,2),bit32.rshift(b,4))))
        end
        if b and c and str:sub(i+2,i+2) ~= "=" then
            table.insert(out, string.char(bit32.band(bit32.bor(bit32.lshift(b,4),bit32.rshift(c,2)),0xFF)))
        end
        if c and d and str:sub(i+3,i+3) ~= "=" then
            table.insert(out, string.char(bit32.band(bit32.bor(bit32.lshift(c,6),d),0xFF)))
        end
    end
    return table.concat(out)
end

local function parseMsg(raw)
    if type(raw) ~= "string" then return nil end

    -- strip Python bytes wrapper
    local cleaned = raw
    if cleaned:sub(1,2) == "b'" or cleaned:sub(1,2) == 'b"' then
        cleaned = cleaned:sub(3,-2)
    end
    -- decode \xNN
    cleaned = cleaned:gsub("\\x(%x%x)", function(h)
        return string.char(tonumber(h,16))
    end)

    -- try base64 decode
    local jsonStr = cleaned
    local wasB64  = false
    if isBase64(cleaned) then
        local ok, dec = pcall(decodeB64, cleaned)
        if ok and type(dec) == "string" and dec:sub(1,1) == "{" then
            jsonStr = dec
            wasB64  = true
        end
    end

    -- parse JSON
    local ok, data = pcall(function() return HttpService:JSONDecode(jsonStr) end)
    if not ok or type(data) ~= "table" then return nil end

    local name, money, players, maxpl, jobId
    local wasB64Out = wasB64

    -- â”€â”€ Format C: new WS  { op="brainrot/sighting", data={ jobId, placeId, brainrots=[{name,value}] } }
    if data.op == "brainrot/sighting" and type(data.data) == "table" then
        local d = data.data
        jobId   = tostring(d.jobId or "")
        players = tonumber(d.players) or 0
        maxpl   = tonumber(d.playerLimit or d.player_limit or d.maxplayers) or 0

        -- build a display name and total value from brainrots array
        if type(d.brainrots) == "table" and #d.brainrots > 0 then
            -- pick highest value brainrot as the "name"
            local best = d.brainrots[1]
            for _, br in ipairs(d.brainrots) do
                if (tonumber(br.value) or 0) > (tonumber(best.value) or 0) then
                    best = br
                end
            end
            name  = tostring(best.brainrotName or best.name or "Unknown")
            money = tonumber(best.value) or 0

            -- append mutation tag if not Normal
            local mut = tostring(best.mutation or "Normal")
            if mut ~= "Normal" and mut ~= "" then
                name = name .. " [" .. mut .. "]"
            end

            -- if multiple brainrots, append count
            if #d.brainrots > 1 then
                name = name .. " +" .. (#d.brainrots - 1) .. " more"
            end
        else
            name  = "Unknown"
            money = 0
        end

    -- â”€â”€ Format A: original  { name, money, jobid, players, maxplayers }
    -- â”€â”€ Format B: base64    { name, money, job_id, players, player_limit, detected_pets }
    else
        name    = tostring(data.name or "Unknown")
        money   = tonumber(data.money) or 0
        players = tonumber(data.players) or 0
        jobId   = tostring(data.jobid or data.job_id or "")
        maxpl   = tonumber(data.maxplayers or data.player_limit) or 0

        if money == 0 and type(data.detected_pets) == "table" then
            for _, pet in ipairs(data.detected_pets) do
                local m = tonumber(pet.money)
                if m and m > money then money = m end
            end
        end

        -- strip leading emoji
        name = name:gsub("^[\xF0-\xF7][\x80-\xBF][\x80-\xBF][\x80-\xBF]%s*","")
                   :gsub("^[\xE0-\xEF][\x80-\xBF][\x80-\xBF]%s*","")
                   :match("^%s*(.-)%s*$")
    end

    if not jobId or jobId == "" then return nil end

    return {name=name, money=money, players=players, maxpl=maxpl, jobId=jobId, wasB64=wasB64Out}
end

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- COLOURS
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local C = {
    bg      = Color3.fromRGB(7,  6, 12),
    sidebar = Color3.fromRGB(10,  8, 18),
    card    = Color3.fromRGB(14, 11, 22),
    deep    = Color3.fromRGB(9,   7, 16),
    stroke  = Color3.fromRGB(28, 20, 52),
    a1      = Color3.fromRGB(108, 52,255),
    a2      = Color3.fromRGB( 52,118,255),
    a3      = Color3.fromRGB(178, 78,255),
    tPrim   = Color3.fromRGB(238,233,255),
    tSec    = Color3.fromRGB(108, 93,152),
    tMut    = Color3.fromRGB( 50, 42, 80),
    green   = Color3.fromRGB( 48,214,108),
    red     = Color3.fromRGB(255, 62, 72),
    yellow  = Color3.fromRGB(255,194, 48),
    gold    = Color3.fromRGB(255,198, 48),
    orange  = Color3.fromRGB(255,140, 50),
    rowHov  = Color3.fromRGB(20, 16, 34),
    logBg   = Color3.fromRGB(11,  9, 19),
}

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- CLEANUP
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
if CoreGui:FindFirstChild("LacedV2") then
    CoreGui:FindFirstChild("LacedV2"):Destroy()
end

local SG = Instance.new("ScreenGui")
SG.Name = "LacedV2"
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = CoreGui

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- TOAST
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local toastSlot = 0
local function showToast(name, money, isGold)
    if not cfg.toastEnabled then return end
    
    -- Play sound whenever a toast notification comes up
    playNotificationSound()
    
    toastSlot += 1
    local yOff = -94 - (toastSlot-1)*82
    local col  = isGold and C.gold or C.green
    local bg   = isGold and Color3.fromRGB(22,17,5) or Color3.fromRGB(8,22,14)

    local T = Instance.new("Frame")
    T.Size=UDim2.new(0,292,0,76)
    T.Position=UDim2.new(1,14,1,yOff)
    T.BackgroundColor3=bg; T.BorderSizePixel=0; T.Parent=SG
    Instance.new("UICorner",T).CornerRadius=UDim.new(0,14)
    local sk=Instance.new("UIStroke"); sk.Color=col; sk.Thickness=1; sk.Parent=T

    local bar=Instance.new("Frame")
    bar.Size=UDim2.new(0,3,1,-20); bar.Position=UDim2.new(0,10,0,10)
    bar.BackgroundColor3=col; bar.BorderSizePixel=0; bar.Parent=T
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

    local function tl(txt,y,sz,font,tc)
        local l=Instance.new("TextLabel"); l.Text=txt
        l.Size=UDim2.new(1,-28,0,sz+2); l.Position=UDim2.new(0,22,0,y)
        l.BackgroundTransparency=1; l.TextColor3=tc; l.TextSize=sz
        l.Font=font; l.TextXAlignment=Enum.TextXAlignment.Left
        l.TextTruncate=Enum.TextTruncate.AtEnd; l.Parent=T
    end
    tl(isGold and "NEW PEAK" or "SERVER FOUND", 9,  9,  Enum.Font.GothamBold, col)
    tl(name,                                    24, 13, Enum.Font.GothamBold, C.tPrim)
    tl(fmtMoney(money),                         42, 11, Enum.Font.Gotham,     C.tSec)

    local pbg=Instance.new("Frame")
    pbg.Size=UDim2.new(1,0,0,2); pbg.Position=UDim2.new(0,0,1,-2)
    pbg.BackgroundColor3=Color3.fromRGB(25,20,45); pbg.BorderSizePixel=0; pbg.Parent=T
    Instance.new("UICorner",pbg).CornerRadius=UDim.new(1,0)
    local pf=Instance.new("Frame")
    pf.Size=UDim2.new(1,0,1,0); pf.BackgroundColor3=col; pf.BorderSizePixel=0; pf.Parent=pbg
    Instance.new("UICorner",pf).CornerRadius=UDim.new(1,0)

    TweenService:Create(T,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),
        {Position=UDim2.new(1,-308,1,yOff)}):Play()
    TweenService:Create(pf,TweenInfo.new(5,Enum.EasingStyle.Linear),
        {Size=UDim2.new(0,0,1,0)}):Play()
    task.delay(5,function()
        local o=TweenService:Create(T,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In),
            {Position=UDim2.new(1,14,1,yOff)})
        o:Play(); o.Completed:Connect(function()
            T:Destroy(); toastSlot=math.max(0,toastSlot-1)
        end)
    end)
end

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- ROOT
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local Root=Instance.new("Frame")
Root.Name="Root"; Root.Size=UDim2.new(0,760,0,460)
Root.Position=UDim2.new(0.5,-380,0.5,-230)
Root.BackgroundColor3=C.bg; Root.BorderSizePixel=0
Root.Active=true; Root.Draggable=true; Root.Parent=SG
Instance.new("UICorner",Root).CornerRadius=UDim.new(0,16)
local rootSk=Instance.new("UIStroke"); rootSk.Color=C.stroke; rootSk.Thickness=1; rootSk.Parent=Root

local topLine=Instance.new("Frame"); topLine.Size=UDim2.new(1,-32,0,1)
topLine.Position=UDim2.new(0,16,0,0); topLine.BackgroundColor3=C.a1
topLine.BorderSizePixel=0; topLine.Parent=Root
Instance.new("UICorner",topLine).CornerRadius=UDim.new(1,0)
local tg=Instance.new("UIGradient"); tg.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.a3),
    ColorSequenceKeypoint.new(0.5,C.a1),
    ColorSequenceKeypoint.new(1,C.a2),
}); tg.Parent=topLine

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- PILL (Minimized GUI)
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local Pill=Instance.new("Frame")
Pill.Name="Pill"; Pill.Size=UDim2.new(0,280,0,36)
Pill.Position=UDim2.new(0.5,-140,0,14)
Pill.BackgroundColor3=C.card; Pill.BorderSizePixel=0
Pill.Visible=false; Pill.Active=true; Pill.Draggable=true; Pill.Parent=SG
Instance.new("UICorner",Pill).CornerRadius=UDim.new(1,0)
local pillSk=Instance.new("UIStroke"); pillSk.Color=C.a1; pillSk.Thickness=1; pillSk.Parent=Pill

local pillDot=Instance.new("Frame"); pillDot.Size=UDim2.new(0,8,0,8)
pillDot.Position=UDim2.new(0,12,0.5,-4); pillDot.BackgroundColor3=C.red
pillDot.BorderSizePixel=0; pillDot.Parent=Pill
Instance.new("UICorner",pillDot).CornerRadius=UDim.new(1,0)

local pillText=Instance.new("TextLabel"); pillText.Text="Laced  Â·  0 servers"
pillText.Size=UDim2.new(0,118,1,0); pillText.Position=UDim2.new(0,26,0,0)
pillText.BackgroundTransparency=1; pillText.TextColor3=C.tSec; pillText.TextSize=11
pillText.Font=Enum.Font.GothamBold; pillText.TextXAlignment=Enum.TextXAlignment.Left
pillText.Parent=Pill

local pillAJLbl=Instance.new("TextLabel"); pillAJLbl.Text="AJ"
pillAJLbl.Size=UDim2.new(0,18,1,0); pillAJLbl.Position=UDim2.new(1,-118,0,0)
pillAJLbl.BackgroundTransparency=1; pillAJLbl.TextColor3=C.tMut
pillAJLbl.TextSize=9; pillAJLbl.Font=Enum.Font.GothamBold; pillAJLbl.Parent=Pill

local pillAJTrack=Instance.new("Frame"); pillAJTrack.Size=UDim2.new(0,40,0,20)
pillAJTrack.Position=UDim2.new(1,-96,0.5,-10)
pillAJTrack.BackgroundColor3=cfg.autoJoin and C.a1 or Color3.fromRGB(26,20,46)
pillAJTrack.BorderSizePixel=0; pillAJTrack.Parent=Pill
Instance.new("UICorner",pillAJTrack).CornerRadius=UDim.new(1,0)

local pillAJThumb=Instance.new("Frame"); pillAJThumb.Size=UDim2.new(0,14,0,14)
pillAJThumb.Position=cfg.autoJoin and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
pillAJThumb.BackgroundColor3=cfg.autoJoin and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
pillAJThumb.BorderSizePixel=0; pillAJThumb.Parent=pillAJTrack
Instance.new("UICorner",pillAJThumb).CornerRadius=UDim.new(1,0)

local pillExpandBtn=Instance.new("TextButton"); pillExpandBtn.Text="â†‘"
pillExpandBtn.Size=UDim2.new(0,30,0,20); pillExpandBtn.Position=UDim2.new(1,-36,0.5,-10)
pillExpandBtn.BackgroundColor3=Color3.fromRGB(18,13,32); pillExpandBtn.TextColor3=C.tSec
pillExpandBtn.TextSize=10; pillExpandBtn.Font=Enum.Font.GothamBold
pillExpandBtn.BorderSizePixel=0; pillExpandBtn.Parent=Pill
Instance.new("UICorner",pillExpandBtn).CornerRadius=UDim.new(0,6)

local startMinTrack=Instance.new("Frame"); startMinTrack.Size=UDim2.new(0,40,0,20)
startMinTrack.Position=UDim2.new(1,-158,0.5,-10)
startMinTrack.BackgroundColor3=cfg.startMinimized and C.a1 or Color3.fromRGB(26,20,46)
startMinTrack.BorderSizePixel=0; startMinTrack.Parent=Pill
Instance.new("UICorner",startMinTrack).CornerRadius=UDim.new(1,0)

local startMinThumb=Instance.new("Frame"); startMinThumb.Size=UDim2.new(0,14,0,14)
startMinThumb.Position=cfg.startMinimized and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
startMinThumb.BackgroundColor3=cfg.startMinimized and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
startMinThumb.BorderSizePixel=0; startMinThumb.Parent=startMinTrack
Instance.new("UICorner",startMinThumb).CornerRadius=UDim.new(1,0)

local startMinLbl=Instance.new("TextLabel"); startMinLbl.Text="â—·"
startMinLbl.Size=UDim2.new(0,18,1,0); startMinLbl.Position=UDim2.new(1,-178,0,0)
startMinLbl.BackgroundTransparency=1; startMinLbl.TextColor3=C.tMut
startMinLbl.TextSize=9; startMinLbl.Font=Enum.Font.GothamBold; startMinLbl.Parent=Pill

local settAJTrack, settAJThumb

local function syncAJ(on)
    cfg.autoJoin=on
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    local tc=on and C.a1 or Color3.fromRGB(26,20,46)
    local pc=on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    local sc2=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    local wc=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    TweenService:Create(pillAJTrack,ti,{BackgroundColor3=tc}):Play()
    TweenService:Create(pillAJThumb,ti,{Position=pc,BackgroundColor3=wc}):Play()
    if settAJTrack then
        TweenService:Create(settAJTrack,ti,{BackgroundColor3=tc}):Play()
        TweenService:Create(settAJThumb,ti,{Position=sc2,BackgroundColor3=wc}):Play()
    end
    saveConfig()
end

local function syncStartMinimized(on)
    cfg.startMinimized = on
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    local tc = on and C.a1 or Color3.fromRGB(26,20,46)
    local pc = on and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    local wc = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    TweenService:Create(startMinTrack,ti,{BackgroundColor3=tc}):Play()
    TweenService:Create(startMinThumb,ti,{Position=pc,BackgroundColor3=wc}):Play()
    saveConfig()
end

local pillAJBtn=Instance.new("TextButton"); pillAJBtn.Size=UDim2.new(1,0,1,0)
pillAJBtn.BackgroundTransparency=1; pillAJBtn.Text=""; pillAJBtn.Parent=pillAJTrack
pillAJBtn.MouseButton1Click:Connect(function() syncAJ(not cfg.autoJoin) end)

local startMinBtn=Instance.new("TextButton"); startMinBtn.Size=UDim2.new(1,0,1,0)
startMinBtn.BackgroundTransparency=1; startMinBtn.Text=""; startMinBtn.Parent=startMinTrack
startMinBtn.MouseButton1Click:Connect(function() syncStartMinimized(not cfg.startMinimized) end)

local minimized=false; local guiVisible=true

local function setMinimized(v)
    minimized=v; Root.Visible=not v; Pill.Visible=v
end

pillExpandBtn.MouseButton1Click:Connect(function() setMinimized(false) end)

UIS.InputBegan:Connect(function(inp,gpe)
    if gpe then return end
    if inp.KeyCode==Enum.KeyCode.RightShift then
        if minimized then setMinimized(false)
        else guiVisible=not guiVisible; Root.Visible=guiVisible end
    end
end)

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- SIDEBAR
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local Sidebar=Instance.new("Frame"); Sidebar.Size=UDim2.new(0,145,1,0)
Sidebar.BackgroundColor3=C.sidebar; Sidebar.BorderSizePixel=0; Sidebar.Parent=Root
Instance.new("UICorner",Sidebar).CornerRadius=UDim.new(0,16)

local sfx=Instance.new("Frame"); sfx.Size=UDim2.new(0,16,1,0)
sfx.Position=UDim2.new(1,-16,0,0); sfx.BackgroundColor3=C.sidebar
sfx.BorderSizePixel=0; sfx.Parent=Sidebar

local logoF=Instance.new("Frame"); logoF.Size=UDim2.new(0,34,0,34)
logoF.Position=UDim2.new(0.5,-17,0,14); logoF.BackgroundColor3=C.a1
logoF.BorderSizePixel=0; logoF.Parent=Sidebar
Instance.new("UICorner",logoF).CornerRadius=UDim.new(0,10)
local lg=Instance.new("UIGradient"); lg.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,C.a3),ColorSequenceKeypoint.new(1,C.a2)
}); lg.Rotation=135; lg.Parent=logoF
local ll=Instance.new("TextLabel"); ll.Text="L"; ll.Size=UDim2.new(1,0,1,0)
ll.BackgroundTransparency=1; ll.TextColor3=Color3.fromRGB(255,255,255)
ll.TextSize=17; ll.Font=Enum.Font.GothamBold; ll.Parent=logoF

local bn=Instance.new("TextLabel"); bn.Text="LACED"
bn.Size=UDim2.new(1,0,0,13); bn.Position=UDim2.new(0,0,0,52)
bn.BackgroundTransparency=1; bn.TextColor3=C.tPrim; bn.TextSize=10
bn.Font=Enum.Font.GothamBold; bn.Parent=Sidebar

local sdiv=Instance.new("Frame"); sdiv.Size=UDim2.new(1,-20,0,1)
sdiv.Position=UDim2.new(0,10,0,76); sdiv.BackgroundColor3=C.stroke
sdiv.BorderSizePixel=0; sdiv.Parent=Sidebar

local TabList=Instance.new("Frame"); TabList.Size=UDim2.new(1,0,1,-150)
TabList.Position=UDim2.new(0,0,0,84); TabList.BackgroundTransparency=1; TabList.Parent=Sidebar
local tlo=Instance.new("UIListLayout"); tlo.Padding=UDim.new(0,3); tlo.Parent=TabList
local tpad=Instance.new("UIPadding"); tpad.PaddingLeft=UDim.new(0,8)
tpad.PaddingRight=UDim.new(0,8); tpad.Parent=TabList

local Content=Instance.new("Frame"); Content.Size=UDim2.new(1,-145,1,0)
Content.Position=UDim2.new(0,145,0,0); Content.BackgroundTransparency=1
Content.ClipsDescendants=true; Content.Parent=Root

local Pages={}; local TabBtns={}

local function makePage(name)
    local f=Instance.new("Frame"); f.Name=name; f.Size=UDim2.new(1,0,1,0)
    f.BackgroundTransparency=1; f.Visible=false; f.Parent=Content
    Pages[name]=f; return f
end

local function switchTab(name)
    for n,p in pairs(Pages) do p.Visible=(n==name) end
    for n,b in pairs(TabBtns) do
        local on=(n==name)
        b.BackgroundColor3=on and Color3.fromRGB(20,15,36) or C.sidebar
        b.TextColor3=on and C.tPrim or C.tSec
        local ind=b:FindFirstChild("Ind")
        if ind then ind.BackgroundTransparency=on and 0 or 1 end
    end
end

local tabDefs={
    {name="Dashboard",icon="â—ˆ"},
    {name="Log",      icon="â‰¡"},
    {name="Whitelist",icon="âŠž"},
    {name="Settings", icon="âŠ™"},
}

for _,t in ipairs(tabDefs) do
    local b=Instance.new("TextButton"); b.Name=t.name
    b.Text="  "..t.icon.."  "..t.name; b.Size=UDim2.new(1,0,0,36)
    b.BackgroundColor3=C.sidebar; b.TextColor3=C.tSec; b.TextSize=12
    b.Font=Enum.Font.GothamBold; b.TextXAlignment=Enum.TextXAlignment.Left
    b.BorderSizePixel=0; b.Parent=TabList
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,9)
    local ind=Instance.new("Frame"); ind.Name="Ind"; ind.Size=UDim2.new(0,3,0.55,0)
    ind.Position=UDim2.new(0,1,0.225,0); ind.BackgroundColor3=C.a1
    ind.BorderSizePixel=0; ind.BackgroundTransparency=1; ind.Parent=b
    Instance.new("UICorner",ind).CornerRadius=UDim.new(1,0)
    TabBtns[t.name]=b; makePage(t.name)
    b.MouseButton1Click:Connect(function() switchTab(t.name) end)
end

local function sideBtnF(text,y,bg,tc)
    local b=Instance.new("TextButton"); b.Text=text
    b.Size=UDim2.new(1,-16,0,28); b.Position=UDim2.new(0,8,1,y)
    b.BackgroundColor3=bg; b.TextColor3=tc; b.TextSize=11
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=Sidebar
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8); return b
end
local saveBtn  = sideBtnF("Save Config", -94, Color3.fromRGB(12,20,36), C.a2)
local minBtn   = sideBtnF("Minimize",    -62, Color3.fromRGB(18,14,30), C.tSec)
local closeBtn = sideBtnF("Close",       -28, Color3.fromRGB(36,10,16), Color3.fromRGB(180,75,85))

saveBtn.MouseButton1Click:Connect(function()
    saveConfig(); saveBtn.Text="Saved âœ“"; saveBtn.TextColor3=C.green
    task.delay(2,function() saveBtn.Text="Save Config"; saveBtn.TextColor3=C.a2 end)
end)
minBtn.MouseButton1Click:Connect(function() setMinimized(true) end)
closeBtn.MouseButton1Click:Connect(function()
    if wsConnection then pcall(function() wsConnection:Close() end) end
    SG:Destroy()
end)

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- UI HELPERS
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local CW = 610

local function card(parent,x,y,w,h)
    local f=Instance.new("Frame"); f.Size=UDim2.new(0,w,0,h)
    f.Position=UDim2.new(0,x,0,y); f.BackgroundColor3=C.card
    f.BorderSizePixel=0; f.Parent=parent
    Instance.new("UICorner",f).CornerRadius=UDim.new(0,11)
    local s=Instance.new("UIStroke"); s.Color=C.stroke; s.Thickness=1; s.Parent=f
    return f
end

local function lbl(parent,text,x,y,w,h,sz,font,col,align)
    local l=Instance.new("TextLabel"); l.Text=text
    l.Size=UDim2.new(0,w,0,h); l.Position=UDim2.new(0,x,0,y)
    l.BackgroundTransparency=1; l.TextColor3=col or C.tSec
    l.TextSize=sz or 11; l.Font=font or Enum.Font.Gotham
    l.TextXAlignment=align or Enum.TextXAlignment.Left; l.Parent=parent; return l
end

local function mkToggle(parent,x,y,initVal,onChange)
    local on=initVal
    local track=Instance.new("Frame"); track.Size=UDim2.new(0,44,0,24)
    track.Position=UDim2.new(1,x,0,y)
    track.BackgroundColor3=on and C.a1 or Color3.fromRGB(26,20,46)
    track.BorderSizePixel=0; track.Parent=parent
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)
    local thumb=Instance.new("Frame"); thumb.Size=UDim2.new(0,18,0,18)
    thumb.Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
    thumb.BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    thumb.BorderSizePixel=0; thumb.Parent=track
    Instance.new("UICorner",thumb).CornerRadius=UDim.new(1,0)
    local tbtn=Instance.new("TextButton"); tbtn.Size=UDim2.new(1,0,1,0)
    tbtn.BackgroundTransparency=1; tbtn.Text=""; tbtn.Parent=track
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    tbtn.MouseButton1Click:Connect(function()
        on=not on
        TweenService:Create(track,ti,{BackgroundColor3=on and C.a1 or Color3.fromRGB(26,20,46)}):Play()
        TweenService:Create(thumb,ti,{
            Position=on and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9),
            BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
        }):Play()
        if onChange then onChange(on) end
    end)
    return track,thumb
end

-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
-- SHARED STATE
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
local wsConnection
local seenJobIds = {}
local statDotRef,statTextRef
local statCounts={seen=0,joined=0,skipped=0}
local statNumRefs={}
local lastNameRef,lastMetaRef,peakNameRef,peakMoneyRef
local peakMoney=0
local selectedRetries=cfg.retryIndex

-- scroll reference â€” declared here, assigned after log page is built
local logScroll

local function setStatus(text,col)
    if statTextRef then statTextRef.Text=text end
    if statDotRef  then statDotRef.BackgroundColor3=col end
    pillDot.BackgroundColor3=col
end

local function bumpStat(k)
    statCounts[k]+=1
    if statNumRefs[k] then statNumRefs[k].Text=tostring(statCounts[k]) end
    pillText.Text="Laced  Â·  "..statCounts.seen.." servers"
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- DASHBOARD
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local dash=Pages["Dashboard"]
lbl(dash,"Dashboard",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(dash,"Live server monitoring",16,32,300,13,10,Enum.Font.Gotham,C.tMut)

local sc=card(dash,16,54,CW,52)
local dot=Instance.new("Frame"); dot.Size=UDim2.new(0,9,0,9)
dot.Position=UDim2.new(0,14,0.5,-4); dot.BackgroundColor3=C.red
dot.BorderSizePixel=0; dot.Parent=sc
Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0)
statDotRef=dot
lbl(sc,"CONNECTION",30,8,160,11,9,Enum.Font.GothamBold,C.tMut)
statTextRef=lbl(sc,"Disconnected",30,24,280,16,13,Enum.Font.GothamBold,C.tPrim)

local colW=math.floor((CW-48)/3)
local sDefs={{key="seen",label="SEEN",col=C.a2},{key="joined",label="JOINED",col=C.green},{key="skipped",label="SKIPPED",col=C.tSec}}
for i,s in ipairs(sDefs) do
    local sc2=card(dash,16+(i-1)*(colW+8),116,colW,62)
    statNumRefs[s.key]=lbl(sc2,"0",0,8,colW,28,20,Enum.Font.GothamBold,s.col,Enum.TextXAlignment.Center)
    lbl(sc2,s.label,0,40,colW,12,9,Enum.Font.GothamBold,C.tMut,Enum.TextXAlignment.Center)
end

local hw=math.floor((CW-24)/2)
local lc=card(dash,16,190,hw,68)
lbl(lc,"LAST SERVER",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lastNameRef=lbl(lc,"Waiting...",14,22,hw-28,18,13,Enum.Font.GothamBold,C.tPrim)
lastMetaRef=lbl(lc,"",14,44,hw-28,13,10,Enum.Font.Gotham,C.tSec)

local pc=card(dash,hw+24,190,hw,68)
lbl(pc,"SESSION PEAK",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
peakNameRef=lbl(pc,"â€”",14,22,hw-28,18,13,Enum.Font.GothamBold,C.gold)
peakMoneyRef=lbl(pc,"â€”",14,44,hw-28,13,10,Enum.Font.Gotham,C.tSec)

local wlCard=card(dash,16,272,CW,36)
local wlDot2=Instance.new("Frame"); wlDot2.Size=UDim2.new(0,8,0,8)
wlDot2.Position=UDim2.new(0,14,0.5,-4); wlDot2.BackgroundColor3=C.tMut
wlDot2.BorderSizePixel=0; wlDot2.Parent=wlCard
Instance.new("UICorner",wlDot2).CornerRadius=UDim.new(1,0)
local wlStatusLbl=lbl(wlCard,"Whitelist: OFF â€” joining all servers",30,0,500,36,11,Enum.Font.GothamBold,C.tSec)

local function updateWLIndicator()
    if cfg.whitelistEnabled and #cfg.whitelist>0 then
        wlDot2.BackgroundColor3=C.green
        wlStatusLbl.Text="Whitelist: ON â€” "..#cfg.whitelist.." brainrot(s)"
        wlStatusLbl.TextColor3=C.green
    elseif cfg.whitelistEnabled then
        wlDot2.BackgroundColor3=C.yellow
        wlStatusLbl.Text="Whitelist: ON â€” none selected (joining all)"
        wlStatusLbl.TextColor3=C.yellow
    else
        wlDot2.BackgroundColor3=C.tMut
        wlStatusLbl.Text="Whitelist: OFF â€” joining all servers"
        wlStatusLbl.TextColor3=C.tSec
    end
end
updateWLIndicator()

local fmtCard=card(dash,16,318,CW,36)
local fmtDot=Instance.new("Frame"); fmtDot.Size=UDim2.new(0,8,0,8)
fmtDot.Position=UDim2.new(0,14,0.5,-4); fmtDot.BackgroundColor3=C.tMut
fmtDot.BorderSizePixel=0; fmtDot.Parent=fmtCard
Instance.new("UICorner",fmtDot).CornerRadius=UDim.new(1,0)
local fmtLbl=lbl(fmtCard,"Format: awaiting first message...",30,0,500,36,11,Enum.Font.Gotham,C.tSec)

local function setFmtLabel(isB64)
    if isB64 then
        fmtDot.BackgroundColor3=C.a2
        fmtLbl.Text="Format: Base64 (secondary source)"; fmtLbl.TextColor3=C.a2
    else
        fmtDot.BackgroundColor3=C.green
        fmtLbl.Text="Format: Standard JSON (primary source)"; fmtLbl.TextColor3=C.green
    end
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- LOG PAGE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local logPage=Pages["Log"]
lbl(logPage,"Server Log",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(logPage,"Join or Spam any server directly from the log",16,32,420,13,10,Enum.Font.Gotham,C.tMut)

-- Retry selector
lbl(logPage,"RETRIES",380,14,60,11,9,Enum.Font.GothamBold,C.tMut)
local retryRowF=Instance.new("Frame"); retryRowF.Size=UDim2.new(0,180,0,24)
retryRowF.Position=UDim2.new(0,380,0,28); retryRowF.BackgroundTransparency=1; retryRowF.Parent=logPage
local rrl=Instance.new("UIListLayout"); rrl.FillDirection=Enum.FillDirection.Horizontal
rrl.Padding=UDim.new(0,5); rrl.VerticalAlignment=Enum.VerticalAlignment.Center; rrl.Parent=retryRowF

local retryBtns={}
local function refreshRetryBtns()
    for i,b in ipairs(retryBtns) do
        local on=(i==selectedRetries)
        b.BackgroundColor3=on and C.a1 or Color3.fromRGB(18,13,32)
        b.TextColor3=on and C.tPrim or C.tSec
    end
    cfg.retryIndex=selectedRetries
end
for i,v in ipairs(retryOptions) do
    local b=Instance.new("TextButton"); b.Text=v.."x"; b.Size=UDim2.new(0,32,0,22)
    b.BackgroundColor3=Color3.fromRGB(18,13,32); b.TextColor3=C.tSec; b.TextSize=10
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=retryRowF
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    table.insert(retryBtns,b)
    b.MouseButton1Click:Connect(function() selectedRetries=i; refreshRetryBtns() end)
end
refreshRetryBtns()

local clearBtn=Instance.new("TextButton"); clearBtn.Text="Clear"
clearBtn.Size=UDim2.new(0,46,0,22); clearBtn.Position=UDim2.new(1,-62,0,28)
clearBtn.BackgroundColor3=Color3.fromRGB(20,14,32); clearBtn.TextColor3=C.tSec
clearBtn.TextSize=10; clearBtn.Font=Enum.Font.GothamBold; clearBtn.BorderSizePixel=0
clearBtn.Parent=logPage; Instance.new("UICorner",clearBtn).CornerRadius=UDim.new(0,7)

-- *** THE SCROLL FRAME â€” fixed ***
logScroll=Instance.new("ScrollingFrame")
logScroll.Name="LogScroll"
logScroll.Size=UDim2.new(1,-32,1,-58)
logScroll.Position=UDim2.new(0,16,0,54)
logScroll.BackgroundColor3=C.logBg
logScroll.BorderSizePixel=0
logScroll.ScrollBarThickness=3
logScroll.ScrollBarImageColor3=C.a1
logScroll.ScrollingDirection=Enum.ScrollingDirection.Y
logScroll.CanvasSize=UDim2.new(0,0,0,0)
logScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
logScroll.Parent=logPage
Instance.new("UICorner",logScroll).CornerRadius=UDim.new(0,11)
local ssk=Instance.new("UIStroke"); ssk.Color=C.stroke; ssk.Thickness=1; ssk.Parent=logScroll

-- UIListLayout MUST come before UIPadding
local logLL=Instance.new("UIListLayout")
logLL.Padding=UDim.new(0,0)
logLL.SortOrder=Enum.SortOrder.LayoutOrder
logLL.FillDirection=Enum.FillDirection.Vertical
logLL.HorizontalAlignment=Enum.HorizontalAlignment.Left
logLL.VerticalAlignment=Enum.VerticalAlignment.Top
logLL.Parent=logScroll

local logPad=Instance.new("UIPadding")
logPad.PaddingTop=UDim.new(0,4)
logPad.PaddingBottom=UDim.new(0,4)
logPad.Parent=logScroll

local logOrder=0

local function addLog(msg, col, isSub, jobId)
    col = col or C.tSec
    local hasJob = jobId and jobId ~= ""
    logOrder += 1

    local row=Instance.new("Frame")
    row.Name="Row"
    row.Size=UDim2.new(1,0,0,34)
    row.BackgroundColor3=C.logBg
    row.BorderSizePixel=0
    row.LayoutOrder=logOrder
    row.Parent=logScroll

    -- hover
    local rh=Instance.new("TextButton"); rh.Size=UDim2.new(1,0,1,0)
    rh.BackgroundTransparency=1; rh.Text=""; rh.ZIndex=1; rh.Parent=row
    rh.MouseEnter:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.rowHov}):Play()
    end)
    rh.MouseLeave:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.logBg}):Play()
    end)

    -- timestamp
    local tslbl=Instance.new("TextLabel"); tslbl.Text=getTS()
    tslbl.Size=UDim2.new(0,58,1,0); tslbl.Position=UDim2.new(0,8,0,0)
    tslbl.BackgroundTransparency=1; tslbl.TextColor3=C.tMut; tslbl.TextSize=9
    tslbl.Font=Enum.Font.Gotham; tslbl.ZIndex=2; tslbl.Parent=row

    -- message
    local btnW = hasJob and 166 or 0
    local txtLbl=Instance.new("TextLabel"); txtLbl.Text=msg
    txtLbl.Size=UDim2.new(1,-(70+btnW),1,0); txtLbl.Position=UDim2.new(0,68,0,0)
    txtLbl.BackgroundTransparency=1; txtLbl.TextColor3=col; txtLbl.TextSize=11
    txtLbl.Font=isSub and Enum.Font.Gotham or Enum.Font.GothamBold
    txtLbl.TextTruncate=Enum.TextTruncate.AtEnd
    txtLbl.TextXAlignment=Enum.TextXAlignment.Left
    txtLbl.ZIndex=2; txtLbl.Parent=row

    -- bottom divider
    local div=Instance.new("Frame"); div.Size=UDim2.new(1,0,0,1)
    div.Position=UDim2.new(0,0,1,-1); div.BackgroundColor3=C.stroke
    div.BorderSizePixel=0; div.ZIndex=2; div.Parent=row

    -- inline action buttons
    if hasJob then
        local jb=Instance.new("TextButton"); jb.Text="Join"
        jb.Size=UDim2.new(0,52,0,22); jb.Position=UDim2.new(1,-166,0.5,-11)
        jb.BackgroundColor3=C.a1; jb.TextColor3=Color3.fromRGB(255,255,255)
        jb.TextSize=10; jb.Font=Enum.Font.GothamBold; jb.BorderSizePixel=0
        jb.ZIndex=3; jb.Parent=row
        Instance.new("UICorner",jb).CornerRadius=UDim.new(0,7)
        local jg=Instance.new("UIGradient"); jg.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.a3),ColorSequenceKeypoint.new(1,C.a1)
        }); jg.Rotation=90; jg.Parent=jb

        jb.MouseButton1Click:Connect(function()
            jb.Text="..."
            task.delay(0.4,function()
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(PLACE_ID,jobId,Players.LocalPlayer)
                end)
                jb.Text="Sent"; jb.BackgroundColor3=C.green
            end)
        end)

        local spamming=false
        local sb=Instance.new("TextButton")
        sb.Text=retryOptions[selectedRetries].."x Spam"
        sb.Size=UDim2.new(0,80,0,22); sb.Position=UDim2.new(1,-106,0.5,-11)
        sb.BackgroundColor3=Color3.fromRGB(18,13,32); sb.TextColor3=C.orange
        sb.TextSize=10; sb.Font=Enum.Font.GothamBold; sb.BorderSizePixel=0
        sb.ZIndex=3; sb.Parent=row
        Instance.new("UICorner",sb).CornerRadius=UDim.new(0,7)
        local ssk2=Instance.new("UIStroke"); ssk2.Color=C.orange; ssk2.Thickness=1; ssk2.Parent=sb

        local stopB=Instance.new("TextButton"); stopB.Text="Stop"
        stopB.Size=UDim2.new(0,36,0,22); stopB.Position=UDim2.new(1,-42,0.5,-11)
        stopB.BackgroundColor3=Color3.fromRGB(36,10,16); stopB.TextColor3=C.red
        stopB.TextSize=10; stopB.Font=Enum.Font.GothamBold; stopB.BorderSizePixel=0
        stopB.Visible=false; stopB.ZIndex=3; stopB.Parent=row
        Instance.new("UICorner",stopB).CornerRadius=UDim.new(0,7)
        local stSk=Instance.new("UIStroke"); stSk.Color=C.red; stSk.Thickness=1; stSk.Parent=stopB

        sb.MouseButton1Click:Connect(function()
            if spamming then return end
            spamming=true; stopB.Visible=true
            local ret=retryOptions[selectedRetries]
            task.spawn(function()
                for i=1,ret do
                    if not spamming then break end
                    sb.Text=i.."/"..ret
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PLACE_ID,jobId,Players.LocalPlayer)
                    end)
                    task.wait(0.8)
                end
                spamming=false; stopB.Visible=false
                sb.Text="Done"; sb.TextColor3=C.green
            end)
        end)

        stopB.MouseButton1Click:Connect(function()
            spamming=false; stopB.Visible=false
            sb.Text=retryOptions[selectedRetries].."x Spam"; sb.TextColor3=C.orange
        end)
    end

    -- auto scroll to bottom
    task.defer(function()
        logScroll.CanvasPosition=Vector2.new(0,math.huge)
    end)
end

clearBtn.MouseButton1Click:Connect(function()
    for _,c in ipairs(logScroll:GetChildren()) do
        if c:IsA("Frame") then c:Destroy() end
    end
    logOrder=0
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- WHITELIST PAGE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local wlPage=Pages["Whitelist"]
lbl(wlPage,"Whitelist",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(wlPage,"Select brainrots to only auto-join servers containing them",16,32,500,13,10,Enum.Font.Gotham,C.tMut)

local wlTogCard=card(wlPage,16,54,CW,44)
lbl(wlTogCard,"ENABLE WHITELIST",14,8,260,11,9,Enum.Font.GothamBold,C.tMut)
lbl(wlTogCard,"When ON, only joins servers with selected brainrots",14,22,360,14,11,Enum.Font.Gotham,C.tSec)
mkToggle(wlTogCard,-58,10,cfg.whitelistEnabled,function(v)
    cfg.whitelistEnabled=v; saveConfig(); updateWLIndicator()
end)

local srchBG=Instance.new("Frame"); srchBG.Size=UDim2.new(0,CW,0,30)
srchBG.Position=UDim2.new(0,16,0,108); srchBG.BackgroundColor3=C.deep
srchBG.BorderSizePixel=0; srchBG.Parent=wlPage
Instance.new("UICorner",srchBG).CornerRadius=UDim.new(0,8)
local srchSk=Instance.new("UIStroke"); srchSk.Color=C.stroke; srchSk.Thickness=1; srchSk.Parent=srchBG
local srchBox=Instance.new("TextBox"); srchBox.Size=UDim2.new(1,-12,1,0)
srchBox.Position=UDim2.new(0,8,0,0); srchBox.BackgroundTransparency=1
srchBox.TextColor3=C.tPrim; srchBox.PlaceholderText="Search brainrots..."
srchBox.PlaceholderColor3=C.tMut; srchBox.TextSize=11; srchBox.Font=Enum.Font.Gotham
srchBox.TextXAlignment=Enum.TextXAlignment.Left; srchBox.ClearTextOnFocus=false
srchBox.Parent=srchBG
srchBox.Focused:Connect(function()
    TweenService:Create(srchSk,TweenInfo.new(0.15),{Color=C.a1}):Play()
end)
srchBox.FocusLost:Connect(function()
    TweenService:Create(srchSk,TweenInfo.new(0.15),{Color=C.stroke}):Play()
end)

local selCntLbl=lbl(wlPage,"0 selected",CW-80,112,80,14,10,Enum.Font.GothamBold,C.tMut,Enum.TextXAlignment.Right)

local function updateSelCount()
    local n=#cfg.whitelist
    selCntLbl.Text=n.." selected"
    selCntLbl.TextColor3=n>0 and C.green or C.tMut
    updateWLIndicator()
end

local clrSelBtn=Instance.new("TextButton"); clrSelBtn.Text="Clear All"
clrSelBtn.Size=UDim2.new(0,70,0,22); clrSelBtn.Position=UDim2.new(1,-90,0,108)
clrSelBtn.BackgroundColor3=Color3.fromRGB(20,14,32); clrSelBtn.TextColor3=C.tSec
clrSelBtn.TextSize=10; clrSelBtn.Font=Enum.Font.GothamBold; clrSelBtn.BorderSizePixel=0
clrSelBtn.Parent=wlPage; Instance.new("UICorner",clrSelBtn).CornerRadius=UDim.new(0,7)

local wlScroll=Instance.new("ScrollingFrame"); wlScroll.Size=UDim2.new(1,-32,1,-148)
wlScroll.Position=UDim2.new(0,16,0,146); wlScroll.BackgroundColor3=C.deep
wlScroll.BorderSizePixel=0; wlScroll.ScrollBarThickness=2; wlScroll.ScrollBarImageColor3=C.a1
wlScroll.CanvasSize=UDim2.new(0,0,0,0); wlScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
wlScroll.Parent=wlPage
Instance.new("UICorner",wlScroll).CornerRadius=UDim.new(0,10)
local wlSk2=Instance.new("UIStroke"); wlSk2.Color=C.stroke; wlSk2.Thickness=1; wlSk2.Parent=wlScroll

local wlGrid=Instance.new("Frame"); wlGrid.Size=UDim2.new(1,-12,0,0)
wlGrid.Position=UDim2.new(0,6,0,6); wlGrid.BackgroundTransparency=1
wlGrid.AutomaticSize=Enum.AutomaticSize.Y; wlGrid.Parent=wlScroll
local wlLayout=Instance.new("UIGridLayout"); wlLayout.CellSize=UDim2.new(0,192,0,28)
wlLayout.CellPadding=UDim2.new(0,6,0,4); wlLayout.Parent=wlGrid

local function isWL(name)
    for _,w in ipairs(cfg.whitelist) do if w==name then return true end end
    return false
end
local function toggleWL(name)
    local found=false
    for i,w in ipairs(cfg.whitelist) do
        if w==name then table.remove(cfg.whitelist,i); found=true; break end
    end
    if not found then table.insert(cfg.whitelist,name) end
    saveConfig(); updateSelCount()
end

local function refreshWL(filter)
    filter=(filter or ""):lower()
    for _,c in ipairs(wlGrid:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    for _,name in ipairs(ALL_BRAINROTS) do
        if filter=="" or name:lower():find(filter,1,true) then
            local sel=isWL(name)
            local b=Instance.new("TextButton"); b.Text=name
            b.Size=UDim2.new(0,192,0,28)
            b.BackgroundColor3=sel and C.a1 or Color3.fromRGB(16,12,26)
            b.TextColor3=sel and Color3.fromRGB(255,255,255) or C.tSec
            b.TextSize=10; b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0
            b.TextTruncate=Enum.TextTruncate.AtEnd; b.Parent=wlGrid
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
            if not sel then
                local bsk=Instance.new("UIStroke"); bsk.Color=C.stroke; bsk.Thickness=1; bsk.Parent=b
            end
            b.MouseButton1Click:Connect(function()
                toggleWL(name)
                local nowSel=isWL(name)
                b.BackgroundColor3=nowSel and C.a1 or Color3.fromRGB(16,12,26)
                b.TextColor3=nowSel and Color3.fromRGB(255,255,255) or C.tSec
            end)
        end
    end
end
refreshWL(); updateSelCount()
srchBox:GetPropertyChangedSignal("Text"):Connect(function() refreshWL(srchBox.Text) end)
clrSelBtn.MouseButton1Click:Connect(function()
    cfg.whitelist={}; saveConfig(); updateSelCount(); refreshWL(srchBox.Text)
end)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- SETTINGS PAGE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local sett=Pages["Settings"]
lbl(sett,"Settings",16,12,300,22,16,Enum.Font.GothamBold,C.tPrim)
lbl(sett,"Configure your notifier",16,32,300,13,10,Enum.Font.Gotham,C.tMut)

local function settCard(y,h) return card(sett,16,y,CW,h) end

local ac=settCard(54,52)
lbl(ac,"AUTO JOIN",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lbl(ac,"Automatically teleport when a qualifying server is found",14,24,380,13,11,Enum.Font.Gotham,C.tSec)
settAJTrack,settAJThumb=mkToggle(ac,-58,14,cfg.autoJoin,function(v) syncAJ(v) end)

local tc=settCard(116,52)
lbl(tc,"TOAST NOTIFICATIONS",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lbl(tc,"Slide-in popup when a matching server is detected",14,24,380,13,11,Enum.Font.Gotham,C.tSec)
mkToggle(tc,-58,14,cfg.toastEnabled,function(v) cfg.toastEnabled=v; saveConfig() end)

local mc=settCard(178,84)
lbl(mc,"MINIMUM MONEY",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
local monRow=Instance.new("Frame"); monRow.Size=UDim2.new(1,-16,0,30)
monRow.Position=UDim2.new(0,8,0,24); monRow.BackgroundTransparency=1; monRow.Parent=mc
local mrl=Instance.new("UIListLayout"); mrl.FillDirection=Enum.FillDirection.Horizontal
mrl.Padding=UDim.new(0,6); mrl.VerticalAlignment=Enum.VerticalAlignment.Center; mrl.Parent=monRow

local moneyBtns={}; local activeFilterLbl
local function refreshMoney()
    for i,b in ipairs(moneyBtns) do
        local on=(i==cfg.minMoneyIndex)
        b.BackgroundColor3=on and C.a1 or Color3.fromRGB(18,13,32)
        b.TextColor3=on and C.tPrim or C.tSec
    end
    if activeFilterLbl then activeFilterLbl.Text="Active: "..moneyOptions[cfg.minMoneyIndex].label end
    saveConfig()
end
for i,opt in ipairs(moneyOptions) do
    local b=Instance.new("TextButton"); b.Text=opt.label; b.Size=UDim2.new(0,56,0,28)
    b.BackgroundColor3=Color3.fromRGB(18,13,32); b.TextColor3=C.tSec; b.TextSize=10
    b.Font=Enum.Font.GothamBold; b.BorderSizePixel=0; b.Parent=monRow
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
    table.insert(moneyBtns,b)
    b.MouseButton1Click:Connect(function() cfg.minMoneyIndex=i; refreshMoney() end)
end
activeFilterLbl=lbl(mc,"Active: "..moneyOptions[cfg.minMoneyIndex].label,14,62,200,13,10,Enum.Font.Gotham,C.tMut)
refreshMoney()

-- NEW: Start minimized setting in settings page
local smc=settCard(272,52)
lbl(smc,"START MINIMIZED",14,8,200,11,9,Enum.Font.GothamBold,C.tMut)
lbl(smc,"Launch GUI minimized when executing script",14,24,380,13,11,Enum.Font.Gotham,C.tSec)
mkToggle(smc,-58,14,cfg.startMinimized,function(v) 
    cfg.startMinimized=v; 
    saveConfig()
    -- Update pill toggle
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    local tc = v and C.a1 or Color3.fromRGB(26,20,46)
    local pc = v and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
    local wc = v and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,55,110)
    TweenService:Create(startMinTrack,ti,{BackgroundColor3=tc}):Play()
    TweenService:Create(startMinThumb,ti,{Position=pc,BackgroundColor3=wc}):Play()
end)

lbl(sett,"RightShift â€” toggle GUI visibility",16,340,400,13,10,Enum.Font.Gotham,C.tMut)
lbl(sett,"Config saves to LacedNotifierV2.json in executor folder",16,356,500,13,10,Enum.Font.Gotham,C.tMut)

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
-- WEBSOCKET
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function connectWS()
    setStatus("Connecting...", C.yellow)
    addLog("Connecting to WebSocket...", C.yellow, true)

    local ok, ws = pcall(function() return WebSocket.connect(WS_URL) end)
    if not ok or not ws then
        setStatus("Failed", C.red)
        addLog("Connection failed. Retrying in 5s.", C.red, true)
        task.delay(5, connectWS); return
    end

    wsConnection = ws
    setStatus("Connected", C.green)
    addLog("Connected successfully.", C.green, true)

    ws.OnMessage:Connect(function(raw)
        local data = parseMsg(raw)
        if not data then return end

        setFmtLabel(data.wasB64)

        local name    = data.name
        local money   = data.money
        local players = data.players
        local maxpl   = data.maxpl
        local jobId   = data.jobId

        if not namePassesWhitelist(name) then return end

        -- skip duplicate job IDs
        if seenJobIds[jobId] then return end
        seenJobIds[jobId] = true

        local monStr = fmtMoney(money)
        local line   = string.format("%s  |  %d/%d  |  %s", name, players, maxpl, monStr)
        local isNew  = money > peakMoney

        if isNew then
            peakMoney = money
            if peakNameRef  then peakNameRef.Text  = name   end
            if peakMoneyRef then peakMoneyRef.Text = monStr end
        end

        bumpStat("seen")
        if lastNameRef then lastNameRef.Text = name end
        if lastMetaRef then lastMetaRef.Text = string.format("%d/%d players  Â·  %s", players, maxpl, monStr) end

        local minVal = moneyOptions[cfg.minMoneyIndex].value
        if money >= minVal then
            addLog(line, isNew and C.gold or C.green, false, jobId)
            showToast(name, money, isNew)
            if cfg.autoJoin then
                bumpStat("joined")
                task.delay(0.5, function()
                    pcall(function()
                        TeleportService:TeleportToPlaceInstance(PLACE_ID, jobId, Players.LocalPlayer)
                    end)
                end)
            end
        else
            bumpStat("skipped")
            addLog(line, C.tMut, true)
        end
    end)

    ws.OnClose:Connect(function()
        setStatus("Disconnected", C.red)
        addLog("Disconnected. Reconnecting in 3s.", C.red, true)
        wsConnection=nil; task.delay(3, connectWS)
    end)
end

switchTab("Dashboard")

-- Apply start minimized setting on startup
if cfg.startMinimized then
    setMinimized(true)
end

connectWS()
