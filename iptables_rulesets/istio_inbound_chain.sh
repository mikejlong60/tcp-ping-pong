# Create the ISTIO_INBOUND chain
iptables -t nat -N ISTIO_INBOUND

# Redirect inbound traffic to Envoy for port 80 (HTTP) to port 15006 (Envoy's inbound listener)
iptables -t nat -A ISTIO_INBOUND -p tcp --dport 80 -j REDIRECT --to-port 15006

# Redirect inbound traffic to Envoy for port 443 (HTTPS) to port 15006 (Envoy's inbound listener)
iptables -t nat -A ISTIO_INBOUND -p tcp --dport 443 -j REDIRECT --to-port 15006

# Redirect all other inbound TCP traffic to port 15006 (Envoy's inbound listener)
iptables -t nat -A ISTIO_INBOUND -p tcp -j REDIRECT --to-port 15006

# Apply the ISTIO_INBOUND chain to the PREROUTING chain for inbound traffic
iptables -t nat -A PREROUTING -p tcp -j ISTIO_INBOUND
