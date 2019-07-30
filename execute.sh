APISERVER=https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS
echo getting SA $PODSERVICEACCOUNT token
TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)
echo podip=$PODIP, podname=$PODNAME, pod_sa=$PODSERVICEACCOUNT, nodename=$NODENAME
file="/etc/config/extendedresources.properties"

if [ -f "$file" ]; then
  echo "$file found."
  while [ true ]; do

    reloadinternval=60
    while IFS='=' read -r key value; do
      key=$(echo $key | tr '.' '_')
      eval ${key}=\${value}
      if [ $key == "reloadinternval" ]; then
        echo $reloadinternval set to $value
        reloadinternval=$value
      else
        echo ******** patching node $NODENAME with extended resource $key=$value ********
        curl --header "Content-Type: application/json-patch+json" --request PATCH --data '[{"op": "add", "path":  "/status/capacity/'"${key}"'", "value": "'"${value}"'"}]' $APISERVER/api/v1/nodes/$NODENAME/status --header "Authorization: Bearer $TOKEN" --insecure
      fi
    done <"$file"
    echo Sleeping for $reloadinternval, good night!
    sleep $reloadinternval

  done
else
  echo " config $file not found."
fi
exit 0

#curl --header "Content-Type: application/json-patch+json" --request PATCH --data '[{"op": "add", "path": "/status/capacity/something", "value": "9"}]' $APISERVER/api/v1/nodes/$NODENAME/status --header "Authorization: Bearer $TOKEN" --insecure
