figs = findobj('Type', 'figure');

for i = 1:length(figs)
    fig = figs(i);
    tightfig(fig);
    set(fig, 'units', 'inches', 'position', [0 1 9.5 3]);
%     set(fig, 'PaperPositionMode', 'auto');
    
    if ~isdir('figures'), mkdir('figures'); end
    
    name = ['figure' num2str(i)];
    
    if ~isempty(fig.Name), name = fig.Name; end
    
    savefig(fig, ['figures/' name]);
    print(fig, ['figures/' name], '-dpng', '-r0');
end