local ____lualib = require("lualib_bundle")
local __TS__Promise = ____lualib.__TS__Promise
local __TS__New = ____lualib.__TS__New
local __TS__SourceMapTraceBack = ____lualib.__TS__SourceMapTraceBack
__TS__SourceMapTraceBack(debug.getinfo(1).short_src, {["7"] = 1,["8"] = 3,["9"] = 3,["10"] = 3,["11"] = 5,["12"] = 5,["13"] = 5,["14"] = 5,["15"] = 3,["16"] = 3,["17"] = 1});
local ____exports = {}
function ____exports.Sleep(self, duration)
    return __TS__New(
        __TS__Promise,
        function(____, resolve)
            Timers:CreateTimer(
                duration,
                function() return resolve(nil, "") end
            )
        end
    )
end
return ____exports
