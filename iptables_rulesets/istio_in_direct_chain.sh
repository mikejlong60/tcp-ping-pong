# Create the ISTIO_IN_REDIRECT chain
iptables -t nat -N ISTIO_IN_REDIRECT

# Redirect all inbound traffic (from the pod itself) to Envoy's inbound listener on port 15006
iptables -t nat -A ISTIO_IN_REDIRECT -p tcp -j REDIRECT --to-port 15006

# Apply the ISTIO_IN_REDIRECT chain in the OUTPUT chain for local pod-to-pod traffic
iptables -t nat -A OUTPUT -p tcp -j ISTIO_IN_REDIRECT
