x = logspace(-2,2);
y = (0.5/(10**-6)) ./ (2*pi*x); #slew rate 0,5 u/V OP07C
y2 = (350/(10**-6)) ./ (2*pi*x); #slew rate 350 u/V AD826
y1 = (16/(10**-6)) ./ (2*pi*x); #slew rate 13 u/V TL072C
y3 = (450/(10**-6)) ./ (2*pi*x); #slew rate 450 u/V AD828
Z2M = linspace(2e+06,2e+06,50);
Z50k = linspace(50e+03,50e+03,50);

loglog(x,y, "linewidth", 2,x,y1, "linewidth", 2,x,y2, "linewidth", 2,x,y3 , "linewidth", 2, x,Z2M,'--',"linewidth", 2, x,Z50k,'--',"linewidth", 2);
grid on

legend('TL072 - Real - 0,5 u/V','TL072 - nominal - 13 u/V ','AD826 - 350 u/V','AD828 - 450 u/V', '2 MHz','50 kHz','Location','northeast')
xlabel ('Tensão de pico (V)')
ylabel ('Largura de banda de grande sinal (Hz)')
#title ('dddd')

saveas(gcf,"largura_banda_ampOps.png");
