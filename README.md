# setextendedresourcebash
setextendedresourcebash


Daemonset that apply extended resources to node its deployed on. Config is applied via a curl patch command https://kubernetes.io/docs/tasks/administer-cluster/extended-resource-node/
 
 * expects a config map called "config"
 * applies all all configuration inside the config map. 
 * script is executed every 60 seconds or reloaded based on the "reloadinternval=60" in the config map 
 * dameonset uses the downward api to discover the node its running on
 * auth against the kube api is based on the pods service account 
 







