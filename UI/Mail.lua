-- Mail.lua
-- @Author : Dencer (tdaddon@163.com)
-- @Link   : https://dengsir.github.io
-- @Date   : 1/22/2020, 1:18:41 AM

---@type ns
local ns = select(2, ...)

local Mail = ns.Addon:NewClass('UI.Mail', ns.UI.Frame)

function Mail:Constructor()
    ns.UI.TitleContainer:Bind(self.Container, self.meta)

    self.Container:SetScript('OnSizeChanged', function()
        self:UpdateSize()
    end)
end

function Mail:UpdateSize()
    return self:SetSize(self.Container:GetWidth() + 24, self.Container:GetHeight() + 78)
end
