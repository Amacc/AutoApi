

apt install wget -y

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

add-apt-repository universe
apt-get install apt-transport-https -y
apt-get update -y
apt-get install dotnet-sdk-2.1 -y
