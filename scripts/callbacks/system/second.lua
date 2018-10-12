--
-- (C) 2013-18 - ntop.org
--

local dirs = ntop.getDirs()
package.path = dirs.installdir .. "/scripts/lua/modules/?.lua;" .. package.path
package.path = dirs.installdir .. "/scripts/lua/modules/timeseries/?.lua;" .. package.path

-- do NOT include lua_utils here, it's not necessary, keep it light!
local callback_utils = require "callback_utils"
local ts_utils = require("ts_utils_core")
require("ts_second")

-- Toggle debug
local enable_second_debug = false
local ifnames = interface.getIfNames()
local when = os.time()

local function interface_rrd_creation_enabled(ifid)
   return (ntop.getPref("ntopng.prefs.ifid_"..ifid..".interface_rrd_creation") ~= "false")
      and (ntop.getPref("ntopng.prefs.interface_rrd_creation") ~= "0")
end

callback_utils.foreachInterface(ifnames, interface_rrd_creation_enabled, function(ifname, ifstats)
   if(enable_second_debug) then print("Processing "..ifname.."\n") end

  if(ifstats["localstats"]["bytes"]["remote2local"] > 0) then
    ts_utils.append("iface:download", {ifid=ifstats.id, bytes=ifstats["localstats"]["bytes"]["remote2local"]}, when, verbose)
  end

  if(ifstats["localstats"]["bytes"]["local2remote"] > 0) then
    ts_utils.append("iface:upload", {ifid=ifstats.id, bytes=ifstats["localstats"]["bytes"]["local2remote"]}, when, verbose)
  end

   -- Traffic stats
   ts_utils.append("iface:traffic", {ifid=ifstats.id, bytes=ifstats.stats.bytes}, when)
   ts_utils.append("iface:packets", {ifid=ifstats.id, packets=ifstats.stats.packets}, when)

   -- ZMQ stats
   if ifstats.zmqRecvStats ~= nil then
      ts_utils.append("iface:zmq_recv_flows", {ifid=ifstats.id, num_flows=ifstats.zmqRecvStats.flows}, when)
   else
      -- Packet interface
      ts_utils.append("iface:drops", {ifid=ifstats.id, packets=ifstats.stats.drops}, when)
   end
end)
