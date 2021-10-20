#!/bin/bash

echo "Stating checkes, please wait...\n"

kubectl exec -n colors green -c curl -- curl -sI -m1 $(kubectl -n colors get pods \
-l=color=red -o jsonpath='{.items[0].status.podIP}'):8080 &> /dev/null
GREENTORED=$?

kubectl exec -n colors blue -c curl -- curl -sI -m1 $(kubectl -n colors get pods \
-l=color=red -o jsonpath='{.items[0].status.podIP}'):8080 &> /dev/null
BLUETORED=$?

for POD in one two; do kubectl exec -n numbers $POD -c curl -- curl -sI -m1 \
$(kubectl -n colors get pods -l=color=red -o jsonpath='{.items[0].status.podIP}'):8080; \
done &> /dev/null
NUMBERSTORED=$?

if [ $GREENTORED -ne 0 ] && [ $BLUETORED -eq 0 ] && [ $NUMBERSTORED -eq 0 ]; then
  echo "The red Pod should reached any Pods in the numbers and colors Namespace \
except by the green Pod - PASSED!"
else 
  echo "The red Pod should reached any Pods in the numbers and colors Namespace \
except by the green Pod - FAILED!"
fi

echo $GREENTORED
echo $BLUETORED
echo $NUMBERSTORED