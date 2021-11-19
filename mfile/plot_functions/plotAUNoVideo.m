function plotAUNoVideo(auMatFile)
    load(auMatFile);

    auNameCell = result.Properties.VariableNames;
    y_pred     = table2array(result);
    auCount    = size(y_pred,2);
    
    x = linspace(1,size(y_pred,1),size(y_pred,1));
    for n = 1 : auCount
        subplot(12,1,n)
        plot(x,y_pred(:,n));
        legend([auNameCell{n} '   '],'Location','westoutside',...
               'Orientation','horizontal');
    end


end




