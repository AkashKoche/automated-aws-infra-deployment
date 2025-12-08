#!/bin/bash

apt-get update -y
apt-get install -y openjdk-11-jdk

wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
apt-get update -y
apt-get install -y jenkins

wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
mv terraform /usr/local/bin/

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

systemctl start jenkins
systemctl enable jenkins

echo "Jenkins initial admin password:"
cat /var/lib/jenkins/secrets/initialAdminPassword

sudo -u jenkins ssh-keygen -t rsa -b 4096 -f /var/lib/jenkins/.ssh/id_rsa -N ""

echo "Jenkins setup complete!"
