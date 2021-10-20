#!/bin/bash

# FROM COLORS TO NUMBERS
for POD in blue green red; do kubectl exec -n colors $POD -c curl -- curl -sI -m1 \
$(for i in $(kubectl -n numbers get pods -o jsonpath='{.items[*].status.podIP}');  \
do echo $i:8080; done); 
if [ $? -eq 0 ]
then  CHECK=FAIL
  break
fi
done &> /dev/null

if [[ $CHECK != "FAIL" ]]; then
  echo "All Pods in the colors Namespace should NOT be able to reach any Pods in \
the numbers Namespace - PASSED!"
else 
  echo "All Pods in the colors Namespace should NOT be able to reach any Pods in \
the numbers Namespace - FAILED!"
fi
