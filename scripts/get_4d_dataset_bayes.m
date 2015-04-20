function [bayes, perf] = get_4d_dataset_bayes(dataset)
    k=1;
    t1 = 3*pi/2;
    t2 = pi/2;
    xm3=-2.5;
    xm4=2.5;
    n = 500;
    
    bayes = cell(size(dataset.data, 1), 1);
    perf = zeros(size(dataset.data, 1), 1);
    
    for i = 1:size(dataset.data, 1)
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

        data = dataset.data{i};
        labels = dataset.labels{i};
        
        pdfs = zeros(length(data), 4);
        
        pdfs(:, 1) = mvnpdf(data, mu1, eye(4));
        pdfs(:, 2) = mvnpdf(data, mu2, eye(4));
        pdfs(:, 3) = mvnpdf(data, mu3, eye(4));
        pdfs(:, 4) = mvnpdf(data, mu4, eye(4));
        
        [~, b] = max(pdfs, [], 2);
        
        b(b== 4) = 3;
        
        perf(i) = sum(b == labels) / length(labels);
        bayes{i} = b;
    end
end