[Sig, TStr, Raw] = xlsread('Design_traj_plotdatesData.xlsx',1,'A2:AB597');
tt=datetime(TStr(:,1),'InputFormat','dd/MM/yyyy');
%%
ds1=dataset('XLSFILE','Design_traj_plotdatesData.xlsx');
 trialIDtp=unique(ds1.trialnumber(find(isnan(ds1.tp)==0)));
 dscl=dataset('XLSFILE','traj_classes13042022.xlsx');
ds1_dscl=join(ds1,dscl,'LeftKeys','trialnumber','RightKeys','trial','Type','leftouter');
%%
resy=[];
y=[];
x=[];
n=[];
vv=[];
tt=[];
dscl=dataset('XLSFILE','traj_classes13042022.xlsx');
for j=1:size(trialIDtp,1)
   id=find(ds1.trialnumber==trialIDtp(j)); 
   idtraj=find(dscl.trial==trialIDtp(j));
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
           tt=[tt;dscl.all_symp(idtraj)];
       end
       if (ds1.visit_num(id(k))==99)
           n=[n;10];
            tt=[tt;dscl.all_symp(idtraj)];
       end
       x=[x;ds1.tp(id(k))];
       vv=[vv;ds1.visit_num(id(k))];
       
   end
end
%%
meanff00=[];
meanff11=[];
tmp0=[];
tmp1=[];
vv1=vv;
vv1(find(vv==99))=1;

for i=1:6

p0=size(find( vv1==i-1 & y>=1 & tt==0),1)/size(find( vv1==i-1 & tt==0),1);
p1=size(find( vv1==i-1 & y>=1 & tt==1),1)/size(find( vv1==i-1 & tt==1),1);
tmp0=[tmp0;p0];
tmp1=[tmp1;p1];
end
meanff00=[meanff00;tmp0'];
meanff11=[meanff11;tmp1'];

%%
meanffind0=[];
meanffind1=[];
symp=[13 14 15 18 22 24 25 26 28];

for ss=1:9
y=[];
x=[];
n=[];
vv=[];
tt=[];
dscl=dataset('XLSFILE','traj_classes13042022.xlsx');
dscl_num=xlsread('traj_classes13042022.xlsx','A2:S122');

for j=1:size(trialIDtp,1)
   id=find(ds1.trialnumber==trialIDtp(j)); 
   idtraj=find(dscl.trial==trialIDtp(j));
   dt=dataset2table(ds1(id,symp(ss))); %%% individual symptom colID here 12:fever 13:lost_taste 14:lost_smell 
                                 %%% 15:fatigue 16:confusion 
                                 %%% 17:nauseavomit 18:headache 19:wheeze 20:sore_throat 21:abdominal_pain
                                 %%% 22:joint_pain	23:runny_nose 24:muscle_ache 25:cough 26:short_breath
                                 %%% 27:diarrhoea 28:chest_pain
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
           tt=[tt;dscl_num(idtraj,symp(ss)-9)];
       end
       if (ds1.visit_num(id(k))==99)
           n=[n;10];
            tt=[tt;dscl_num(idtraj,symp(ss)-9)];
       end
       x=[x;ds1.tp(id(k))];
       vv=[vv;ds1.visit_num(id(k))];
       
   end
end

ff=y./n;
vv1=vv;
vv1(find(vv==99))=1;




tmp0=[];
tmp1=[];
for i=1:6

p0=size(find( vv1==i-1 & y==1 & tt==0),1)/size(find( vv1==i-1 & tt==0),1);
p1=size(find( vv1==i-1 & y==1 & tt==1),1)/size(find( vv1==i-1 & tt==1),1);
tmp0=[tmp0;p0];
tmp1=[tmp1;p1];
end
meanffind0=[meanffind0;tmp0'];
meanffind1=[meanffind1;tmp1'];
end
%%
ffind=[];
 ffind=[ffind;meanff11];
for i=1:9
    ffind=[ffind;meanffind1(i,:)];
end
ffind=[ffind;meanff00];
for i=1:9
    ffind=[ffind;meanffind0(i,:)];
end

     imagesc(ffind)
     mymap=zeros (71,3);
         mymap(:,1)=1:-0.01:0.3;
         mymap(:,2)=1:-0.01:0.3;
         mymap(:,3)=1;
         
         
     colormap(mymap)
colorbar
figure(1)
hold on

line([0 6.5],[10.5 10.5],'color',[0 0 0])

xticks(1:6)
xticklabels({'Baseline','Visit1/SR','Visit2','Visit3',' Visit4', 'Visit5'})
yticks(1:28)
yticklabels({'Any symptom(44)';
              'Lost taste(12)';
              'Lost smell(26)';
              'Fatigue(30)';
              'Headache(12)';
              'Joint pain(9)';
              'Muscle ache(19)';
              'Cough(20)';
              'Short breath(22)';
              'Chest pain(24)';
              'Any symptom(77)';
              'Lost taste(109)';
              'Lost smell(95)';
              'Fatigue(91)';
              'Headache(109)';
              'Joint pain(112)';
              'Muscle ache(102)';
              'Cough(101)';
              'Short breath(99)';
              'Chest pain(97)'});
          text(5,6,'Long COVID','color',[0 0 0],'FontSize',10)
          text(5,15,'Short COVID','color',[0 0 0 ],'FontSize',10)
