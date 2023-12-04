function sa = ellipsoidSA(majorAxis, minorAxis)
    inside = (2*(majorAxis*minorAxis)^1.6 + (minorAxis^2)^1.6)/3;
    sa = 4*pi*(inside^(1/1.6));
    fprintf('LV Surface Area: %f cm^2\n', sa);
end