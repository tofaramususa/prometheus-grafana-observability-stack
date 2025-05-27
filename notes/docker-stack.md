docker swarm init

command:
docker stack deploy -c ./docker-compose.yml monitoring

docker service scale command

docker service logs command

docker stack has builtin load balancing, zero downtime with blue/green deployments using deploy command start-first
rollback to previous deployments: docker service rollback