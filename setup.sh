
# install docker
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
newgrp docker
docker image pull marianna13/ray-img2dataset

