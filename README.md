# vim-time

Records the total time you spend in Neovim.


### Commands

- **`:Time`**: Displays the total time you have spent in Neovim across all sessions.

### Installation

To install via LazyVim, create `vim-time.lua` file under `lua/plugins` folder and add the following:

```
return {
    {
      "CoderParth/vim-time",
      priority = 1000, -- Make sure to load this before all the other start plugins.
      init = function()
        require 'time'
      end,
    }
}
