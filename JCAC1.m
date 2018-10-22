% Dorothy Rangata
% Thesis Project: Admission Control Schem for a sliced 5G network
% JCAC to enhance system utilization (non-adaptive bandwidth)
%supervisor : Dr OE Falowo

C1=15;
Tm01=10;        %threshold for new calls in slice 1
Tn11=15;        %threshold for handoff calls class-1 calls in slice 1
 
%slice 2
C2=15;
Tm02=10;
Tn22=15;
 
%slice 3
C3=25;
Tm03= 10;
Tn13= 15;
Tn23= 20;

%bbu for each class of calls
b1=15;
b2=3;

%
h=.5;

un1=0.5+h;
un2=0.5+h;
%call arrival
%xn1=[.5,1,1.5,2,2.5,3,3.5,4,4.5,5];
xn1=[5,5,5,5,5,5,5,5,5,5];
xn2=[10,10,10,10,10,10,10,10,10,10];
xh1=(h.*xn1)./0.5;
xh2=(h.*xn2)./0.5;

% load at each slice
xn11=(C1/(C1+C2+C3))*xn1;
xh11=(C1/(C1+C2+C3))*xh1;

xn22=(C2/(C1+C2+C3))*xn2;
xh22=(C2/(C1+C2+C3))*xh2;

xn13=(C3/(C1+C2+C3))*xn1;
xh13=(C3/(C1+C2+C3))*xh1;
xn23=(C3/(C1+C2+C3))*xn2;
xh23=(C3/(C1+C2+C3))*xh2;

G =zeros(10,1);
G1=zeros(10,1);
G2=zeros(10,1);
G3=zeros(10,1);
G4=zeros(10,1);

ncbp_1=zeros(10,1);
ncbp_2=zeros(10,1);
hcdp_1=zeros(10,1);
hcdp_2=zeros(10,1);


%admissable states
%new calls
dm11=fix(Tm01/b1)+1;
dm22=fix(Tm02/b2)+1;
dm13=fix(Tm03/b1)+1;
dm23=fix(Tm03/b2)+1;
%handoff calls
dn11=fix(Tn11/b1)+1;
dn22=fix(Tn22/b2)+1;
dn13=fix(Tn13/b1)+1;
dn23=fix(Tn23/b2)+1;

%initialising my load at each slice
pn11=zeros(10,1);
pn22=zeros(10,1);
pn13=zeros(10,1);
pn23=zeros(10,1);
ph11=zeros(10,1);
ph22=zeros(10,1);
ph13=zeros(10,1);
ph23=zeros(10,1);
%initialising the state probabilities
qn11=zeros(10,1);
qn22=zeros(10,1);
qn13=zeros(10,1);
qn23=zeros(10,1);
qh11=zeros(10,1);
qh22=zeros(10,1);
qh13=zeros(10,1);
qh23=zeros(10,1);

for i=1:10
    
    %load at each slice from new calls
    pn11(i)=xn11(i)/un1;
    pn22(i)=xn22(i)/un2;
    pn13(i)=xn13(i)/un1;
    pn23(i)=xn23(i)/un2;
    %load from handoff calls
    ph11(i)=xh11(i)/un1;
    ph22(i)=xh22(i)/un2;
    ph13(i)=xh13(i)/un1;
    ph23(i)=xh23(i)/un2;
    
    %loop through the admissable states
    for m11=0:dm11
        for n11=0:dn11
            for m22=0:dm22
                for n22=0:dn22
                    for m13=0:dm13
                        for m23=0:dm23
                            for n13=0:dn13
                                for n23=0:dn23
                                    
                                    if ((b1*(m11+n11)<=C1)&&(b2*(m22+n22)<=C2)&&(b1*(m13+n13)+ b2*(m23+n23)<=C3))
                                        
                                        
                                        %state probabilities
                                        qn11(i)= (pn11(i)^(m11))/(factorial(m11));
                                        qh11(i)= (ph11(i)^(n11))/(factorial(n11));
                                        
                                        qn22(i)= (pn22(i)^(m22))/(factorial(m22));
                                        qh22(i)= (ph22(i)^(n22))/(factorial(n22));
                                        
                                        qn13(i)= (pn13(i)^(m13))/(factorial(m13));
                                        qn23(i)= (pn23(i)^(m23))/(factorial(m23));
                                        qh13(i)= (ph13(i)^(n13))/(factorial(n13));
                                        qh23(i)= (ph23(i)^(n23))/(factorial(n23));
                                        
                                        %then total probability is ()
                                        G(i)= G(i)+ qn11(i)+ qh11(i) + qn22(i)+ qh22(i) +qn13(i)+ qh13(i) +qn23(i)+ qh23(i);
                                        
                                        %arrival of new class-1 call 
                                        if (((((b1+ b1*m11 + b1*n11)>C1)||(b1+b1*m11)>Tm01)) &&(((b1+b1*(m13+n13)+ b2*(m23+n23))>C3)||(b1+b1*m13+b2*m23)>Tm03))
                                            
                                            %admit into available slice,calculate probability as
                                            G1(i)= G1(i)+ qn11(i)+ qh11(i) + qn22(i)+ qh22(i) +qn13(i)+ qh13(i) +qn23(i)+ qh23(i);
                                            
                                            
                                            
                                        end
                                        
                                        % arrival of new class-2 call
                                        if (((((b2+ b2*m22+ b2*n22)>C2)||(b2+b2*m22)>Tm02)) &&(((b2+b1*(m13+n13)+b2*(m23+n23))>C3)||(b2+b1*m13+b2*m23)>Tm03))
                                            
                                            G2(i)= G2(i)+ qn11(i)+ qh11(i) + qn22(i)+ qh22(i) +qn13(i)+ qh13(i) +qn23(i)+ qh23(i);
                                            
                                        end
                                        
                                        %arrival of a handoff class-1 call
                                        
                                        if (((b1+b1*m11 + b1*n11)>C1)||((b1+b1*n11)>Tn11))&&(((b1+b1*(m13+n13)+b2*(m23+n23))>C3)||((b1+b1*n13+ b2*n23)>Tn13))
                                            
                                            G3(i)= G3(i)+ qn11(i)+ qh11(i) + qn22(i)+ qh22(i) +qn13(i)+ qh13(i) +qn23(i)+ qh23(i);
                                            
                                        end
                                        
                                        %arrival of a handoff class-2 call
                                        
                                        if (((b2+b2*m22+b2*n22)>C2)||((b2+b2*n22)>Tn22))&&(((b2+b1*(m13+n13)+ b2*(m23+n23))>C3)||((b2+b1*n13+ b2*n23)>Tn23))
                                            
                                            G4(i)= G4(i)+ qn11(i)+ qh11(i) + qn22(i)+ qh22(i) +qn13(i)+ qh13(i) +qn23(i)+ qh23(i);
                                        end
                                            
                                        
                                       
                                            
                                            
                                            
                                        
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
ncbp_1(i)=G1(i)/G(i);
ncbp_2(i)=G2(i)/G(i);
hcdp_1(i)=G3(i)/G(i);
hcdp_2(i)=G4(i)/G(i);    
                              
end

