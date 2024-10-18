TCP Ping Pong Client and server

Purpose: Test routing enforcement of TCP/IP traffic in plaintext mode

Building:
* cd pkg
* go mod init
* go mod tidy
* cd ../
* make docker-build-client
* make docker-build-server


Deployment in Plain docker compose(on master branch))
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



This TCP Client Server(on with-envoy branch) running inside a containerized Envoy setup where the TCP Client's pings to the TCP Server go
through an Envoy proxy.
`docker compose -f envoy-docker-compose.yaml up`


Notes on Further Work:  10/18/2024
I gleaned a set of IP Tables rules with the help of Chat GPT 
that are close to what Envoy uses when it is running inside Istio with sidecar injection. And I have confirmed
that all the rules at least execute without error.  And running them breaks connectivity of the client to server and
the container crashes. 

You do not need to enable CNI mode for Istio.  The rules should be the same anyway. And Kind and Istio and Envoy do not seem to work
with CNI enabled.  All the rules here execute without error. Delete them all with the delete script.
One caveat is that you will have to confirm the UID of an Envoy Sidecar in a Kubernetes Pod and adjust the rule
that qualifies on that value. This is why I say we need to start using Kubernetes now and the current setup of Docker compose won't work. 

They are in iptables_rulesets directory in the client image.

Next Steps:
  Goal - Improve your understanding of the IP tables rules for Sidecar redirection and verify/correct the rules you got from Chat GPT.
 - Steps
   - Switch over to an Istio install with my TCP client running in its own pod and my TCP server running in another pod.
   - Look at the IP tables rules in your ruleset and see how accurate your rules are given that you have Istio configured to have the same requirement(i.e force the redirection of packets from the client to go through the Envoy sidecar in the Client pod).

