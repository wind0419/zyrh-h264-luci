
local fs = require "nixio.fs"
local m,s,olt,opt

m = Map("netset", translate("RemoteCtrl"), translate("Communicate with Server by TCP"))
s = m:section(TypedSection, "netset", translate("Remote Configuration"))
s.addremove = false
s.anonymous = true
s:tab("netset1", translate("remoteipport"))

this_tab = "netset1"
opt = s:taboption(this_tab, Value, "deviceid", translate("Dev ID"))
opt:value("LteRouter")

opt = s:taboption(this_tab, Value, "remote_ip", translate("Remote Ip"))
opt.datatype = "ip4addr"
opt.placeholder = "122.227.179.90"

opt = s:taboption(this_tab, Value, "remote_port", translate("Remote Port"))
opt.placeholder = "8000"
opt.datatype    = "port"

opt = s:taboption(this_tab, DummyValue, "gps_info", translate("GPS Info"))
opt.default="init..."
function opt.cfgvalue(...)
	return fs.readfile("/tmp/gps_info") or "init..."
end

opt = s:taboption(this_tab, DummyValue, "agps_info", translate("AGPS Info"))
opt.default="init..."
function opt.cfgvalue(...)
	return fs.readfile("/tmp/agps_info") or "init..."
end

opt = s:taboption(this_tab, DummyValue, "on_off", translate("Online Info"))
opt.default = "Offline"
function opt.cfgvalue(...)
	return fs.readfile("/tmp/onoffline") or "Offline"
end


local apply = luci.http.formvalue("cbi.apply")
if(apply) then
	io.popen("/sbin/renew.sh")
end

return m
