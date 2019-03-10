

sudo apt install wget -y

wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb

sudo apt install dotnet-sdk-2.1 -y
