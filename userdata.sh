#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2
echo "Server is UP!" | sudo tee /var/www/html/index.html
