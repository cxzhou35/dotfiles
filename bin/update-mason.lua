local function wait_for(label, done, timeout)
  if not vim.wait(timeout, done, 100) then
    error(label .. " timed out")
  end
end

local function update()
  require("lazy").load({ plugins = { "mason.nvim" } })
  local registry = require("mason-registry")

  local registry_done = false
  local registry_ok = false
  local registry_result
  print("Refreshing Mason registries...")
  registry.update(function(ok, result)
    registry_ok = ok
    registry_result = result
    registry_done = true
  end)
  wait_for("Mason registry refresh", function()
    return registry_done
  end, 300000)
  if not registry_ok then
    error("Mason registry refresh failed: " .. vim.inspect(registry_result))
  end

  local packages = registry.get_installed_packages()
  table.sort(packages, function(a, b)
    return a.name < b.name
  end)

  local pending = 0
  local updated = 0
  local failures = {}
  for _, package in ipairs(packages) do
    local current = package:get_installed_version()
    local latest = package:get_latest_version()
    if current ~= latest then
      pending = pending + 1
      print(("Updating %s: %s -> %s"):format(package.name, current or "unknown", latest))
      local started, err = pcall(function()
        package:install({}, function(ok, result)
          if ok then
            updated = updated + 1
            print("Updated " .. package.name)
          else
            failures[#failures + 1] = package.name .. ": " .. tostring(result)
          end
          pending = pending - 1
        end)
      end)
      if not started then
        failures[#failures + 1] = package.name .. ": " .. tostring(err)
        pending = pending - 1
      end
    end
  end

  wait_for("Mason package updates", function()
    return pending == 0
  end, 1800000)
  if #failures > 0 then
    error("Mason updates failed:\n" .. table.concat(failures, "\n"))
  end
  print(("Mason: %d updated, %d already current."):format(updated, #packages - updated))
end

local ok, err = xpcall(update, debug.traceback)
if not ok then
  vim.api.nvim_err_writeln(err)
  vim.cmd.cquit(1)
end
