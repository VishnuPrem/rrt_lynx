function [path] = rrt(map, start, goal)
% RRT Find the shortest path from start to goal.
%   PATH = rrt(map, start, goal) returns an mx6 matrix, where each row
%   consists of the configuration of the Lynx at a point on the path. The 
%   first row is start and the last row is goal. If no path is found, PATH 
%   is a 0x6 matrix. 
%
% INPUTS:
%   map     - the map object to plan in
%   start   - 1x6 vector of the starting configuration
%   goal:   - 1x6 vector of the goal configuration

%% RRT Parameters

max_iterations = 10000;
max_resolution 

lower_limits = robot.lowerLim;
upper_limits = robot.upperLim;

%% RRT Algorithm
path = [];

start_tree(1).id = 1;
start_tree(1).parent = -1;
start_tree(1).value = [start(1, 1) start(1, 2) start(1, 3)];

goal_tree(1).id = 1;
goal_tree(1).parent = -1;
goal_tree(1).value = [goal(1, 1) goal(1, 2) goal(1, 3)];


curr_iter = 0;
curr_start_index = 2;
curr_goal_index = 2;



while(curr_iter < max_iterations)
   
    %% Generate random q  
    % Currently using naive randome sampling
    curr_q = [lower_limits(1, 1)*rand(1) 
              lower_limits(1, 2)*rand(1)
              lower_limits(1, 3)*rand(1)] ;
    
    %% Check for Collision
    is_collided = isRobotCollided([curr_q(1, 1) curr_q(1, 2) curr_q(1, 3) 
                     start(1, 4) start(1, 5) start(1, 6)]);
               
    if is_collided ~= true
        closest_index = 0;
        closest_distance = Inf;
        %% Find Closest Point in the current start tree
        for i = 1:curr_start_index
            current_distance = norm(curr_q - start_tree(i).value);
            if(current_distance < closest_distance)
                closest_distance = current_distance;
                closest_index = i;
            end
        end
        %% Do Collision Checking
            %% Add to the graph
    
        %% Find Closest Point in the current start tree
        %% Do Collision Checking
            %% Add to the graph
        
        %% Check if both the previous conditions were satisfied
            %% Path Found 
            %% Back Trace on both trees 
    end
end

end