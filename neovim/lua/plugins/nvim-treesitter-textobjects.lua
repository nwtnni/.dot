local select = {
  ["ac"] = { query = "@class.outer", mode = "V", desc = "Select around class" },
  ["ic"] = { query = "@class.inner", mode = "V", desc = "Select in class" },

  ["af"] = { query = "@function.outer", mode = "V", desc = "Select around function" },
  ["if"] = { query = "@function.inner", mode = "V", desc = "Select in function" },

  ["aa"] = { query = "@parameter.outer", desc = "Select around argument" },
  ["ia"] = { query = "@parameter.inner", desc = "Select in argument" },

  ["ab"] = { query = "@block.outer", desc = "Select around block" },
  ["ib"] = { query = "@block.inner", desc = "Select in block" },
}

local swap = {
  ["crh"] = { query = "@parameter.inner", next = false, desc = "Swap previous parameter" },
  ["crl"] = { query = "@parameter.inner", next = true, desc = "Swap next parameter" },
}

local move = {
  ["]c"] = { query = "@class.outer", next = true, desc = "Move to next class" },
  ["[c"] = { query = "@class.outer", next = false, desc = "Move to previous class" },

  ["]f"] = { query = "@function.outer", next = true, desc = "Move to next function" },
  ["[f"] = { query = "@function.outer", next = false, desc = "Move to previous function" },

  ["]a"] = { query = "@parameter.outer", next = true, desc = "Move to next argument" },
  ["[a"] = { query = "@parameter.outer", next = false, desc = "Move to previous argument" },

  ["]b"] = { query = "@block.outer", next = true, desc = "Move to next block" },
  ["[b"] = { query = "@block.outer", next = false, desc = "Move to previous block" },
}

-- Set up lazy.nvim triggers
local keys = {}

-- Set up textobjects.select
local _select = {
  enable = true,
  keymaps = {},
  selection_modes = {}
}

for key, opts in pairs(select) do
  if opts.mode then
    _select.selection_modes[opts.query] = opts.mode
  end

  opts.mode = nil
  _select.keymaps[key] = opts

  keys[#keys + 1] = {
    mode = { "o", "x" },
    key,
    desc = opts.desc,
    unique = true,
  }
end

-- Set up textobjects.swap
local _swap = {
  enable = true,
  swap_next = {},
  swap_previous = {},
}

for key, opts in pairs(swap) do
  if opts.next then
    _swap.swap_next[key] = opts.query
  else
    _swap.swap_previous[key] = opts.query
  end

  keys[#keys + 1] = {
    key,
    desc = opts.desc,
    unique = true,
  }
end

-- Set up textobjects.move
local _move = {
  enable = true,
  goto_next_start = {},
  goto_previous_start = {},
}

for key, opts in pairs(move) do
  local next = opts.next
  opts.next = nil
  if next then
    _move.goto_next_start[key] = opts
  else
    _move.goto_previous_start[key] = opts
  end

  keys[#keys + 1] = {
    key,
    desc = opts.desc,
    unique = true,
  }
end

return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = {
    "nvim-treesitter",
  },
  keys = keys,
  opts = {
    select = _select,
    swap = _swap,
    move = _move,
  },
  config = function(_, opts)
    require("nvim-treesitter.configs").setup({
      textobjects = opts,
    })
  end
}
