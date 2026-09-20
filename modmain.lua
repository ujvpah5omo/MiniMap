if not (GLOBAL.TheNet:GetIsClient() or
(GLOBAL.TheNet:GetServerIsClientHosted() and GLOBAL.TheNet:GetIsServerAdmin() and
not GLOBAL.TheNet:GetIsClient() and
not GLOBAL.TheNet:IsDedicated())) then
return
end

local mapscale = GetModConfigData("Minimap Size")
local ultrawide = GetModConfigData("Ultrawide")
local position_str = GetModConfigData("Position")
local margin_size_x = GetModConfigData("Horizontal Margin")
local margin_size_y = GetModConfigData("Vertical Margin")
local ups = GetModConfigData("Updates Per Second")

local dir_vert = 0
local dir_horiz = 0
local anchor_vert = 0
local anchor_horiz = 0
local margin_dir_vert = 0
local margin_dir_horiz = 0
local y_align, x_align = position_str:match("(%a+)_(%a+)")

if x_align == "left" then
	dir_horiz = -1
	anchor_horiz = 1
	margin_dir_horiz = 1
elseif x_align == "center" then
	dir_horiz = 0
	anchor_horiz = 0
	margin_dir_horiz = 0
elseif x_align == "right" then
	dir_horiz = 1
	anchor_horiz = -1
	margin_dir_horiz = -1
end

if y_align == "top" then
	dir_vert = 0
	anchor_vert = -1
	margin_dir_vert = -1
elseif y_align == "middle" then
	dir_vert = -1
	anchor_vert = 0
	margin_dir_vert = 0
elseif y_align == "bottom" then
	dir_vert = -2
	anchor_vert = 1
	margin_dir_vert = 1
end

----------------------------------------
-- Do the stuff
----------------------------------------

local require = GLOBAL.require
local unpack = GLOBAL.unpack

local function PositionMiniMap(controls, screensize)
	local hudscale = controls.top_root:GetScale()
	local screenw_full, screenh_full = unpack(screensize)
	local screenw = screenw_full/hudscale.x
	local screenh = screenh_full/hudscale.y
	controls.minimap_small:SetPosition(
		(anchor_horiz*controls.minimap_small.mapsize.w/2)+(dir_horiz*screenw/2)+(margin_dir_horiz*margin_size_x), 
		(anchor_vert*controls.minimap_small.mapsize.h/2)+(dir_vert*screenh/2)+(margin_dir_vert*margin_size_y), 
		0
	)
end

local function IsMiniMapWidgetValid(minimap)
	return minimap ~= nil
		and minimap.inst ~= nil
		and minimap.inst:IsValid()
end

local function GetCurrentMiniMapWidget()
	local player = GLOBAL.ThePlayer
	local hud = player ~= nil and player.HUD or nil
	local controls = hud ~= nil and hud.controls or nil
	local minimap = controls ~= nil and controls.minimap_small or nil

	if IsMiniMapWidgetValid(minimap) then
		return minimap
	end
end

-- create a minimap widget as a child of the controls widget
local function AddMiniMap(controls)

	-- for some reason, without this the game would crash without an error when calling controls.topright_root:AddChild
	-- too lazy to track down the cause, so just using this workaround
	controls.inst:DoTaskInTime( 0, function()
		if controls == nil
			or controls.inst == nil
			or not controls.inst:IsValid()
			or controls.top_root == nil
			or IsMiniMapWidgetValid(controls.minimap_small) then
			return
		end

		-- add the minimap widget and set its position
		local MiniMapWidget = require "widgets/minimapwidget"

		controls.minimap_small = controls.top_root:AddChild( MiniMapWidget( mapscale, ultrawide ) )
		local screensize = {GLOBAL.TheSim:GetScreenSize()}
		local hudscale = controls.top_root:GetScale()
		PositionMiniMap(controls, screensize)

		local OnUpdate_base = controls.OnUpdate
		controls.OnUpdate = function(self, dt, ...)
			local returnValues = {OnUpdate_base(self, dt, ...)}
			local curscreensize = {GLOBAL.TheSim:GetScreenSize()}
			local curhudscale = controls.top_root:GetScale()
			if curscreensize[1] ~= screensize[1] or curscreensize[2] ~= screensize[2]
			or curhudscale.x ~= hudscale.x or curhudscale.y ~= hudscale.y then
				PositionMiniMap(controls, curscreensize)
				screensize = curscreensize
				hudscale = curhudscale
			end
			return unpack(returnValues)
		end

		-- Handle every controls-level path that can open or close the map.
		-- Newer game versions use ShowMap/HideMap in addition to ToggleMap.
		local function WrapMapMethod(method_name)
			local base = controls[method_name]
			if base == nil then
				return
			end

			controls[method_name] = function(self, ...)
				local minimap = self.minimap_small
				if not IsMiniMapWidgetValid(minimap) then
					return base(self, ...)
				end

				local map_was_open = self.owner ~= nil
					and self.owner.HUD ~= nil
					and self.owner.HUD:IsMapScreenOpen()

				if not map_was_open and minimap:IsVisible() then
					minimap:Hide()
				end

				local returnValues = {base(self, ...)}
				local map_is_open = self.owner ~= nil
					and self.owner.HUD ~= nil
					and self.owner.HUD:IsMapScreenOpen()

				if not map_is_open and not minimap:IsVisible() then
					minimap:Show()
				end

				return unpack(returnValues)
			end
		end

		WrapMapMethod("ToggleMap")
		WrapMapMethod("ShowMap")
		WrapMapMethod("HideMap")

		controls.minimap_small:SetUPS(ups)
	end)

end

AddClassPostConstruct( "widgets/controls", AddMiniMap )

-- Restore the minimap no matter how the map screen was closed. This includes
-- map actions, transports, and calls to TheFrontEnd:PopScreen().
local MapScreen = require "screens/mapscreen"

local MapScreen_OnDestroy_base = MapScreen.OnDestroy
MapScreen.OnDestroy = function(self, ...)
	local controls = self.owner ~= nil and self.owner.HUD ~= nil and self.owner.HUD.controls or nil
	local current_minimap = controls ~= nil and controls.minimap_small or GetCurrentMiniMapWidget()
	local returnValues = {MapScreen_OnDestroy_base(self, ...)}

	if IsMiniMapWidgetValid(current_minimap) then
		current_minimap:Show()
	end

	return unpack(returnValues)
end

-- keep track of zooming while on the map screen
local MapWidget = require "widgets/mapwidget"

local MapWidget_OnZoomIn_base = MapWidget.OnZoomIn
MapWidget.OnZoomIn = function(self, deltazoom, ...)
	local returnValues = {MapWidget_OnZoomIn_base( self, deltazoom, ... )}
	local current_minimap = GetCurrentMiniMapWidget()
	if current_minimap ~= nil and self.shown then
		current_minimap:SetMapScreenZoom(self.minimap:GetZoom())
	end
	return unpack(returnValues)
end

local MapWidget_OnZoomOut_base = MapWidget.OnZoomOut
MapWidget.OnZoomOut = function(self, deltazoom, ...)
	local returnValues = {MapWidget_OnZoomOut_base( self, deltazoom, ... )}
	local current_minimap = GetCurrentMiniMapWidget()
	if current_minimap ~= nil and self.shown then
		current_minimap:SetMapScreenZoom(self.minimap:GetZoom())
	end
	return unpack(returnValues)
end
