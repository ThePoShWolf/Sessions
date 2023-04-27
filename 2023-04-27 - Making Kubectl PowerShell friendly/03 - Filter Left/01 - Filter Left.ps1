#region Pods

## Get running pods
### Where-Object
k get pod | Where-Object { $_.Status -eq 'Running' }

### Kubectl
kubectl get pod --field-selector=status.phase=Running

### Even with specialK
k get pod --field-selector=status.phase=Running


## Get non-running pods
### Where-Object
k get pod | Where-Object { $_.Status -ne 'Running' }

### Kubectl
kubectl get pod --field-selector=status.phase!=Running

### Even with specialK
k get pod --field-selector=status.phase!=Running

## Finding field selector labels
$pods = (k get pod -o json | ConvertFrom-Json).Items
$pods[0].status
$pods[0].status.phase


## Get pod by app
### Where-Object
### No reasonable way without -o json. Maybe filter on name?
k get pod | Where-Object { $_.Name -like '*apache*' }

### Kubectl (-l, --selector='')
kubectl get pod -l app=apache

### Works in specialK
k get pod -l app=apache7

## Get pod by namespace
### Where-Object
### No reasonable way without -o json.

### kubectl
kubectl get pod -n kube-system

### Note about specialK
### -n mynamespace adds another header, not currently supported
k get pod -n kube-system

## Only return pod name
### specialK
(k get pod -l app=apache --field-selector status.phase=Running)[0].name77

### kubectl
kubectl get pod -l app=apache --field-selector status.phase=Running -o=jsonpath='{.items..metadata.name}'

#endregion


#region Nodes

## Get ready nodes
### Where-Object
k get node | Where-Object { $_.Status -eq 'Ready' }7

### Kubectl
### I'm not aware of solution without awk/grep

#endregion

#region Services

## Get services by IP
### Where-Object
k get service | Where-Object { $_.'CLUSTER-IP' -eq '10.96.0.1' }

### Kubectl`
### I'm not aware of solution without awk/grep
$services = (k get service -o json | ConvertFrom-Json).items
$services[0].spec.clusterIP

kubectl get service --field-selector=spec.clusterIP=10.96.0.1

#endregion