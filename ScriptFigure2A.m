[Sig, TStr, Raw] = xlsread('Design_traj_plotdatesData.xlsx',1,'A2:AB597');
tt=datetime(TStr(:,1),'InputFormat','dd/MM/yyyy');
%%
ds1=dataset('XLSFILE','Design_traj_plotdatesData.xlsx');
dtstr='2023-07-01';
t = datetime(dtstr,'InputFormat','yyyy-MM-dd');
trialIDtp=unique(ds1.trialnumber(find(isnan(ds1.tp)==0)));
%%
xv=NaT(121,10);
yv=-1*ones(121,10);
figure(1)
hold on
resy=[];
idt0=[];
sympid_y=[];
for j=1:size(trialIDtp,1)
   id11=find(ds1.trialnumber==trialIDtp(j)); 
   idt0=[idt0;id11(1)];
   
end
[tts,iis]=sort(tt(idt0));
for j=1:size(trialIDtp,1)
y=[];
x=[];
n=[];
   id=find(ds1.trialnumber==trialIDtp(j)); 
   dt=dataset2table(ds1(id,12:28));
   dt_num=table2array(dt);
   for k=1:size(id,1)
       idsymp=find(dt_num(k,:)==1);
       if (isempty(idsymp)==0)
       y=[y;find(iis==j)];
       end
       if (isempty(idsymp)~=0)
       y=[y;find(iis==j)];
       end
       
   end

x=   tt(id);
 vv= ds1.visit_num(id); 
 hold on

tmpid=find(vv <=10);
vv1=vv(tmpid)+1;
xv(j,vv1)=tt(id(vv1));
yv(j,vv1)=y(vv1);


tmpid99=find(vv==99);
if(isempty(tmpid99)==0)
 tmpid991= tmpid99- min(tmpid99)+1;
vv1=6+tmpid991;
for vvk=1:length(vv1)
xv(j,vv1(vvk))=tt(id(tmpid99(vvk)));
yv(j,vv1(vvk))=y(tmpid99(vvk));
end
end
 sympid_y= [sympid_y;trialIDtp(j) y(1)];

end
plot(xv(:,1),yv(:,1),'o','MarkerEdgeColor',[0.8 0.8 0.8],'MarkerSize',6,'MarkerFaceColor',[0.8 0.8 0.8]);
plot(xv(:,2),yv(:,2),'o','MarkerEdgeColor',[0.75 0 0.75],'MarkerSize',6,'MarkerFaceColor',[0.75 0 0.75]);
plot(xv(:,3),yv(:,3),'o','MarkerEdgeColor',[1 0 1],'MarkerSize',6,'MarkerFaceColor',[1 0 1]);
plot(xv(:,4),yv(:,4),'o','MarkerEdgeColor',[0.85 0.7 1],'MarkerSize',6,'MarkerFaceColor',[0.85 0.7 1])
plot(xv(:,5),yv(:,5),'o','MarkerEdgeColor',[0.93 0.84 0.84],'MarkerSize',6,'MarkerFaceColor',[0.93 0.84 0.84])
plot(xv(:,6),yv(:,6),'o','MarkerEdgeColor',[0 0 0],'MarkerSize',6,'MarkerFaceColor',[0 0 0])
plot(xv(:,7),yv(:,7),'o','MarkerEdgeColor',[1 0 1],'MarkerSize',6,'MarkerFaceColor',[1 1 1])
plot(xv(:,8),yv(:,8),'o','MarkerEdgeColor',[1 0 1],'MarkerSize',6,'MarkerFaceColor',[1 1 1])
plot(xv(:,9),yv(:,9),'o','MarkerEdgeColor',[1 0 1],'MarkerSize',6,'MarkerFaceColor',[1 1 1])
plot(xv(:,10),yv(:,10),'o','MarkerEdgeColor',[1 0 1],'MarkerSize',6,'MarkerFaceColor',[1 1 1])

box('on')

dspasymp=dataset('XLSFILE','PA_symp_trial.csv');
    intPA=intersect(trialIDtp,dspasymp.id);
grid('ON')
ylim([0 121])
xlim([min(tt)-30 max(tt)+30])
legend('Baseline', 'Visit 1', 'Visit 2', 'Visit 3', 'Visit 4', 'Visit 5','Self reported','Location','northwest');
legend boxoff 
for i=1:121
   if (isempty(intersect(trialIDtp(i),dspasymp.id))==1)
h=plot(xv(i,:),yv(i,:),'color',[0.6 0.6 0.6],'linestyle','-');
   end
   if (isempty(intersect(trialIDtp(i),dspasymp.id))==0)
h=plot(xv(i,:),yv(i,:),'color',[0 0 0],'linestyle','-','linewidth',1);
   end
h.Annotation.LegendInformation.IconDisplayStyle = 'off';
hold on
end
h.Annotation.LegendInformation.IconDisplayStyle = 'off';