% Constraint based planning algorithm with uncertainty
% Path planning for Dubins vehicle

% note: measure angles in [-pi,pi], compatible with atan2

clear;
clc;
close all;

path1 = getenv('PATH')
path1 = [path1 ':/usr/local/bin']
setenv('PATH', path1)
!echo $PATH 

tic

% path to drawing functions and creation of workspace
%path('./drawingFns',path);
%path('./collisionCheck',path);

% Workspace dimensions
width = 30;
height = 30;

% workspace = list of obstacles
wksp = createWorkspace(width,height);

% Initial configuration
initpos = [0;0];

% Goal configuration
goalpos = [29;29];

drawWorkspace(width, height, initpos, goalpos, wksp);

% max time of single step between 2 nodes / potential mode switches
% we randomize in the interval [minStepTime,maxStepTime]
minStepTime = 3;
maxStepTime = 30;


maxNumberOfHops = 4;

for number_of_hops = 1:1:maxNumberOfHops
    
    generateZ3File (initpos, goalpos, number_of_hops);
    
    system('z3 constraints.smt2 > output');
    
    [unsatFlag, CP] = processZ3Output ();
    
    number_of_hops
    unsatFlag
    
    if unsatFlag == 0
        px = [];
        py = [];
        for count=1:1:number_of_hops + 1
            ax = CP(count).x;
            by = CP(count).y;
            size(ax);
            size(px);
            px = cat(1, px, [ax]);
            py = cat(1, py, [by]);
            
            plot (0.0, 0.0, '*r');
        end
        
        
        plot(px, py, '-bl', 'LineWidth',2);
        break;
    end
end


toc