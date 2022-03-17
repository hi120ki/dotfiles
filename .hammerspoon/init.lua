wifiMenu = hs.menubar.new()
wifiMenu:setTitle(hs.wifi.currentNetwork())

wifiWatcher = nil

function ssidChanged()
    local wifiName = hs.wifi.currentNetwork()
    if wifiName then
        wifiMenu:setTitle(wifiName)
    else
        wifiMenu:setTitle("Wi-Fi OFF")
    end
end

wifiWatcher = hs.wifi.watcher.new(ssidChanged):start()

pingMenu = hs.menubar.new()

function pingResult(object, message, seqnum, error)
    if message == "didFinish" then
        avg = math.floor(tonumber(string.match(object:summary(), '/(%d+.%d+)/')))
        if avg == 0.0 then
            pingMenu:setTitle("No Network")
        else
            pingMenu:setTitle("" .. avg .. "ms")
        end
    elseif message == "sendPacketFailed" then
        pingMenu:setTitle("No Network")
    end
end

function ping()
    hs.network.ping.ping("8.8.8.8", 1, 0.01, 1.0, "any", pingResult)
end

ping()

hs.timer.new(60, ping):start()
