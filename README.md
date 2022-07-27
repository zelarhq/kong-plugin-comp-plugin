# Plugin Creation Steps

## Install Pongo CLI

```
PATH=$PATH:~/.local/bin
git clone https://github.com/Kong/kong-pongo.git
mkdir -p ~/.local/bin
ln -s $(realpath kong-pongo/pongo.sh) ~/.local/bin/pongo
```

## Clone the template plugin from Kong GITHUB

```
git clone https://github.com/Kong/kong-plugin.git kong-api-version-plugin

pongo run
 - To initialise the docker images for postgres, cassandra and kong library`
```

## Create a new folder with only the basic files of plugin

- kong / plugins / comp-plugin
  - handler.lua
  - schema.lua
- spec / comp-plugin
  - 01-unit_test.lua
  - 01-intgration_spec.lua
- kong-plugin-comp-plugin-0.1.0-1.rockspec
- README.md

## Run the new plugin shell with kong and pongo

- pongo up
- pongo shell

- kong version
- kong migrations bootstrap --force
- kong start

# Assessment Steps

### List plugins

```
curl http://localhost:8001/plugins
```

## Adding services and routes to kong

```
http post localhost:8001/services name=httpbin url=http://httpbin.org/anything
```

```
http post localhost:8001/services/httpbin/routes paths:='["/httpbin"]'
```

### Verify endpoint

```
http :8000/httpbin
```

## Add our auth plugin to the service
```
http post localhost:8001/services/httpbin/plugins name=comp-plugin config:='{"destinations":[{"uri":"https://62c52085a361f725127aecd2.mockapi.io/users", "method":"GET" }, {"uri":"https://apimocha.com/testemp/example", "method":"POST", "body": "{\"name\":\"rover\"}" }], "aggregate": true }'
```

## Testing new plugin

```
http localhost:8000/httpbin
```