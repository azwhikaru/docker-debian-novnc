#!/bin/bash
sudo docker run -d --name debian-vnc \
  -p 8080:8080 \
  debian
