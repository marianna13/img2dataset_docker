
# install docker
sudo apt-get install docker -y
sudo usermod -aG docker $USER
newgrp docker
docker image pull marianna13/spark-img2dataset

