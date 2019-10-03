local _M = {
    _VERSION = 1.0
}

local mt = {__INDEX = _M}

global_var = "global var"



function _M.print_module()
    return "this is tab-obj function"
end


function _M.print_module_markable()
    return "hello tab-obj"
end

return _M