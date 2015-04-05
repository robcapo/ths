function [perfs, mcds, perfdurs, mcddurs] = mcd_ug_sep_test
    cse = AlphaShapeCompactor;
    ssl = LabelPropagator;

    vs = [0 5 10 15 30];
    hs = [10 10 10 25 50];

    perfs = zeros(length(vs), 50);
    mcds = zeros(length(vs), 50);
    perfdurs = zeros(length(vs), 50);
    mcddurs = zeros(length(vs), 50);

    for i = 1:length(vs)
        disp(['Testing iteration ' num2str(i)]);
        v = vs(i);
        h = hs(i);
        ds = linspace(0, h, 50);

        for j = 1:length(ds)
            disp(['Testing distance step ' num2str(j)]);
            d = ds(j);

            [X1, y1, X2, y2] = ug_hsep_vsep(v, h, d);
            [perfs(i, j), mcdsj, perfdurs(i, j), mcddurs(i, j)] = mcd_test(cse, ssl, X1, y1, X2, y2);
            mcds(i, j) = max(mcdsj);
        end
    end
end