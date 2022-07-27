local json = require "cjson"
local http = require "resty.http"

local plugin = {
  PRIORITY = 1000,
  VERSION = "0.1"
}

function plugin:init_worker()
  kong.log.debug("'init_worker' handler started")
end

function plugin:access(plugin_conf)
  kong.log.inspect(plugin_conf)

  local urls = plugin_conf.destinations

  local responses = {}
  if plugin_conf.aggregate then
    responses.body = ""
  end

  local client = http:new()
  for k, v in pairs(urls) do
    local settings = { method = v.method, headers = v.headers, body = v.body }
    local res, err = client:request_uri(v.uri, settings)

    if plugin_conf.aggregate then
      if not res then
        responses.body = responses.body .. plugin_conf.separator .. "error:" .. err
      else
        responses.body = responses.body .. plugin_conf.separator .. res.body
      end
    else
      local result = { uri = v.uri }
      if not res then
        result.err = err
        responses[k] = result
      else
        result.status = res.status
        result.headers = res.headers
        result.body = res.body
        responses[k] = result
      end
    end
  end


  -- JSON encode and send the response
  return kong.response.exit(200, responses)

end

return plugin
