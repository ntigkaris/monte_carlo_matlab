clear all; close all; clc

N = 2;
for n=1:N
    r(n) = rand - 0.5;
    e(n) = doubleWellPot(r(n));
end

steps = 10000;
ExchangeFreq = 0.5;
temperature = [0.01 , 0.1];
maxDr = [0.5 , 5];

h.count = 0;
h.range = [-3 ,3 ];
h.increment = 0.2;
h.histFreq = 10000;
h.saveFileName = 'PThist.dat';

traj = zeros(N,steps);

for step=1:steps
    
    if (rand < ExchangeFreq)
        
        db = 1/temperature(2) - 1/temperature(1);
        de = e(2) - e(1);
        
        if (exp(-db*de) > 0)
            
            tempR = r(1);
            r(1) = r(2);
            r(2) = tempR;
            
            tempE = e(1);
            e(1) = e(2);
            e(2) = tempE;
            
        elseif ( rand < exp(-db*de) )
            
            tempR = r(1);
            r(1) = r(2);
            r(2) = tempR;
            
            tempE = e(1);
            e(1) = e(2);
            e(2) = tempE;
        end
        
    end
    
    for n=1:N
        
        rTrial = r(n) + maxDr(n)*(rand-0.5);
        eTrial = doubleWellPot(rTrial);
        de = eTrial - e(n);
        
        if (de < 0)
            r(n) = rTrial;
            e(n) = eTrial;
        elseif (rand < exp(-de/temperature(n)))
            r(n) = rTrial;
            e(n) = eTrial;
        end
        
        traj(n,step) = r(n);
        
    end
    
    h = histogram(h,r(1));
    
end

figure(1);
scatter(log10(1:steps),traj(1,:)); % wrong plot
xlabel('steps');
ylabel('r(1) pos');

bltz = exp( - arrayfun(@doubleWellPot,h.values)/temperature(1));
bltz = bltz/(sum(bltz)*h.increment);

figure(2);
plot(h.values,bltz,'r');
hold on
histo = h.histo/(h.count*h.increment);
plot(h.values,histo,'b');
xlabel("r(1) pos");
ylabel("energy");