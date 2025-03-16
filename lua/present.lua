local M = {}

local function create_floating_window(config)
  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, config)

  return { buf = buf, win = win }
end

M.setup = function()
  -- nothing
end

---@class present.Slides
---@fields slides present.Slide[]: The slides of the file

---@class present.Slide
---@field title string: The title of the slide
---@field body string[]: The body of the slide

--- Takes some lines and parses them
---@param lines string[]: The lines in the buffer
---@return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  local current_slide = {
    title = "",
    body = {},
  }

  local separator = "^#"

  for _, line in ipairs(lines) do
    if line:find(separator) then
      if #current_slide.title > 0 then
        table.insert(slides.slides, current_slide)
      end

      current_slide = {
        title = line,
        body = {}
      }
    else
      table.insert(current_slide.body, line)
    end
  end
  table.insert(slides.slides, current_slide)

  return slides
end

M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  local parsed = parse_slides(lines)

  -- local win_config = {
  --   relative = "editor",
  --   width = width,
  --   height = height,
  --   col = col,
  --   row = row,
  --   style = "minimal",
  --   border = { " ", " ", " ", " ", " ", " ", " ", " ", }
  -- }
  local width = vim.o.columns
  local height = vim.o.lines

  ---@type vim.api.keyset.win_config[]
  local windows = {
    header = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      col = 1,
      row = 0,
    },
    body = {
      relative = "editor",
      width = width,
      height = height - 2,
      style = "minimal",
      col = 1,
      row = 1,
    },
    -- footer = {},
  }
  local header_float = create_floating_window(windows.header)
  local body_float = create_floating_window(windows.body)

  local set_slide_content = function(idx)
    local slide = parsed.slides[idx]

    vim.api.nvim_buf_set_lines(header_float.buf, 0, -1, false, { slide.title })
    vim.api.nvim_buf_set_lines(body_float.buf, 0, -1, false, slide.body)
  end

  local current_slide = 1
  vim.keymap.set("n", "n", function()
    current_slide = math.min(current_slide + 1, #parsed.slides)
    set_slide_content(current_slide)
  end, {
    desc = "Next slide",
    buffer = body_float.buf
  })

  vim.keymap.set("n", "p", function()
    current_slide = math.max(current_slide - 1, 1)
    set_slide_content(current_slide)
  end, {
    desc = "Previous slide",
    buffer = body_float.buf
  })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(body_float.win, true)
  end, {
    desc = "Close Window",
    buffer = body_float.buf
  })

  local restore = {
    cmdheight = {
      original = vim.o.cmdheight,
      present = 0,
    },
  }

  -- Set the options we want during presentation
  for option, config in pairs(restore) do
    vim.opt[option] = config.present
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = body_float.buf,
    callback = function()
      -- Reset the values to the original when closing
      for option, config in pairs(restore) do
        vim.opt[option] = config.original
      end

      pcall(vim.api.nvim_win_close, header_float.win, true)
    end
  })

  set_slide_content(current_slide)
end

M.start_presentation({ bufnr = 61 })
-- vim.print(parse_slides {
--   "# Hello",
--   "This is something else",
--   "# World",
--   "This is another thing",
-- })

return M
