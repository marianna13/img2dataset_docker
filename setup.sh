
# install docker
CLUSTER_TYPE=$1
sudo apt-get install docker.io -y
sudo usermod -aG docker $USER
newgrp docker
docker image pull marianna13/$CLUSTER_TYPE-img2dataset

