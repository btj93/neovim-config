return {
  -- Required fields
  name = "go run",
  builder = function(params)
    local cwd = vim.v.cwd or vim.fn.getcwd()
    local env_vars = Load_env_vars()
    -- This must return an overseer.TaskDefinition
    return {
      -- cmd is the only required field
      cmd = 'air --build.cmd "go build -o ./bin/api ./cmd/main.go" --build.bin ./bin/api',
      -- additional environment variables
      env = env_vars,
      cwd = cwd,
      -- the list of components or component aliases to add to the task
      components = { "default" },
      -- arbitrary table of data for your own personal use
      metadata = {
        foo = "bar",
      },
    }
  end,
  -- Tags can be used in overseer.run_template()
  tags = { require("overseer").TAG.BUILD },
  params = {
    -- See :help overseer-params
  },
  -- Determines sort order when choosing tasks. Lower comes first.
  priority = 50,
  -- Add requirements for this template. If they are not met, the template will not be visible.
  -- All fields are optional.
  condition = {
    filetype = { "go" },
  },
}
