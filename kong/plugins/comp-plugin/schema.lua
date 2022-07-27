local typedefs = require "kong.db.schema.typedefs"

local PLUGIN_NAME = "comp-plugin"

local schema = {
  name = PLUGIN_NAME,
  fields = {
    { config = {
      type = "record",
      fields = {
        {
          aggregate = {
            type = "boolean",
            default = false,
          },
        },
        { destinations = { type = "array", required = true, default = {},
          elements = {
            type = "record",
            fields = {
              { uri = { type = "string", required = true, match = "^https?://" } },
              { method = { type = "string", required = true, one_of = { "GET", "POST", "PUT", "DELETE", } } },
              { headers = { type = "array", required = false, default = {}, elements = { type = "string", } } },
              { body = { type = "string", required = false, default = " " } },
            }
          } },
        },
      }
    },
    },
  },
}

return schema
