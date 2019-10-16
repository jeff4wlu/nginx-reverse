
#!/bin/bash
# Swarm mode using Docker Machine
#This configures the number of workers and managers in the swarm
managers=1
workers=1

# This creates the manager machines
echo "======> Creating $managers manager machines ...";
for node in $(seq 1 $managers);
do
	echo "======> Creating manager$node machine ...";
	docker-machine create -d kvm --kvm-boot2docker-url ~/.docker/machine/cache/boot2docker.iso manager$node;
done

# This create worker machines
echo "======> Creating $workers worker machines ...";
for node in $(seq 1 $workers);
do
	echo "======> Creating worker$node machine ...";
	docker-machine create -d kvm --kvm-boot2docker-url ~/.docker/machine/cache/boot2docker.iso worker$node;
done
# This lists all machines created
docker-machine ls


# initialize swarm mode and create a manager
echo "======> Initializing first swarm manager ..."
docker-machine ssh manager1 "docker swarm init --listen-addr $(docker-machine ip manager1) --advertise-addr $(docker-machine ip manager1)"

# get manager and worker tokens
export manager_token=`docker-machine ssh manager1 "docker swarm join-token manager -q"`
export worker_token=`docker-machine ssh manager1 "docker swarm join-token worker -q"`

for node in $(seq 2 $managers);
do
	echo "======> manager$node joining swarm as manager ..."
	docker-machine ssh manager$node \
		"docker swarm join \
		--token $manager_token \
		--listen-addr $(docker-machine ip manager$node) \
		--advertise-addr $(docker-machine ip manager$node) \
		$(docker-machine ip manager1)"
done

# workers join swarm
for node in $(seq 1 $workers);
do
	echo "======> worker$node joining swarm as worker ..."
	docker-machine ssh worker$node \
	"docker swarm join \
	--token $worker_token \
	--listen-addr $(docker-machine ip worker$node) \
	--advertise-addr $(docker-machine ip worker$node) \
	$(docker-machine ip manager1):2377"
done

# create swarm B for nginx reversing service
# use parameter --engine-insecure-registry to set --allow-insecure-ssl for docker's daemon
# http: server gave http response to https client
echo "======> create swarm B ..."
docker-machine create -d kvm --engine-insecure-registry 192.168.5.118:5000  --kvm-boot2docker-url ~/.docker/machine/cache/boot2docker.iso nginx;

# initialize swarm mode and create a manager
echo "======> Initializing swarm B manager ..."
docker-machine ssh nginx "docker swarm init --listen-addr $(docker-machine ip nginx) --advertise-addr $(docker-machine ip nginx)"


