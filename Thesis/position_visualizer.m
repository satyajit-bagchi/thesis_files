%% Translation visualizer

close all;

ax = axes('XLim',[-3.0 3.0],'YLim',[-3.0 3.0],'ZLim',[-0.5 1.0]);
view(3)
grid on
box on
vert = [1 1 1; 1 2 1; 2 2 1; 2 1 1 ; ...
            1 1 2;1 2 2; 2 2 2;2 1 2]*0.1-0.15;
    fac = [1 2 3 4; ...
        2 6 7 3; ...
        4 3 7 8; ...
        1 5 8 4; ...
        1 2 6 5; ...
        5 6 7 8];
    h = patch('Faces',fac,'Vertices',vert,'FaceColor','r');  % patch function

t = hgtransform('Parent',ax);
set(h,'Parent',t)

Rz = eye(4);



for r = 1:length(filtered_position)
    % Z-axis rotation matrix
    %Rz = makehgtform('zrotate',eul(r,1));
    %Rz = eul2rotm([eul(r,1) eul(r,2) eul(r,3)],'ZYX');
    %transform = rotm2tform(Rz);
    
    transform = makehgtform('translate',[filtered_position(r,1) filtered_position(r,2) 0]);
    
    % Scaling matrix
    %Sxy = makehgtform('scale',r/4);
    % Concatenate the transforms and
    % set the transform Matrix property
    set(t,'Matrix',transform);
    percentage=r/length(filtered_position);
    disp(percentage*100);
    drawnow
     
end