#docker build -t franco77/multi-client -f ./client/Dockerfile ./client
docker build -t franco77/multi-client:latest -t franco77/multi-client:$SHA -f ./client/Dockerfile ./client
# -t franco77/multi-client  --> tagging image
# -f ./client/Dockerfile    --> dove sta il dockerfile
# ./client                  --> build context di riferimento
# N.B.: se non dai tag:v è implicito tag:latest ovvero franco77/client:latest
#docker build -t franco77/multi-server -f ./server/Dockerfile ./server
docker build -t franco77/multi-server:latest -t franco77/multi-server:$SHA -f ./server/Dockerfile ./server

#docker build -t franco77/multi-worker -f ./worker/Dockerfile ./worker
docker build -t franco77/multi-worker:latest -t franco77/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# abbiamo impostato due tagging per ogni build
    # una con latest
    # e una con l'id del commit corrente di git, impostato nel config di travis

# non è necessario login un altra volta su docker - vale la login fatta in .travis.yml che chiama questo file

#docker push franco77/multi-client
#docker push franco77/multi-server
#docker push franco77/multi-worker
docker push franco77/multi-client:latest
docker push franco77/multi-server:latest
docker push franco77/multi-worker:latest
docker push franco77/multi-client:$SHA
docker push franco77/multi-server:$SHA
docker push franco77/multi-worker:$SHA
# push dell immagine su hub
# non è necessario login un altra volta su GC con service account e configurare google sdk per utilizzare kubectl - vale la login fatta in .travis.yml che chiama questo file

# abbiamo impostato due push per ogni build
    # una con latest
    # e una con l'id del commit corrente di git, impostato nel config di travis

kubectl apply -f k8s
# -f k8s    --> tutti i file presenti in dir k8s

#kubectl set image deployment/server-deployment server=franco77/multi-server
kubectl set image deployments/server-deployment server=franco77/multi-server:$SHA
# kubectl set image             --> settiamo un immagine imperatively in un deployment 
# deployment/server-deployment  --> reference all'object type su cui vogliamo fare updare, il nome lo recuperi da ./k8s/server-deployment.yaml --> metadata\name
# server=franco77/multi-server  --> server container deve usare immagine franco77/multi-server
# N.B.: anche quì se non specifichi niente è scontato tag:latest ovvero server=franco77/multi-server:latest
# N.B.: quì con latest k8s potrebbe pensare che già sta utilizzando la latest e non applicare modifiche...!?!?

kubectl set image deployments/client-deployment client=franco77/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=franco77/multi-worker:$SHA
