# Flush custom chains
iptables -t nat -F ISTIO_OUTPUT
iptables -t nat -F ISTIO_INBOUND
iptables -t nat -F ISTIO_REDIRECT
iptables -t nat -F ISTIO_IN_REDIRECT

# Delete the chains
iptables -t nat -X ISTIO_OUTPUT
iptables -t nat -X ISTIO_INBOUND
iptables -t nat -X ISTIO_REDIRECT
iptables -t nat -X ISTIO_IN_REDIRECT

# Remove the OUTPUT and PREROUTING references
iptables -t nat -D OUTPUT -p tcp -j ISTIO_OUTPUT
iptables -t nat -D PREROUTING -p tcp -j ISTIO_INBOUND
