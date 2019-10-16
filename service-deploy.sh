

#!/bin/bash

# delploy two nginx in swarn A for simulating two backend servers
eval $(docker-machine env manager1)

echo "======> delploy two nginx in swarn A for simulating two backend servers ..."
docker service create \
--name backend \
--replicas 2 \
--publish 8080:80 \
nginx

# delploy nginx loadbalancer for swarm B
eval $(docker-machine env nginx)
echo "======> delploy nginx loadbalancer for swarm B ..."

docker service create \
	--with-registry-auth \
	--name loadbalancer \
	--publish 80:80 \
	192.168.5.118:5000/lwj/nginx:1.0

# reset docker env
eval $(docker-machine env -u)




