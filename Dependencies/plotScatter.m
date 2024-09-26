function plotScatter(CB,XX,ids)

    C = squeeze(mean(CB));
    Cstd = squeeze(std(CB));
    
    figure; hold on;
    
    g = gscatter(XX(:,1),XX(:,2),ids,'kybrc',[],12); legend off;

    plot(C(:,1),C(:,2),'*','MarkerSize',10,'LineWidth',3,'Color','m');

    H=drawEllipse(C(:,1),C(:,2),Cstd(:,1),Cstd(:,2));        
    set(H,'lineWidth',2,'Color','m','lineStyle','-')

    pbaspect(gca,[1 1 1]);
    axis([0 5 -0.1 1]);
    axis square;
    set(gca,'LineWidth',2,'fontSize',18,'fontWeight','bold'); box on;
    xlabel('Activity, \it{a}',FontSize=20,Interpreter='tex');
    ylabel('Persistence, \it{q}',FontSize=20,Interpreter='tex');
    legTxt = {'\uparrow a \uparrow q','\downarrow a \uparrow q','\downarrow a \downarrow q'};

    legend(legTxt, 'fontSize',18,'Location','southeast','fontWeight','normal')
end
