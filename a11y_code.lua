-- pico-8 a11y template

-- this file contains functions
-- to interface with a webpage
-- and present text for screen
-- readers.
-- read more at https://github.com/jrjurman/pico-a11y-template

-- gpio addresses
a11y_start = 0x5f80
a11y_page_size = 128 - 4
a11y_end = a11y_start + a11y_page_size
-- has the window read the page? 0 or 1
a11y_read = a11y_end + 1
-- what page are we on?
a11y_page = a11y_end + 2
-- what is the last page?
a11y_last = a11y_end + 3

-- full text to read out
a11y_text = ""

-- update screen reader function
-- this should be called at the
-- end of your update function
function update_sr()
  -- get current page
  local has_read_page = peek(a11y_read) == 1
  local page = peek(a11y_page)
  local last_page = peek(a11y_last)

  -- if we have read this page (and there are more)
  -- reset the read counter, and update the page
  if has_read_page and page < last_page then
    page = page + 1
    poke(a11y_read, 0)
    poke(a11y_page, page)
  end

  if page <= last_page then
    -- clear previous text
    for i = a11y_start, a11y_end do
      poke(i, 0)
    end

    -- load the text for this page
    local text_start = a11y_page_size * page
    for i = 1, a11y_page_size do
      local char = ord(a11y_text, i + text_start)
      local addr = a11y_start + i
      poke(addr, char)
    end
  end
end

function set_sr_text(text)
  printh('sr:' .. text .. '\n')

  -- set text and page variables
  a11y_text = text
  local page_size = #text / a11y_page_size

  -- reset counters and set values
  poke(a11y_read, 0)
  poke(a11y_page, 0)
  poke(a11y_last, page_size)

  -- run update_sr to populate the text
  update_sr()
end

-- handle pause button
-- since this menu is not accessible
pre_paused_text = ""
function handle_pause_sr()
  -- first, check if we have pre_paused_text
  -- this is the text before pausing
  -- this will also be true right after pause menu is closed
  if pre_paused_text != "" then
    set_sr_text(pre_paused_text)
    pre_paused_text = ""
  end

  -- then, if we just paused, update the menu text
  -- and save the existing a11y text (to load later)
  if btn(6) then
    pre_paused_text = a11y_text
    set_sr_text("you've entered the pause menu, read out is not available yet, press p or enter to leave")
  end
end
