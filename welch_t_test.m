function result = welch_t_test(set1,set2,time)

% Row 1: t-value
% Row 2: df
% Row 3: matlab t-test

N1=size(set1,1);
N2=size(set2,1);

for i=1:time
    
    s1=std(set1(:,i));
    s2=std(set2(:,i));
    m1=mean(set1(:,i));
    m2=mean(set2(:,i));
    
    t = abs(m2-m1) / sqrt( (s1^2)/N1 + (s2^2)/N2 );
    
    df = ( (s1^2)/N1 + (s2^2)/N2 )^2 / ( (s1^4)/(N1^2 * (N1-1)) + (s2^4)/(N2^2 * (N2-1)) );
    
    h=ttest2(set1(:,i),set2(:,i));
    
    result(1,i)=t;
    result(2,i)=df;
    result(3,i)=h;
    
end
