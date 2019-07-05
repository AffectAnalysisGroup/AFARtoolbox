function time_char = getMyTime()
    t = datetime();
    y = year(t);
    m = month(t);
    d = day(t);
    h = hour(t);
    M = minute(t);
    s = round(second(t));
    time_char = sprintf('%02d/%02d/%d, %02d:%02d:%02d',m,d,y,h,M,s);
end

