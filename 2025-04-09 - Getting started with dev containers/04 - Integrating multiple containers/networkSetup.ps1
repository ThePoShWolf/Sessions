# input the values of each container
$apiContainer = ''
$psContainer = ''

# create the network
docker network create pssummit

# connect both containers to the network
docker network connect pssummit $apiContainer
docker network connect pssummit $psContainer

# examine the network
docker network inspect pssummit

# from inside the container, make an API call
Invoke-RestMethod "http://$apiContainer`:8080/helloWorld"