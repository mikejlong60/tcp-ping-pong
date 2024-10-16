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
Note that you need to destroy the network each time you run this docker compose with: `docker system prune`

Now -- Use iptables in client container(you added it with Makefile)
    to restrict access from client to server by telling client to redirect 
egress to another port on server with iptables. Connection to server should fail.

Notes :
Step 1: Log into client container with docker exec as root.
Step 2: Issue this command: `echo "Hello TCP server!" | nc server.docker 8888`.  This should work.
Step 3: Block traffic from client to server with IP tables rule: `iptables -A OUTPUT -d server.docker -p tcp -j DROP`
Step 4. Verify that you cannot talk to server with: `echo "Hello, UDP server!" | nc server.docker 8888`.  This should hang.
Step 5. Delete the previous IP tables rule blocking traffic to server: `iptables -D OUTPUT -d server.docker -p tcp -j DROP`
Step 6: Issue this command: `echo "Hello Tcp server!" | nc server.docker 8888`.  This should work.



Blocking traffic to server.docker on client side with iptables: `iptables -A OUTPUT -d server.docker -p tcp -j DROP`
Viewing the existing IP tables rules: `iptables -L -n -v`
Deleting previous rule. Traffic should flow again wth nc or in your Go client loop: `iptables -D OUTPUT -d server.docker -p tcp -j DROP`

Then -- deploy this lash up into Envoy and do the same by hand after running 
iptables by hand  in client container to simulate client talking to server through
sidecar in client pod.



