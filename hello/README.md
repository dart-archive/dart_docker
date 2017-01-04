# google/dart-hello

[`google/dart-hello`](https://hub.docker.com/r/google/dart-hello) is a
[docker](https://docker.io) image for a simple Dart HTTP server.

It is based on
[`google/dart-runtime`](https://hub.docker.com/r/google/dart-runtime)
base image and listen on port `8080`.

## Run the Dart HTTP server in the docker container

Run the following command to start the server application:

    docker run -d -p 8080:8080 google/dart-hello

## Access the server

If you are using boot2docker you need to access the server on the
doot2docker host network. The command `boot2docker ip` will give the
hosts address on that network.

    curl http://`boot2docker ip 2> /dev/null`:8080/version

If you are running the docker daemon directly on a Linux host, you can
access the server on `localhost`

    curl http://localhost:8080/version

## Access the Observatory

If you want to access the Observatory as well as the server
application also map port 8181 to the host.

    docker run -d -p 8080:8080 -p 8181:8181 google/dart-hello

If you are using boot2docker the following command will give the URL of
the Observatory:

    echo http://$(boot2docker ip 2> /dev/null):8181/

If you are running the docker daemon directly on a Linux host, the
URL of the Observatory is:

    http://localhost:8181/

## Running on Google Compute Engine

The Google Compute Engine has support for
[Container-optimized Google Compute Engine images][1],
which is Google Compute Engine extending its support for Docker containers.

If you are using a Google Cloud project you can deploy to a container VM
using the [`gcloud`][3] tool. First create a
container manifest file called `container.yaml` with the following content:

    version: v1beta2
    containers:
      - name: dart-hello
        image: google/dart-hello
        ports:
          - name: dart-hello
            hostPort: 80
            containerPort: 8080

Then create and start a Compute Engine VM with the configuration
specified in `container.yaml` by running the following command:

    $ gcloud compute instances create dart-hello \
        --image container-vm-v20141016 \
        --image-project google-containers \
        --machine-type f1-micro
        --metadata-from-file google-container-manifest=container.yaml
        --tag http-server

When the command completes, the external IP address of the new server is
displayed. Navigate you browser to http://<server IP>/. It might take a few
minutes for the VM to pull the image and start the container.

## Running on Google Container Engine

The Google Cloud Platform has an Alpha release of [Google Container Engine][2],
which can also be used to run Docker containers. See the documentation for
more information on the capabilities of Container Engine.

If you are using a Google Cloud project you can create a Container Engine
cluster and deploy to it using the [`gcloud`][3]
tool.

    $ gcloud preview container clusters create dart-hello \
        --num-nodes 1
    $ gcloud preview container pods create dart-hello \
        --image=google/dart-hello \
        --port=8080
    $ gcloud compute firewall-rules create hello-dart-node-8080 \
        --allow tcp:8080 \
        --target-tags k8s-hello-dart-node

The first command creates a cluster with just one node. The second creates
a "pod" (which is a group of containers) inside that cluster
running the Docker image `google/dart-hello`. The last command will open
the firewall for traffic on port `8080` providing public access to the
Dart server.

To discover the public IP address of the Dart server, run this command:

    $ gcloud preview container pods describe dart-hello

The IP address is displayed as part of the `Host` column in the output.
Navigate you browser to http://<server IP>:8080/. It might take a few
minutes for the VM to pull the image and start the "pod".

[1]: https://cloud.google.com/compute/docs/containers/container_vms
[2]: https://cloud.google.com/container-engine/docs/
[3]: https://cloud.google.com/sdk/
