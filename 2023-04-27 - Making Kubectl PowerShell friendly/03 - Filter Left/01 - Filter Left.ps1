#region Pods

## Get running pods
### Where-Object
k get pods | Where-Object { $_.Status -eq 'Running' }

### Kubectl
kubectl get pods --field-selector=status.phase=Running

### Even with specialK
k get pods --field-selector=status.phase=Running


## Get non-running pods
### Where-Object
k get pods | Where-Object { $_.Status -ne 'Running' }

### Kubectl
kubectl get pods --field-selector=status.phase!=Running

### Even with specialK
k get pods --field-selector=status.phase!=Running

## Finding field selector labels
$pods = (k get pods -o json | ConvertFrom-Json).Items
$pods[0].Status.Phase


## Get pod by app
### Where-Object
### No reasonable way without -o json. Maybe filter on name?
k get pods | Where-Object { $_.Name -like '*myapp*' }

### Kubectl (-l, --selector='')
kubectl get pods -l app=myapp


## Get pod by namespace
### Where-Object
### No reasonable way without -o json.

### kubectl
kubectl get pods -n mynamespace

### Note about specialK
### -n mynamespace adds another header, not currently supported


## Only return pod name
### specialK
(k get pods -l app=myapp --field-selector status.phase=Running)[0].name

### kubectl
kubectl get pods -l app=myapp --field-selector status.phase=Running -o=jsonpath='{.items..metadata.name}'

#endregion


#region Nodes

## Get ready nodes
### Where-Object
k get nodes | Where-Object { $_.Status -eq 'Ready' }

### Kubectl
### I'm not aware of solution without awk/grep

#endregion