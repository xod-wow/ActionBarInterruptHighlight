--[[----------------------------------------------------------------------------

    ActionBarInterruptHighlight
    Copyright 2026 Mike "Xodiv" Battersby

----------------------------------------------------------------------------]]--

local timerColorCurve = C_CurveUtil.CreateColorCurve()
timerColorCurve:SetType(Enum.LuaCurveType.Linear)
timerColorCurve:AddPoint(0.0, CreateColor(1, 0.5, 0.5, 1))
timerColorCurve:AddPoint(3.0, CreateColor(1, 1, 0.5, 1))
timerColorCurve:AddPoint(3.01, CreateColor(1, 1, 1, 1))
timerColorCurve:AddPoint(10.0, CreateColor(1, 1, 1, 1))

ABIHOverlayMixin = {}

function ABIHOverlayMixin:OnHide()
    self:StopAnim()
    self:StopTimer()
end

function ABIHOverlayMixin:OnUpdate()
    if self.duration then
        local color = self.duration:EvaluateRemainingDuration(timerColorCurve)
        self.Timer:SetFormattedText("%0.1f", self.duration:GetRemainingDuration())
        self.Timer:SetTextColor(color:GetRGB())
    else
        self:StopTimer()
    end
end

function ABIHOverlayMixin:StopAnim()
    if self.ProcLoop:IsPlaying() then
        self.ProcLoop:Stop()
    end
end

function ABIHOverlayMixin:StartAnim()
    self.ProcLoop:Play()
end

function ABIHOverlayMixin:StartTimer(duration)
    self.duration = duration
    self.Timer:Show()
    self:SetScript('OnUpdate', self.OnUpdate)
end

function ABIHOverlayMixin:StopTimer()
    self.duration = nil
    self.Timer:Hide()
    self:SetScript('OnUpdate', nil)
end

-- Because notInterruptible is a secret, we can no longer show/hide
-- as a result of it, best we can do is SetAlphaFromBoolean. So
-- the animation and timer are always "playing" if there's a spell
-- cast going on, and we only make them visible with alpha if the
-- cast is interruptible.

function ABIHOverlayMixin:Update(active, notInterruptible, duration)
    if active then
        self:StartAnim()
        self:StartTimer(duration)
        self:SetAlphaFromBoolean(notInterruptible, 0, 1)
        self:Show()
    else
        self:Hide()
    end
end

function ABIHOverlayMixin:Attach(actionButton)
    self:SetParent(actionButton)
    self:ClearAllPoints()
    self:SetPoint('CENTER')
    local w, h = actionButton:GetSize()
    PixelUtil.SetSize(self, w, h)
    self.ProcLoopFlipbook:SetSize(w * 1.4, h * 1.4)
end

function ABIHOverlayMixin:AlreadyOverlayed()
    local parent = self:GetParent()
    local _, spellID = GetActionInfo(parent.action)
    return spellID and C_SpellActivationOverlay.IsSpellOverlayed(spellID)
end
