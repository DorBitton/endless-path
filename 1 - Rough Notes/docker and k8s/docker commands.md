
sudo snap install docker

sudo groupadd docker 
sudo usermod -aG docker $(whoami)

sudo service docker start



docker run -d --name "name" image -> docker run -d --name testsite nginx
-d for detach

docker ps
shows all docker containers running


docker rm name -f
rm to delete, -f force

docker stop
to just stop