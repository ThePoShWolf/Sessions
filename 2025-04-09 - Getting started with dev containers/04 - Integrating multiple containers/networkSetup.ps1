# input the values of each container
$apiContainer = '0f95b4a6ec7c'
$psContainer = 'a1c69da7174e'
$networkName = 'pssummit'

# create the network
docker network create $networkName

# connect both containers to the network
docker network connect $networkName $apiContainer
docker network connect $networkName $psContainer

# examine the network
docker network inspect $networkName

# from inside the container, make an API call
Invoke-RestMethod "http://$apiContainer`:8080/helloWorld"