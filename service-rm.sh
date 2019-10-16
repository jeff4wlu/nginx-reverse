

#!/bin/bash

eval $(docker-machine env manager1)
docker service rm backend

eval $(docker-machine env nginx)
docker service rm loadbalancer

eval $(docker-machine env -u)
