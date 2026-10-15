function [ connected_neighbours ] = ConnectedNeighbours( padded_segments,psz,i )
%CONNECTEDNEIGHBOURS Summary of this function goes here
%   Detailed explanation goes here


   [srow, scol]=find(padded_segments==i);
   
   
   
   sright=scol+1;
   sleft=scol-1;
    
   sbottom =srow+1;
   stop =srow-1;
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   rightind = sub2ind(psz, srow, sright);
   leftind=sub2ind(psz, srow, sleft);
    
   bottomind=sub2ind(psz, sbottom, scol);
   topind = sub2ind(psz, stop, scol);
   
   
   
   %%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   rightnei=padded_segments(rightind);
   leftnei=padded_segments(leftind);
    
   topnei=padded_segments(topind);
   bottomnei=padded_segments(bottomind);
   
   
   %%%%%%%%%%%%%%%%%%
   
   
nei=[rightnei' leftnei' topnei' bottomnei'];
    %nei
    unei=unique(nei);
    %unei
    connected_neighbours=unei(unei>=0 & unei~=i);

end

