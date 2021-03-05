local function print(msg) DEFAULT_CHAT_FRAME:AddMessage(msg) end

local numChildren = 0

local function IsNameplate(frame)
    if frame:GetName() then return false end
    local overlay = frame:GetRegions()
    if overlay and overlay:GetObjectType() == "Texture" then
        return overlay:GetTexture() == "Interface\\Tooltips\\Nameplate-Border"
    end
    return false
end

local width = 85
local height = 20

local function Plates_OnShow(self)
    self:SetWidth(width)
    self:SetHeight(height)
end

local function SetupPlates()
    local newChildren = WorldFrame:GetNumChildren()
    if newChildren > numChildren then
        for i = numChildren + 1, newChildren do
            local frame = select(i, WorldFrame:GetChildren())
            if IsNameplate(frame) then
                frame:SetWidth(width)
                frame:SetHeight(height)
                frame:SetScript("OnShow", Plates_OnShow)
            end
        end
        numChildren = newChildren
    end
end

local Plates = CreateFrame("Frame")
Plates:SetScript("OnUpdate", SetupPlates)
Plates:RegisterEvent("PLAYER_ENTERING_WORLD")
Plates:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        numChildren = 0
    end
end)


