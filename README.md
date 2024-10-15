TCP Ping Pong Client and server

Purpose: Test routing enforcement of TCP/IP traffic in plaintext mode

Building:
* cd pkg
* go mod init
* go mod tidy
* cd ../
* make docker-build-client
* make docker-build-server


Deployment in Plain docker compose
* docker compose up

You should see successful ping-pong logs between client and server.

Now -- Use iptables to restrict access from client to server by telling client to redirect 
   egress to another port on server with iptables. Connection to server should fail.

Then -- deploy this lash up into Istio in two different pods and do the same by hand after running 
iptables by hand  in client container to simulate client talking to server through
sidecar in client pod.