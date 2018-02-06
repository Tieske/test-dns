#!/usr/bin/env resty

-- setup path to find our local libs in this repo
package.path = "./src/?.lua;" .. package.path

-- The resolver lib (OpenResty) that actually does the lookup on the name
-- server. Builds the query, connections, and parsing of the answer.
-- This is the low level library, querying for a specific name and record type.
local resolver = require "gs.dns.resolver"

-- DNS client lib (Kong) that implements searching for names by performing
-- multiple queries according to settings in /etc/resolv.conf and /etc/hosts
-- (like NDOTS, SEARCH, etc). Also implements a cache that honors TTL.
-- Higher level library, implementing a `toip()` function.
local client = require "gs.dns.client"

-- Get commandlie arguments
local NAME = assert(arg[1], "no name to resolve specified on the command line")
local TYPE = arg[2]
local INTERVAL = arg[3]
if not INTERVAL and type(tonumber(TYPE)) == "number" then
  -- type was omitted, and interval was provided
  INTERVAL = tonumber(TYPE)
  TYPE = nil
end
if TYPE then
  TYPE = client["TYPE_"..tostring(TYPE):upper()]
  assert(TYPE, "The record type must be A, AAAA, CNAME, or SRV")
end

print(
  string.rep("=", 25), " ",
  NAME,
  (TYPE and (", " .. TYPE) or ""),
  " ", string.rep("=", 25)
)


-- initialize dns client lib, same defaults as Kong
client.init({
    order = {
      --"LAST",
      "SRV",
      "A",
      "CNAME",
    },
    staleTtl = 4,
    emptyTtl = 30,
    badTtl = 1,
    hosts = "/etc/hosts",
  })

local old_answer = "nothing yet"
while true do

  -- Do a query
  local answer, err, try_list = client.resolve(NAME, { qtype = TYPE })
  if answer == old_answer then
    -- we got the same record/table as before, so it from the cache, so nothing new
  else
    -- updated record recived
    old_answer = answer

    -- prep the try-list format
    try_list = "\n\t" .. tostring(try_list):gsub("\n", "\n\t")

    -- Pretty print the results
    local pretty = require("pl.pretty").write
    print(pretty({
        answer = answer,
        error = err,
        try_list = try_list,
      }))

    -- return an error exit code if it failed
    if err then
      os.exit(1)
    end
  end

  if INTERVAL then
    -- print amessage and wait for next INTERVAL to try again
    print(("%.3f"):format(ngx.now()), " sleeping ", INTERVAL)
    ngx.sleep(INTERVAL)
  else
    -- if no INTERVAL was set, we just exit
    break
  end
end
