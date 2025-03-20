# `present.nvim`

A plugin to present md files.

# Features - Lua Codeblock execution

Can execute code in lua blocks when you have them in a slide(only the first one currently)
```lua
print("Hello World!", 40)
```

# Features (JS)

Can execute code in js blocks when you have them in a slide
```javascript
console.log({myfield: true, other: false})
```

# Features (Python)

Can execute code in python blocks when you have them in a slide
```python
print("How are you doing?")
```

# Features: Other languages

Configure `opts.executor` by providing the name of the language and the executable used to run it.

# Usage

```lua
require("present").start_presentation {}
```

Use `:PresentStart` Command to begin

Use `n` and `p` to navigate the slides
Use `q` to quit the floating window

# Credits

Aditya-Chowdhary
with the help of [TJ DeVries' Advent of Neovim Playlist](https://www.youtube.com/playlist?list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM)
