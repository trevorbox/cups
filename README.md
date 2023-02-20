# cups

Deploy [CUPS](https://en.wikipedia.org/wiki/CUPS) on Openshift.

> Note: this is to test running the registry.redhat.io/rhel9/cups:latest image.

```sh
helm upgrade -i cups helm/cups -n cups --create-namespace
```

expose with route (for testing)...

```sh
export INGRESS_DOMAIN=$(oc get ingress.config.openshift.io cluster -o jsonpath={.spec.domain})
helm upgrade -i cups helm/cups -n cups --create-namespace -f helm/cups/values-expose.yaml --set ingress.hosts[0].host=cups-cups.${INGRESS_DOMAIN}
```

or...

```sh
oc port-forward $(oc get pods -n cups -o name) -n cups 6631:6631
```
