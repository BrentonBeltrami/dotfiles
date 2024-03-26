return {
  "nocksock/do.nvim",
  message_timeout = 2000, -- how long notifications are shown
  kaomoji_mode = 1, -- 0 kaomoji everywhere, 1 skip kaomoji in doing
  winbar = false,
  doing_prefix = "Doing: ",
  store = {
    auto_create_file = true, -- automatically create a .do_tasks when calling :Do
    file_name = ".do_tasks",
  },
}
