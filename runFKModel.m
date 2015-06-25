% spacing = [ 0.445 0.45 0.455 0.465 0.47 0.475 0.48 ];
% geometry = { 'flat' 's1' 's2' 's3' 's4' 's5' 's6' };

% for i = 1:length(spacing)
%     
%     for j = 1:length(geometry)
% 
%         FKModel('Spring', 0.5, 'Geometry', geometry{j}, 'Temperature', 0, 'Damping', 3e10, 'Spacing', spacing(i))
%         
%     end
%     
% end

for i = 2:100
    
    FKModel('Run', i)
    
end

beep
