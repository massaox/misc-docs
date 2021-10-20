1 - All Pods in the numbers Namespace should be able to reach any Pods in the colors Namespace.
2 - All Pods in the colors Namespace should NOT be able to reach any Pods in the numbers Namespace.
3 - The blue Pod should be able to reach the green Pod.
4 - The green Pod should NOT be able to reach the blue Pod.
5 - The only Pod (in the colors and numbers Namespace) that should NOT be able to reach the red Pod is the green Pod.