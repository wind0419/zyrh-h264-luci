-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008-2013 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

local fs = require "nixio.fs"
local cronfile = "/etc/pdfconfig.xml" 

f = SimpleForm("mediacfg", translate("Media Config"), translate("This is the config for Media Server."))

t = f:field(TextValue, "crons")
t.rmempty = true
t.rows = 33
function t.cfgvalue()
	return fs.readfile(cronfile) or ""
end

function f.handle(self, state, data)
	if state == FORM_VALID then
		if data.crons then
			fs.writefile(cronfile, data.crons:gsub("\r\n", "\n"))
			luci.sys.call("/sbin/media_resart > /dev/null 2>&1")
		else
			fs.writefile(cronfile, "")
		end
	end
	return true
end

return f
