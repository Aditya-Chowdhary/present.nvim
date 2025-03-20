---@diagnostic disable: undefined-field
local parse = require "present"._parse_slides
local eq = assert.are.same

describe("present.parse_slides", function()
  it("should parse an empty file", function()
    eq({
      slides = {
        {
          title = '',
          body = {},
          blocks = {},
        }
      }
    }, parse {})
  end)

  it("should parse a file with 1 slide", function()
    eq({
      slides = {
        {
          title = '# This is the first slide',
          body = {
            "This is the body",
          },
          blocks = {},
        }
      }
    }, parse {
      "# This is the first slide",
      "This is the body",
    })
  end)

  it("should parse a file with 1 slide and a code block", function()
    local result = parse {
      "# This is the first slide",
      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    }

    -- Shud give only one slide
    eq(1, #result.slides)

    local slide = result.slides[1]
    eq('# This is the first slide', slide.title)
    eq({
      "This is the body",
      "```lua",
      "print('hi')",
      "```",
    }, slide.body)

    eq({
      language = 'lua',
      body = "print('hi')"
    }, slide.blocks[1])
  end)
end)
