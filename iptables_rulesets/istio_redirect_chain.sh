# Create the ISTIO_REDIRECT chain
iptables -t nat -N ISTIO_REDIRECT

# Redirect outbound TCP traffic to Envoy's outbound listener on port 15001
iptables -t nat -A ISTIO_REDIRECT -p tcp -j REDIRECT --to-port 15001

# Apply the ISTIO_REDIRECT chain in the OUTPUT chain for outgoing traffic
iptables -t nat -A OUTPUT -p tcp -j ISTIO_REDIRECT
