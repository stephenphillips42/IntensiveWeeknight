function [path, cost] = shortestpath(G, start, goal)
% SHORTESTPATH Find the shortest path from start to goal on the given Graph.
%   PATH = SHORTESTPATH(Graph, start, goal) returns an M-by-1 matrix, where each row
%   consists of the node on the path.  The first
%   row is start and the last row is goal.  If no path is found, PATH is a
%   0-by-1 matrix.
%
%   [PATH, COST] = SHORTESTPATH(...) returns the path as well as
%   the total cost of the path.
%   Arguments:
%      Graph is a N-by-3 matrix, representing all edges in the given graph.
%      Each row has the format of [U, V, W] where U and V are two nodes that
%      this edge connects and W is the weight(cost) of traveling through
%      the edge. For example, [1 5 20.2] means this edge connects
%      node 1 and 5 with cost 20.2. Please note that all edges are
%      undirected and you can assume that the nodes in Graph are indexed by
%      1, ..., n where n is the number of nodes in the Graph.
%

% Hint: You may consider constructing a different graph structure to speed up
% you code.

% OK for the dumb trivial case of an empty graph
if any(size(G) == 0)
    path = zeros(0,1);
    cost = 0;
    return
end

% Recreate graph in new data format
n = max(max(G(:,1)),max(G(:,2)));
Gr = cell(n,1); % The new an fancy graph

% Create the edges
for i = 1:size(G,1)
    Gr{G(i,1)} = [ Gr{G(i,1)}; G(i,2:3) ];
    Gr{G(i,2)} = [ Gr{G(i,2)}; G(i,[1 3]) ];
end
% Indecies for the graph data structure
grPath = 1;
grCost = 2;

% Create data structures
% What nodes have we seen, or found the min path for?
explored = zeros(n,1);

% Frontier of points we are looking at
% Initialize frontier/seen data structures
paths = ones(n,1)*Inf;
paths(start) = start;

% Separate cost vector
cost = ones(n,1)*Inf;
cost(start) = 0;

t = 1;
% Begin Djikstras
while true % Begin loop
    % Get min node and cost
    [minCost,minNode] = min(cost);
    if minCost == Inf
        path = zeros(0,1);
        cost = inf;
        break
    end
    % Short cut the algorithm if we found our goal
    if minNode == goal
        path = createPath(paths,goal,start);%[ minPaths{minPath,pathInd} ; minNode ];
        cost = minCost;
        return
    end
    % Otherwise set up for the next iteration
    % Set node to 'explored'
    explored(minNode) = true;
    cost(minNode) = Inf;
    % Update things
    for i = 1:size(Gr{minNode},1)
        node = Gr{minNode}(i,grPath);
        if explored(node)
            continue
        end
        altCost = minCost + Gr{minNode}(i,grCost);
        if altCost < cost(node) % Update the cost if smaller
            paths(node) = minNode;
            cost(node) = altCost;
        end
    end
end

% If we get here something went seriously wrong...

end


function finalpath = createPath(paths,goal,start)
p = goal;
while p(end) ~= start
    disp(p)
    p = [p; paths(p(end))];
end

finalpath = flipud(p);

end


