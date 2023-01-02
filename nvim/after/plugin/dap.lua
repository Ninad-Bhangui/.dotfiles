local dap = require('dap')
dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";
        program = "${file}";
        pythonPath = function()
            return '/usr/bin/python'
        end;
    },
}
dap.adapters.cpp = {
    type = 'executable',
    command = 'cpptools',
    env = {
        LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES"
    },
    name = "lldb"
}
dap.configurations.cpp = {
    {
        name = "Launch",
        type = "cpp",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        args = {}
    }
}
dap.configurations.c = dap.configurations.cpp
