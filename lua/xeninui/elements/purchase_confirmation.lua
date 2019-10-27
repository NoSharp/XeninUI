--[[
	Created by Patrick Ratzow (sleeppyy).

	Credits goes to Metamist for his previously closed source library Wyvern,
		CupCakeR for various improvements, the animated texture VGUI panel, and misc.
]]
 
local PANEL = {}

XeninUI:CreateFont("XeninUI.PurchaseConfirmation.Name", 24)
XeninUI:CreateFont("XeninUI.PurchaseConfirmation.Sid64", 18)
XeninUI:CreateFont("XeninUI.PurchaseConfirmation.String", 24)

AccessorFunc(PANEL, "m_player", "Player")
AccessorFunc(PANEL, "m_icon", "Icon")
AccessorFunc(PANEL, "m_purchaseStr", "PurchaseString")
AccessorFunc(PANEL, "m_accept", "Accept")
AccessorFunc(PANEL, "m_decline", "Decline")
AccessorFunc(PANEL, "m_tbl", "Table")

function PANEL:Start()
  self:SetAccept(function() end)
  self:SetDecline(function() end)

  self.background.avatar = self.background:Add("XeninUI.Avatar")
  self.background.avatar:SetPlayer(self:GetPlayer(), 64)
  self.background.avatar:SetVertices(90)
  self.background.avatar:SetMouseInputEnabled(false)

  self.background.name = self.background:Add("DLabel")
  self.background.name:SetText(self:GetPlayer():Nick())
  self.background.name:SetTextColor(color_white)
  self.background.name:SetFont("XeninUI.PurchaseConfirmation.Name")

  self.background.sid64 = self.background:Add("DTextEntry")
  self.background.sid64:SetText(self:GetPlayer():SteamID())
  self.background.sid64:SetTextColor(Color(190, 190, 190))
  self.background.sid64:SetFont("XeninUI.PurchaseConfirmation.Sid64")
  self.background.sid64:SetEnabled(false)
  self.background.sid64:SetDrawLanguageID(false)
  self.background.sid64.Paint = function(pnl, w, h)
    pnl:DrawTextEntryText(pnl:GetTextColor(), pnl:GetTextColor(), pnl:GetTextColor())
  end

  self.background.string = self.background:Add("DLabel")
  self.background.string:SetText(self:GetPurchaseString())
  self.background.string:SetTextColor(Color(220, 220, 220))
  self.background.string:SetWrap(true)
  self.background.string:SetFont("XeninUI.PurchaseConfirmation.String")
  self.background.string:SetContentAlignment(5)

  if (type(self:GetIcon()) == "string") then
    self.background.display = self.background:Add("XeninUI.AnimatedTexture")
    self.background.display:SetDirectory(self:GetIcon())
    local tbl = self:GetTable()
    self.background.display:SetTimes(tbl.normal, tbl.idle)
    self.background.display:PostInit()
  else
    self.background.display = self.background:Add("DPanel")
    self.background.display.Paint = function(pnl, w, h)
      if (!self:GetIcon()) then return end

      surface.SetMaterial(self:GetIcon())
      surface.SetDrawColor(color_white)
      surface.DrawTexturedRect(0, 0, w, h)
    end
  end

  self.background.accept = self.background:Add("DButton")
  self.background.accept:SetText("Confirm purchase")
  self.background.accept:SetFont("XeninUI.Query.Button")
  self.background.accept:SetTextColor(Color(21, 21, 21))
  self.background.accept.alpha = 0
  self.background.accept.background = XeninUI.Theme.Green
  self.background.accept.Paint = function(pnl, w, h)
    local x, y = pnl:LocalToScreen()

    BSHADOWS.BeginShadow()
      draw.RoundedBox(h / 2, x, y, w, h, pnl.background)
    BSHADOWS.EndShadow(1, 1, 2, pnl.alpha, 0, 0)
  end
  self.background.accept.OnCursorEntered = function(pnl)
    local col = XeninUI.Theme.Green
    col = Color(col.r + 5, col.g + 50, col.b + 7)

    pnl:LerpColor("background", col)
    pnl:Lerp("alpha", 255)
  end
  self.background.accept.OnCursorExited = function(pnl)
    pnl:LerpColor("background", XeninUI.Theme.Green)
    pnl:Lerp("alpha", 0)
  end
  self.background.accept.DoClick = function(pnl)
    self:GetAccept()(pnl)
    self:Remove()
  end

  self.background.decline = self.background:Add("DButton")
  self.background.decline:SetText("Cancel")
  self.background.decline:SetFont("XeninUI.Query.Button")
  self.background.decline:SetTextColor(Color(145, 145, 145))
  self.background.decline.alpha = 0
  self.background.decline.background = XeninUI.Theme.Background
  self.background.decline.Paint = function(pnl, w, h)
    local x, y = pnl:LocalToScreen()

    BSHADOWS.BeginShadow()
      draw.RoundedBox(h / 2, x, y, w, h, XeninUI.Theme.Navbar)
    BSHADOWS.EndShadow(1, 1, 2, pnl.alpha, 0, 0)

    draw.RoundedBox(h / 2, 2, 2, w - 4, h - 4, pnl.background)
  end
  self.background.decline.OnCursorEntered = function(pnl)
    pnl:LerpColor("background", XeninUI.Theme.Navbar)
    pnl:Lerp("alpha", 200)
  end
  self.background.decline.OnCursorExited = function(pnl)
    pnl:LerpColor("background", XeninUI.Theme.Background)
    pnl:Lerp("alpha", 0)
  end
  self.background.decline.DoClick = function(pnl)
    self:GetDecline()(pnl)
    self:Remove()
  end
end

function PANEL:PerformLayout(w, h)
  self.BaseClass.PerformLayout(self, w, h)

  local y = 40
  self.background.avatar:SetPos(16, y + 16)
  self.background.avatar:SetSize(48, 48)

  self.background.name:SetPos(16 + self.background.avatar:GetWide() + 8, y + 16 + 2)
  self.background.name:SizeToContents()

  self.background.sid64:SetPos(14 + self.background.avatar:GetWide() + 8, y + 16 + 24 + 2)
  self.background.sid64:SizeToContentsY()
  self.background.sid64:SetWide(155)

  y = y + self.background.avatar:GetTall() + 40

  self.background.display:SetSize(64, 64)
  self.background.display:SetPos(16, y)

  self.background.string:SetPos(8 + 64 + 16, y)
  self.background.string:SetWide(self.background:GetWide() - 16 - 64)
  self.background.string:SizeToContentsY()

  self.background.accept:SizeToContentsY(16)
  self.background.decline:SizeToContentsY(16)
  self.background.accept:SetWide(self.background:GetWide() / 2 - 16 - 8)
  self.background.decline:SetWide(self.background:GetWide() / 2 - 16 - 8)

  local y = self.background:GetTall() - self.background.accept:GetTall() - 16

  self.background.accept:SetPos(16, y)
  self.background.decline:SetPos(self.background:GetWide() / 2 + 8, y)
end

vgui.Register("XeninUI.PurchaseConfirmation", PANEL, "XeninUI.Popup")