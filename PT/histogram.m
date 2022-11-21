function h = histogram(h,data)

    if (h.count == 0)

        bins = ceil((h.range(2)-h.range(1))/h.increment);
        h.range(2) = h.range(1) + bins * h.increment;
        
        h.histo = zeros(1,bins);
        h.values = 1:bins;
        h.values = h.range(1) + h.increment*(h.values-0.5);
    end

    if (data > h.range(1) & data <= h.range(2))

        binIndex = ceil((data-h.range(1))/h.increment);
        h.histo(binIndex) = h.histo(binIndex)+1;
        h.count = h.count+1;

    else

        disp(strvcat('hist error / Value out of range:',num2str(data)));
        return

    end

    if (mod(h.count,h.histFreq) == 0)

        save(h.saveFileName,'-struct','h');

    end

end