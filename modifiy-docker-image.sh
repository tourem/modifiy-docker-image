docker stop akhq_config_containe
docker rm akhq_config_containe
winpty docker create --name akhq_container tchiotludo/akhq:latest
docker cp akhq/application.yml akhq_container:/app
docker rmi tchiotludo/akhq-config:latest
docker commit akhq_container tchiotludo/akhq-config:latest
docker stop akhq_container
docker rm akhq_container
winpty docker run --name akhq_config_containe -d -p 8080:8080 tchiotludo/akhq-config:latest
docker logs akhq_config_containe
