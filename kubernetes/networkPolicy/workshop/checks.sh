#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "Starting checks, please wait..."
echo ""

# FROM NUMBERS TO COLORS
for POD in one two; do kubectl exec -n numbers $POD -c curl -- curl -sI -m1 \
$(for i in $(kubectl -n colors get pods -o jsonpath='{.items[*].status.podIP}');  \
do echo $i:8080; done); 
if [ $? -ne 0 ]
then  
  CHECK=FAIL
  break
fi
done &> /dev/null

if [[ $CHECK != "FAIL" ]]; then
  echo "1 - All Pods in the numbers Namespace should be able to reach any Pods in the \
colors Namespace - PASSED!"
else 
  echo "1 - All Pods in the numbers Namespace should be able to reach any Pods in the \
colors Namespace - FAILED!"
fi

# FROM COLORS TO NUMBERS
for POD in blue green red; do kubectl exec -n colors $POD -c curl -- curl -sI -m1 \
$(for i in $(kubectl -n numbers get pods -o jsonpath='{.items[*].status.podIP}');  \
do echo $i:8080; done); 
if [ $? -eq 0 ]
then  
  CHECK=FAIL
  break
fi
done &> /dev/null

if [[ $CHECK != "FAIL" ]]; then
  echo "2 - All Pods in the colors Namespace should NOT be able to reach any Pods in \
the numbers Namespace - PASSED!"
else 
  echo "2 - All Pods in the colors Namespace should NOT be able to reach any Pods in \
the numbers Namespace - FAILED!"
fi

# FROM BLUE TO GREEN
kubectl exec -n colors blue -c curl -- curl -sI -m1 $(kubectl -n colors get pods \
-l=color=green -o jsonpath='{.items[0].status.podIP}'):8080 &> /dev/null
BLUETTOGREEN=$?

if [ $BLUETTOGREEN -eq 0 ]; then
  echo "3 - The blue Pod should be able to reach the green Pod - PASSED!"
else 
  echo "3 - The blue Pod should be able to reach the green Pod - FAILED!"
fi

# FROM GREEN TO BLUE
kubectl exec -n colors green -c curl -- curl -sI -m1 $(kubectl -n colors get pods \
-l=color=blue -o jsonpath='{.items[0].status.podIP}'):8080 &> /dev/null
GREENTOBLUE=$?

if [ $GREENTOBLUE -ne 0 ]; then
  echo "4 - The green Pod should NOT be able to reach the blue Pod - PASSED!"
else 
  echo "4 - The green Pod should NOT be able to reach the blue Pod - FAILED!"
fi

# FROM GREEN TO RED
kubectl exec -n colors green -c curl -- curl -sI -m1 $(kubectl -n colors get pods \
-l=color=red -o jsonpath='{.items[0].status.podIP}'):8080 &> /dev/null
GREENTORED=$?

# FROM BLUE TO RED
kubectl exec -n colors blue -c curl -- curl -sI -m1 $(kubectl -n colors get pods \
-l=color=red -o jsonpath='{.items[0].status.podIP}'):8080 &> /dev/null
BLUETORED=$?

# FROM NUMBERS TO RED
for POD in one two; do kubectl exec -n numbers $POD -c curl -- curl -sI -m1 \
$(kubectl -n colors get pods -l=color=red -o jsonpath='{.items[0].status.podIP}'):8080;
if [ $? -ne 0 ]
then  
  CHECK=FAIL
  break
fi
done &> /dev/null

if [ $GREENTORED -ne 0 ] && [ $BLUETORED -eq 0 ] && [[ $CHECK != "FAIL" ]]; then
  echo "5 - The only Pod (in the colors and numbers Namespace) that should NOT \
be able to reach the red Pod is the green Pod.- PASSED!"
else 
  echo "5 - The only Pod (in the colors and numbers Namespace) that should NOT \
be able to reach the red Pod is the green Pod.- FAILED!"
fi