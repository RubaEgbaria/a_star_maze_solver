# maze_solver

A* algorithm
g(n) = cost of the path from the start node to node n
h(n) = heuristic that estimates the cost of the cheapest path from n to the goal
f(n) = g(n) + h(n)
f(n) = stepsToGoal + stepsToStart
current node -> check neighbours -> calculate f(n) -> add to open list
open list -> sort by f(n) -> remove node with lowest f(n) -> add to closed list
if two neighbours have the same f(n), choose the one with the lowest h(n)
if f(n) and h(n) are the same, choose randomly

<!-- Video preview -->

https://github.com/user-attachments/assets/bae37e00-d8d3-49bf-ac71-4a702c09e267


[Watch the maze preview](lib/assets/maze_preview.mov)
