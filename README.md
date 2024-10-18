# maze_solver

A* Algorithm for Maze Solving
Description:
In this project, you will implement the A* algorithm to find the shortest path through a maze.
The maze will be represented as a grid, and you will visualize the maze along with the nodes
tested during the search process.

<img width="258" alt="Screenshot 2024-10-18 at 19 03 17" src="https://github.com/user-attachments/assets/e37467da-b814-4b16-8313-b4c4eb00f200">


Make sure your tool has the following:
- Maze Generation: Create a maze generator that provides users with the option to either
generate random mazes or manually design their own maze by adding walls, start points,
and goal points through a graphical user interface (GUI)
o The user may add up to two targets
- Maze Solving Algorithms:
o Implement the search algorithm using A*
o As heuristic function allows the user to select between Manhattan distance, and
Euclidean distance
o Display on the screen how many steps you need to reach the target, and the
tested nodes

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
