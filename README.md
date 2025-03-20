# `present.nvim`

A plugin to present md files.

# Features

Can execute code in lua blocks when you have them in a slide
```lua
print("Hello World!", 40)
```

# Usage

```lua
require("present").start_presentation {}
```

Use `n` and `p` to navigate the slides
Use `q` to quit the floating window

# Credits

Aditya-Chowdhary
with the help of [TJ DeVries' Advent of Neovim Playlist](https://www.youtube.com/playlist?list=PLep05UYkc6wTyBe7kPjQFWVXTlhKeQejM)
