# syncthing-docker-arm
Dockerfile and docker-compose for using on an arm device e.g. the Raspberry PI 3.

I use it at home on my Raspberry PI3 and it works great.

Usage is exaclty like in the offical build for x86/amd64:
https://github.com/syncthing/syncthing/blob/main/README-Docker.md

Just don't forget to change the link to this image. ;)

If you want to use a docker-compose file, you can use the one in the repository or copy it from here:

```
version: '3.1'
services:
  syncthing:
    # use build instead of image if you want to build the image by yourself
    build: 
        context: .
    image: njay289/syncthing-arm:latest
    restart: always
    container_name: syncthing
    # Use network_mode or ports. See Docker reference for difference. 'host' is needed for local discovery.
    network_mode: 'host'
    #ports:
    #  - 0.0.0.0:8384:8384
    #  - 22000:22000
    #  - 21027:21027
    volumes:
      # Adjust to your needs
       - /mnt/hdd1/syncthing_data:/var/syncthing
```

Just adjust the path for the volume in the docker-compose.yaml and do:

```
docker-compose up -d
```
