function dataset = gen_4d_3c_unimodal_gaussians()    
    k=1;
    t1 = 3*pi/2;
    t2 = pi/2;
    xm3=-2.5;
    xm4=2.5;
    n = 500;
    dataset = struct('data', 0, 'labels', 0,'use',0);
    dataset.data = cell(100,1);
    dataset.labels = cell(100,1);
    dataset.bayes = cell(100, 1);
    dataset.bayes_perf = zeros(100, 1);
    dataset.use = cell(100,1);
    
    for i = 1:100
        if i == 23||i==47||i==74||i==95
           % disp(i);
            k=k*-1;
        end
        xm1 = 3.7*cos(t1);
        ym1 = 3.7*sin(t1);

        xm2 = 3.7*cos(t2);
        ym2 = 3.7*sin(t2);
        
        xm3 = xm3+.11*k;
        ym3 = 0;
        xm4 = xm4-.11*k;
        ym4 = 0;
       
        t1 = t1+.07;
        t2 = t2+ .07;
        
        mu1 = [xm1, ym1, 1, 1];
        mu2 = [xm2, ym2, 1, 1];
        mu3 = [xm3, ym3, 1, 1];
        mu4 = [xm4, ym4, 1, 1];

        RNDtr = mvnrnd(mu1,eye(4),n);
        RNDtr2 = mvnrnd(mu2,eye(4),n);
        RNDtr3 = mvnrnd(mu3,eye(4),n);
        RNDtr4 = mvnrnd(mu4,eye(4),n);{
        
        data = [RNDtr;RNDtr2;RNDtr3;RNDtr4];
        
        pdfs = zeros(length(data), 4);
        
        pdfs(:, 1) = mvnpdf(data, mu1, eye(4));
        pdfs(:, 2) = mvnpdf(data, mu2, eye(4));
        pdfs(:, 3) = mvnpdf(data, mu3, eye(4));
        pdfs(:, 4) = mvnpdf(data, mu4, eye(4));
        
        [~, bayes] = max(pdfs, [], 2);
        
        bayes(bayes == 4) = 3;

        [dataset.data{i},IX]=sortrows(data);
        tempL = [ones(1,n) repmat(2,1,n) repmat(3,1,n) repmat(3,1,n)]';
        dataset.labels{i} = tempL(IX) ; 
        clear tempL;
        dataset.bayes{i} = bayes(IX);
        dataset.bayes_perf(i) = sum(bayes(IX) == dataset.labels{i}) / length(bayes) * 100;
        dataset.use{i} = zeros(n*4,1);
        if i ==1;
            p = randperm(n*4,750);
            dataset.use{i}(p) = 1; 
        else
            dataset.use{i} = zeros(n*4,1);
        end
    end
end