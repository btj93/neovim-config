return {
  -- Required fields
  name = "live preview d2",
  builder = function(params)
    local cwd = vim.v.cwd or vim.fn.getcwd()
    local buf_path = vim.api.nvim_buf_get_name(0)
    -- This must return an overseer.TaskDefinition
    return {
      -- cmd is the only required field
      cmd = { "d2" },
      args = { "fmt", buf_path, "&&", "d2", "--watch", buf_path, buf_path .. ".svg" },
      -- additional environment variables
      env = {},
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
    filetype = { "d2" },
  },
}
