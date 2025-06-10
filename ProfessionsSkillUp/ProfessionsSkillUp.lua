local addonName, addonTable = ...

local function split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        table.insert(t, str)
    end
    return t
end

local function skillUpText(recipeID)
    local skillUpSrc = addonTable.Data[recipeID]
    if (skillUpSrc == nil) then
        return ''
    end
    local sk = split(skillUpSrc, '/')
    if (sk[1] == '0' or sk[1] == '1') then
        return "|cffffff00" .. sk[2] .. "|r |cff8fff00" .. sk[3] .. "|r |cff8f8f8f" .. sk[4] .. "|r"
    end
    return "|cffff8f00" .. sk[1] .. "|r |cffffff00" .. sk[2] .. "|r |cff8fff00" .. sk[3] .. "|r |cff8f8f8f" .. sk[4] .. "|r"
end

local function After_ProfessionsRecipeListRecipeMixin_Init(self, node, hideCraftableCount)
	local labelSkillUp = self.labelSkillUp
	if (labelSkillUp == nil) then
		labelSkillUp = self:CreateFontString(nil, 'OVERLAY', 'GameFontHighlight_NoShadow')
		labelSkillUp:SetPoint('RIGHT', self, 'RIGHT')
		self.labelSkillUp = labelSkillUp
	end

	local elementData = node:GetData()
	local recipeID = elementData.recipeInfo.recipeID
	labelSkillUp:SetText(skillUpText(recipeID))
end

hooksecurefunc(ProfessionsRecipeListRecipeMixin, 'Init', After_ProfessionsRecipeListRecipeMixin_Init)

local function After_ProfessionsRecipeSchematicFormMixin_Init(self, recipeInfo, isRecraftOverride)
	local labelSkillUp = self.labelSkillUp
	if (labelSkillUp == nil) then
		labelSkillUp = self:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
		self.labelSkillUp = labelSkillUp
	end
	self.labelSkillUp:Hide()

	if (self.isInspection) then
		return
	end

	local isRecraft = self.RecraftingOutputText and self.RecraftingOutputText:IsShown()
	if (isRecraft) then
		return
	end

	local recipeID = recipeInfo.recipeID
	labelSkillUp:SetText(skillUpText(recipeID))
	labelSkillUp:Show()

	local minimized = ProfessionsUtil.IsCraftingMinimized()
	if (minimized) then
		labelSkillUp:SetPoint('RIGHT', self.OutputText, 'LEFT', 250, 0)
	else
		labelSkillUp:SetPoint('RIGHT', self.OutputText, 'LEFT', 290, 0)
	end
end

hooksecurefunc(ProfessionsRecipeSchematicFormMixin, 'Init', After_ProfessionsRecipeSchematicFormMixin_Init)
