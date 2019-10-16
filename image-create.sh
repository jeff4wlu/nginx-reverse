

#!/bin/bash

docker rmi 192.168.5.118:5000/lwj/nginx:1.0

# build a personal nginx image
echo "======> build a personal nginx image ..."
echo $(docker-machine ip manager1)
echo $(docker-machine ip worker1)
docker build --build-arg MANAGER_IP=$(docker-machine ip manager1) \
	--build-arg WORKER_IP=$(docker-machine ip worker1) \
    	-t 192.168.5.118:5000/lwj/nginx:1.0 .
docker push 192.168.5.118:5000/lwj/nginx:1.0
echo "=====> show built image ..."
docker images
