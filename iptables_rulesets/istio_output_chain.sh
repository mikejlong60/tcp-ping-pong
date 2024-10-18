# Create the ISTIO_OUTPUT chain
iptables -t nat -N ISTIO_OUTPUT

# Bypass Envoy for traffic destined for loopback addresses (127.0.0.0/8)
iptables -t nat -A ISTIO_OUTPUT -d 127.0.0.0/8 -j RETURN

# Allow traffic that is already handled by Envoy itself by matching on the UID (e.g., UID 1337 for Envoy)
# Replace "1337" with the UID of your Envoy sidecar process if different
iptables -t nat -A ISTIO_OUTPUT -m owner --uid-owner 1337 -j RETURN

# Redirect all remaining outbound TCP traffic to Envoy's outbound listener port 15001
iptables -t nat -A ISTIO_OUTPUT -p tcp -j REDIRECT --to-port 15001

# Redirect outbound traffic from the OUTPUT chain to ISTIO_OUTPUT
iptables -t nat -A OUTPUT -p tcp -j ISTIO_OUTPUT
