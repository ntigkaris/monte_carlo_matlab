function dE = LJChange(coords,rTrial,part,L)

    dE = 0;
    particles = size(coords,2);

    for otherPart = 1:particles

        if (otherPart == part) % not with itself interaction

            continue

        end

        drNew = coords(:,otherPart) - rTrial;
        drOld = coords(:,otherPart) - coords(:,part);

        drNew = DPBC(drNew,L);
        drOld = DPBC(drOld,L);

        dr2_New = sum(dot(drNew,drNew));
        dr2_Old = sum(dot(drOld,drOld));

        invDr6_New = 1.0/(dr2_New^3);
        invDr6_Old = 1.0/(dr2_Old^3);

        invDr12_New = 1.0/(dr2_New^6);
        invDr12_Old = 1.0/(dr2_Old^6);

        eNew = invDr12_New - invDr6_New;
        eOld = invDr12_Old - invDr6_Old;

        dE = dE + eNew - eOld;

    end

    dE = dE*4.0;

end