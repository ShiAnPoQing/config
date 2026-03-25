local U = require("reasonable-scroll.util")
local Scroll = require("reasonable-scroll.scroll")
local ScrollPage = require("reasonable-scroll.scroll_page")
local ScrollViewport = require("reasonable-scroll.scroll_viewport")

local M = {
  scroll_up = Scroll.scroll_up,
  scroll_down = Scroll.scroll_down,
  scroll_right = Scroll.scroll_right,
  scroll_left = Scroll.scroll_left,
  scroll_viewport_top = ScrollViewport.scroll_viewport_top,
  scroll_viewport_bottom = ScrollViewport.scroll_viewport_bottom,
  scroll_viewport_left = ScrollViewport.scroll_viewport_left,
  scroll_viewport_right = ScrollViewport.scroll_viewport_right,
  scroll_viewport_vertical_center = ScrollViewport.scroll_viewport_vertical_center,
  toggle_scroll_up = Scroll.toggle_scroll_up,
  toggle_scroll_down = Scroll.toggle_scroll_down,
  toggle_scroll_left = Scroll.toggle_scroll_left,
  toggle_scroll_right = Scroll.toggle_scroll_right,
  scroll_page_up = ScrollPage.scroll_page_up,
  scroll_page_down = ScrollPage.scroll_page_down,
  scroll_half_page_left = ScrollPage.scroll_half_page_left,
  scroll_half_page_right = ScrollPage.scroll_half_page_right,
  i_scroll_up = U.insert_mode(Scroll.scroll_up),
  i_scroll_down = U.insert_mode(Scroll.scroll_down),
  i_scroll_right = U.insert_mode(Scroll.scroll_right),
  i_scroll_left = U.insert_mode(Scroll.scroll_left),
  i_scroll_page_up = U.insert_mode(ScrollPage.scroll_page_up),
  i_scroll_page_down = U.insert_mode(ScrollPage.scroll_page_down),
  i_scroll_half_page_left = U.insert_mode(ScrollPage.scroll_half_page_left),
  i_scroll_half_page_right = U.insert_mode(ScrollPage.scroll_half_page_right),
}

return M
