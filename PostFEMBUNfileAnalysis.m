% Post FEMBUN file analysis
clc

% [fixedPointNames,fixedStds] = readStdFromFEBMUNoutput('LargeTest1');
[freePointNames,freeStds] = readStdFromFEBMUNoutput('LargeTest2000n free net');
%%
% figure,
% % subplot(1,2,1),
% hist(fixedStds), title('Fixed Network')
% xlabel('Standard deviation in direction of least precision [m]')
% % set(gca,'xlim',[0,0.2]),set(gca,'ylim',[0,300])

% subplot(1,2,2),
hist(freeStds), title('Free Network')
xlabel('Standard deviation in direction of least precision [m]')
% set(gca,'xlim',[0,0.2]),set(gca,'ylim',[0,300])
%%

% for i = 1:length(fixedPointNames)
%     for  j = 1:length(points)
%         if strcmp(fixedPointNames(i,:), points(j).pointName)
%             points(j).stdFixed = fixedStds(i);
%             break;
%         end
%     end
% end

for i = 1:length(freePointNames)
    for  j = 1:length(points)
        if strcmp(freePointNames(i,:), points(j).pointName)
            points(j).stdFN = freeStds(i);
            break;
        end
    end
end


%% Output pts file (Fixed)

% fid = fopen('PhotoPointCloudFixed.pts','w');
% %  fid = fopen('PhotoPointCloud.pts','w');
% 
% for i =  1:length(points)
%     outputString = [num2str(points(i).xyz(1)),', ',num2str(points(i).xyz(2)),...
%         ', ',num2str(points(i).xyz(3)),', ',num2str(points(i).stdFixed),'\n'];
%     if points(i).stdFixed ~= 0;
%         fprintf(fid,outputString);
%     end
% end
% % fclose(fid);

%% Output pts file (Free network)

fid = fopen('PhotoPointCloudFree.pts','w');

for i =  1:length(points)
    outputString = [num2str(points(i).xyz(1)),', ',num2str(points(i).xyz(2)),...
        ', ',num2str(points(i).xyz(3)),', ',num2str(points(i).stdFN),'\n'];
    if points(i).stdFN ~= 0;
        fprintf(fid,outputString);
    end
end
fclose(fid);

%%
fclose('all');