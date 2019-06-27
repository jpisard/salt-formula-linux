package.path = package.path .. ';/etc/lsyncd/config.lua'
local synchrodef = require "config"

settings {
    logfile = "/var/log/lsyncd.log",
    statusFile = "/var/log/lsyncd-status.log",
    statusInterval = 20
}

for source,data in pairs(synchrodef) do
   for _,target in ipairs(data["targetlist"]) do
    excludelist=''
    car=''
    if data["exclude"] then
      for _,exclude in ipairs(data["exclude"]) do
        excludelist=excludelist..car..exclude
        car = ','
      end
    end
    extralist=''
    car=''
    if data["_extra"] then
      for _,extra in ipairs(data["_extra"]) do
        extralist=extralist..car..extra
        car = ','
      end
    end
    localsyncexclude={}
    if (excludelist ~= "") then
          localsyncexclude={exclude = {excludelist}}
    end
    localrsyncextra={}
    if (extralist ~= "") then
              localrsyncextra={_extra = {extralist}}
    end
    sync {
        default.rsync,
        localsyncexclude,
        target    = target,
        source    = source,
        delay     = data["delay"],
        delete    = data["delete"],
        rsync     = {
            binary   = '/usr/bin/rsync',
            compress = tostring(data["compress"]),
            update = tostring(data["update"]),
            perms = tostring(data["perms"]),
            localrsyncextra,
        }
    }

   end
end
