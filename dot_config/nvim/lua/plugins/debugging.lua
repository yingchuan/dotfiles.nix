return {

  -- 1. mason-nvim-dap：自動安裝 codelldb 和 cpptools 調試器
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      -- 確保安裝 C/C++ 所需的兩個 DAP 調試器
      ensure_installed = { "codelldb", "cpptools" },
      automatic_installation = true,
      handlers = {}, -- 使用預設處理器
    },
  },

  -- 2. nvim-dap 本體設定：配置 C/C++ 的 DAP 適配器和調試設定
  {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    config = function()
      local dap = require("dap")
      local mason_path = vim.fn.stdpath("data") .. "/mason" -- Mason 安裝根目錄

      -- 設定 codelldb 適配器（LLDB 後端）
      local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
          -- 在 Windows 上執行可能需要: detached = false,
        },
      }

      -- 設定 cpptools/cppdbg 適配器（GDB 後端，使用 MI 介面）
      local cpptools_path = mason_path .. "/packages/cpptools/extension/debugAdapters/bin/OpenDebugAD7"
      dap.adapters.cppdbg = {
        id = "cppdbg",
        type = "executable",
        command = cpptools_path,
        options = { detached = false }, -- 如果需要，可將調試程序與 Neovim 分離
      }

      -- C/C++ 調試配置：包括使用 GDB 或 LLDB 的 Launch/Attach
      dap.configurations.cpp = {
        -- 使用 LLDB (codelldb) 啟動程式
        {
          name = "Launch (LLDB -> codelldb)",
          type = "codelldb", -- 對應上方 dap.adapters.codelldb
          request = "launch",
          program = function()
            -- 提示使用者輸入執行檔路徑
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
          -- 可選：如果需要終端互動，可加入 runInTerminal = true
        },
        -- 使用 GDB (cppdbg) 啟動程式
        {
          name = "Launch (GDB -> cppdbg)",
          type = "cppdbg", -- 對應上方 dap.adapters.cppdbg
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopAtEntry = false,
          MIMode = "gdb",
          miDebuggerPath = "/home/linuxbrew/.linuxbrew/bin/gdb", -- WSL/Linux 下 GDB 的路徑
          setupCommands = { -- GDB 初始化指令，啟用漂亮打印等
            {
              text = "-enable-pretty-printing",
              description = "enable pretty printing",
              ignoreFailures = false,
            },
          },
        },
        -- 使用 GDB 附加至現有進程
        {
          name = "Attach (GDB -> cppdbg)",
          type = "cppdbg",
          request = "attach",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          MIMode = "gdb",
          miDebuggerPath = "/home/linuxbrew/.linuxbrew/bin/gdb",
          processId = require("dap.utils").pick_process, -- 提示選擇進程ID附加
        },
      }
      -- 將 C 的配置複用為 C++ 的配置（兩者使用相同設定）
      dap.configurations.c = dap.configurations.cpp

      -- 方便的除錯操作快捷鍵綁定
      local d = "開始/繼續除錯"
      vim.keymap.set("n", "<F5>", function()
        dap.continue()
      end, { desc = d })
      vim.keymap.set("n", "<leader>dc", function()
        dap.continue()
      end, { desc = d })

      d = "停止除錯"
      vim.keymap.set("n", "<S-F5>", function()
        dap.terminate()
      end, { desc = d })
      vim.keymap.set("n", "<leader>dt", function()
        dap.terminate()
      end, { desc = d })

      d = "切換斷點"
      vim.keymap.set("n", "<F9>", function()
        dap.toggle_breakpoint()
      end, { desc = d })
      vim.keymap.set("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = d })

      d = "逐步執行 (Step Over)"
      vim.keymap.set("n", "<F10>", function()
        dap.step_over()
      end, { desc = d })
      vim.keymap.set("n", "<leader>ds", function()
        dap.step_over()
      end, { desc = d })

      d = "步入函式 (Step Into)"
      vim.keymap.set("n", "<F11>", function()
        dap.step_into()
      end, { desc = d })
      vim.keymap.set("n", "<leader>di", function()
        dap.step_into()
      end, { desc = d })

      d = "步出函式 (Step Out)"
      vim.keymap.set("n", "<F12>", function()
        dap.step_out()
      end, { desc = d })
      vim.keymap.set("n", "<leader>do", function()
        dap.step_out()
      end, { desc = d })
    end,
  },

  -- 3. nvim-dap-ui 設定：提供介面並自動開啟/關閉
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio", -- Dap-ui 介面所需的 nvim-nio 插件
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup({}) -- 使用預設設定啟動 DAP UI

      -- 在啟動調試時自動打開 UI，結束調試後關閉 UI
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
    keys = {
      -- 快捷鍵：<leader>du 切換顯示 DAP UI
      {
        "<leader>du",
        function()
          require("dapui").toggle({})
        end,
        desc = "切換 DAP UI",
      },
      -- 快捷鍵：<leader>de 評估變數或表達式（Normal 模式下評估光標所在字詞，Visual 模式下評估選取區域）
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "表達式求值",
        mode = { "n", "v" },
      },
    },
  },

  -- （可選）4. nvim-dap-virtual-text 插件：在程式執行時於程式碼中顯示變數的即時值
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    opts = {}, -- 啟用虛擬文字顯示，使用預設設定即可
  },
}
