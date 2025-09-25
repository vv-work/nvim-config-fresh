local ok, codesnap = pcall(require, "codesnap")
if not ok then
  return
end

-- Ensure a valid default save directory exists to prevent 'file not found'
-- Use ~/tmp as requested
local save_dir = vim.fn.expand("~") .. "/tmp"
if vim.fn.isdirectory(save_dir) == 0 then
  pcall(vim.fn.mkdir, save_dir, "p")
end

codesnap.setup({
  -- Defaults are good; set a safe save path.
  save_path = save_dir,
  -- You can tweak other options later: bg_theme, watermark, has_breadcrumbs, etc.
})

-- Helper: copy a PNG image to the system clipboard (macOS/Linux)
local function copy_image_to_clipboard(path)
  if vim.fn.filereadable(path) ~= 1 then
    vim.notify("Image not found: " .. path, vim.log.levels.ERROR)
    return
  end

  local has = function(bin)
    return vim.fn.executable(bin) == 1
  end

  local sys = vim.loop.os_uname().sysname
  local cmd

  if sys == "Darwin" then
    if has("pngpaste") == 1 then
      cmd = string.format("pngpaste -p < %q", path)
    elseif has("kitty") == 1 then
      cmd = string.format("kitty +kitten clipboard --mime-type image/png < %q", path)
    else
      vim.notify("pngpaste not found. Install with: brew install pngpaste", vim.log.levels.WARN)
      return
    end
  else
    if has("wl-copy") == 1 then
      cmd = string.format("wl-copy --type image/png < %q", path)
    elseif has("xclip") == 1 then
      cmd = string.format("xclip -selection clipboard -t image/png -i %q", path)
    elseif has("kitty") == 1 then
      cmd = string.format("kitty +kitten clipboard --mime-type image/png < %q", path)
    else
      vim.notify("Install wl-clipboard or xclip to copy images to clipboard", vim.log.levels.WARN)
      return
    end
  end

  local ok_run = os.execute(cmd)
  if ok_run then
    vim.notify("Image copied to clipboard", vim.log.levels.INFO)
  else
    vim.notify("Failed to copy image to clipboard", vim.log.levels.ERROR)
  end
end

-- Command: Copy latest CodeSnap image to clipboard
vim.api.nvim_create_user_command("CodeSnapCopyLast", function()
  local glob = save_dir .. "/*"
  local files = vim.fn.glob(glob, true, true)
  if not files or #files == 0 then
    vim.notify("No CodeSnap images found in " .. save_dir, vim.log.levels.WARN)
    return
  end
  table.sort(files, function(a, b)
    return (vim.fn.getftime(a) or 0) > (vim.fn.getftime(b) or 0)
  end)
  copy_image_to_clipboard(files[1])
end, {})

-- Command: Copy an arbitrary image path
vim.api.nvim_create_user_command("CopyImage", function(opts)
  copy_image_to_clipboard(vim.fn.expand(opts.args))
end, { nargs = 1, complete = "file" })
