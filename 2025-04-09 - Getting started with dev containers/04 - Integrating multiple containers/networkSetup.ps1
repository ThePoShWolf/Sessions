# input the id or name of each container
# can get values by running docker ps
# or in the container by running hostname
$apiContainer = '45b17ea9a67a'
$psContainer = '367429cdd36a'
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