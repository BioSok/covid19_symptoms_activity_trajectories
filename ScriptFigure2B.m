%%
[Sig, TStr, Raw] = xlsread('Design_traj_plotdatesData.xlsx',1,'A2:AB597');
tt=datetime(TStr(:,1),'InputFormat','dd/MM/yyyy');
%%
ds1=dataset('XLSFILE','Design_traj_plotdatesData.xlsx');
dtstr='2022-07-01';
t = datetime(dtstr,'InputFormat','yyyy-MM-dd');
trialIDtp=ds1.trialnumber(find(ds1.visit_num==0 & tt<t));

%%
resy=[];
xdur=[];
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
       y=[y;size(find(dt_num(k,:)==1),2)];
       end
       if (isempty(idsymp)~=0)
       y=[y;0];
       end
       if (ds1.visit_num(id(k))<10)
           n=[n;17];
       end
       if (ds1.visit_num(id(k))==99)
           n=[n;10];
       end
       x=[x;ds1.tp(id(k))];
       
   end
   
  
   
b = glmfit(x,[y n],'binomial','Link','probit');
xtp=[0 90 180 270 360];
np=ones(1,size(xtp,2));
yfit = glmval(b,xtp','probit','Size',np');
resy=[resy;ds1.trialnumber(id(1)) round(yfit',8)];
xdur=[xdur;x(2)-x(1)];
end


dscl=dataset('XLSFILE','traj_classes13042022.xlsx');
idcl0=find(dscl.all_symp==0);
idcl1=find(dscl.all_symp==1);
ytp0=mean(resy(idcl0,2:end));
ytp1=mean(resy(idcl1,2:end));

ytp0L95=ytp0-(1.96*std(resy(idcl0,2:end))/sqrt(size(idcl0,1)));
ytp0U95=ytp0+(1.96*std(resy(idcl0,2:end))/sqrt(size(idcl0,1)));
ytp1L95=ytp1-(1.96*std(resy(idcl1,2:end))/sqrt(size(idcl1,1)));
ytp1U95=ytp1+(1.96*std(resy(idcl1,2:end))/sqrt(size(idcl1,1)));
figure
hold on
meanciplot(ytp0,ytp0L95,ytp0U95,xtp,'c',0.2)
meanciplot(ytp1,ytp1L95,ytp1U95,xtp,'b',0.2)
ax = gca;
hold on
xlim([0 xtp(end)])
ylim([0 1 ])
box('on')
ylabel('Mean fraction of any symptoms in a patient')
xlabel('Time point of symptom')
legend(['Short(' num2str(size(idcl0,1)) ')'],['Long (' num2str(size(idcl1,1)) ')'])
ax.FontName ='Times New Roman ';
ax.FontSize=10;
ax.FontWeight='Normal';
