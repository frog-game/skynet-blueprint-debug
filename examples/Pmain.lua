local skynet = require "skynet"
local socket = require "skynet.socket"
local mysql = require "skynet.db.mysql"
-- skynet.start(function()
--     skynet.error("skynet start")
--     local ping1 = skynet.newservice("ping")
--     local ping2 = skynet.newservice("ping")

--     skynet.send(ping1, "lua", "start", ping2);
--     skynet.exit();


-- end
-- )


-- part2
clients = {}
obj = {}
function connect(fd, addr)
    skynet.error("fd:" .. fd .. "addr:" ..addr)
    socket.start(fd)
    clients[fd] = obj
    while true do 
        local readdata = socket.read(fd)
        if readdata ~= nil then
            skynet.error(fd .. " send " .. readdata)
            for _fd, _ in pairs(clients) do
                if _fd ~= fd then
                    socket.write(_fd, readdata)
                end 
            end
        else
            skynet.error("close terminate")
            socket.close(fd)
            return
        end
    end
end
skynet.start(function()
    local listenfd = socket.listen("0.0.0.0", 8888)
    socket.start(listenfd, connect)
end)