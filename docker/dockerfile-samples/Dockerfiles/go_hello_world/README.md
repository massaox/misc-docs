In this directory you will find three Dockerfile to build a simple hello-world app.
However they all used a different runtime Image which drastically impact of the final
size of the image. From a machine with Docker running execute the following 2 commands:

```bash
docker build -f ubuntu.Dockerfile -t raftx/ubuntu-hello-world:v1 .
docker build -f golag.Dockerfile -t raftx/golang-hello-world:v1 .
docker build -f distroless.Dockerfile -t raftx/distroless-hello-world:v1 .
```

Once all images are build run the following command to compare their sizes:

```bash
docker images | grep hello-world
```