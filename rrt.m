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
start_tree(1).q = [start(1, 1) start(1, 2) start(1, 3)];

goal_tree(1).id = 1;
goal_tree(1).parent = -1;
goal_tree(1).q = [goal(1, 1) goal(1, 2) goal(1, 3)];


curr_iter = 0;
curr_start_index = 2;
curr_goal_index = 2;

while(curr_iter < max_iterations)
   
    %% Generate random q  
    % Currently using naive randome sampling
    curr_q = [lower_limits(1, 1)*rand(1) 
              lower_limits(1, 2)*rand(1)
              lower_limits(1, 3)*rand(1)] ;
    
    is_collided = false;
    n_times_added = 0; 
    
    %% Check for Collision
    is_collided = isRobotCollided([curr_q(1, 1) curr_q(1, 2) curr_q(1, 3) 
                     start(1, 4) start(1, 5) start(1, 6)]);
   
    if is_collided == true
        continue;
    end
                 
    %% Find Closest Point in the current start tree
    closest_index = 0;             
    
    closest_distance = Inf;
    for i = 1:curr_start_index
        current_distance = norm(curr_q - start_tree(i).value);
        if(current_distance < closest_distance)
            closest_distance = current_distance;
            closest_index = i;
        end
    end
    
    %% Do Collision Checking on the entire segment
    interpolated_points = interpolate(curr_q, start_tree(closest_index).q);
    for i = 1:interpolated_points.size()
        if(isRobotCollided == true)
            is_collided = true;
            break;
        end
    end
    
    %% Add to the graph
    if is_collided == false
        start_tree(curr_start_index).id = curr_start_index;
        start_tree(curr_start_index).parent = closest_index;
        start_tree(curr_start_index).q = curr_q;
        n_times_added = n_times_added + 1;
    end
    
    %% Find Closest Point in the current goal tree
    closest_index = 0;             
    closest_distance = Inf;
    for i = 1:curr_goal_index
        current_distance = norm(curr_q - goal_tree(i).value);
        if(current_distance < closest_distance)
            closest_distance = current_distance;
            closest_index = i;
        end
    end
    
    %% Do Collision Checking on the entire line segment
    interpolated_points = interpolate(curr_q, goal_tree(closest_index).q);
    for i = 1:interpolated_points.size()
        if(isRobotCollided == true)
            is_collided = true;
            break;
        end
    end
    
    %% Add to the graph
    if is_collided == false
        goal_tree(curr_goal_index).id = curr_goal_index;
        goal_tree(curr_goal_index).parent = closest_index;
        goal_tree(curr_goal_index).q = curr_q;
        n_times_added = n_times_added + 1;
    end

    %% Check if both the previous conditions were satisfied
    if(n_times_added == 2)
       
       reverse_path = []; 
       straight_path = []; 
       %% Path Found 
       fprintf("Start and Goal trees connected"); 
        
       i = current_start_index;
       %% Back Trace on both trees
       while(i ~= 1)
          i = start_tree(i).parent;
          reverse_path = [reverse_path; start_tree(i).q];
       end
       
       i = curr_goal_index;
       while(i ~= 1)
          i = goal_tree(i).parent;
          straight_path = [straight_path; goal_tree(i).q];
       end
       
       path = [flip(reverse_path) straight_path];
          
    end
    
end

end