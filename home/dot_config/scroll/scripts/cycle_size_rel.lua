-- cycle_size_rel.lua <along|across> <next|prev>
--
-- scroll's cycle_size command takes an absolute axis (h = width, v = height).
-- This wrapper resolves the axis from the focused workspace's layout_type so a
-- single keybind resizes "along" the scroll axis (or "across" it) on both
-- horizontal and vertical (portrait) workspaces.
local args = ...
local scroll = require("scroll")

local role = args[1]
local dir = args[2]

local ws = scroll.focused_workspace()
local vertical = ws ~= nil and scroll.workspace_get_layout_type(ws) == "vertical"

local along = vertical and "v" or "h"
local across = vertical and "h" or "v"
local axis = (role == "across") and across or along

scroll.command(nil, "cycle_size " .. axis .. " " .. dir)
