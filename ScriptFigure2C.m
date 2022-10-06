%%%Prevalence and confidence interval barchart
%%%MedCalc Software Ltd. Confidence interval for a rate. https://www.medcalc.org/calc/rate_ci.php (Version 20.114; accessed August 25, 2022)
%%%https://www.medcalc.org/calc/rate_ci.php
catL={'Any symptoms','Lost taste','Lost smell','Fatigue','Headache','Joint pain','Muscle ache','Cough','Short breath','Chest pain'};
X=1:10;
prevY=[36.36 26.42 48.82
        9.92 5.12 17.32
        21.49 14.04 31.48
        24.79 16.73 35.39
        9.92 5.12 17.32
        7.44 3.40 14.12
        15.70 9.45 24.52
        16.53 10.10 25.53
        18.18 11.39 27.53
        19.83 12.71 29.51];
        
bar(X,prevY(:,1));
hold on
errorbar(X,prevY(:,1),prevY(:,1)-prevY(:,2),prevY(:,3)-prevY(:,1),'ob')
xticklabels(catL);
xtickangle(45);
xlim([0.5 10.5])
ylabel('Prevalence')
