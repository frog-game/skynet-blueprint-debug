local skynet = require "skynet"

local CMD = {}

CMD.start = function(source, target)
    skynet.send(target, "lua", "ping", 1)
end


CMD.ping = function(source, count)
    local id = skynet.self()
    skynet.error("count" .. count)
    skynet.sleep(100)
    skynet.send(source, "lua", "ping", count + 1)
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...) 
        local f = assert(CMD[cmd])
        f(source, ...)
    end)

end)