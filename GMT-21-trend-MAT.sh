#!/bin/bash
# Purpose: Regression trend1d mixed models for the Middle America Trench
# GMT modules: gmtset, gmtdefaults, trend1d, psxy, pstext, logo, psconvert
# Unix progs: echo, rm
# Step-1. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    MAP_TITLE_OFFSET=0.8c \
    MAP_ANNOT_OFFSET=0.2c \
    MAP_DEFAULT_PEN thin dimgray \
    FONT_TITLE=11p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    FONT_LABEL=9p,Palatino-Roman,dimgray \
# Step-2. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-3. generate file
ps=MATtrends.ps

# Step-4. Basic LS line y = a + bx
gmt trend1d -Fxm stackMAT.txt -Np1 > modelMAT.txt
gmt psxy -R-200/200/-7000/2000 -JX15c/4c -P \
    -Bpxag100f10 -Bsxg50 -Byaf+u"m" -Bsyg2000 -Wthinnest\
    -BWSne+gmintcream -Sc0.05c -Gred stackMAT.txt -X5.0c -K > $ps
gmt psxy -R -J -W0.5p,blue modelMAT.txt \
    -UBL/-15p/-45p -O -K >> $ps
echo "-190 1500 E" | gmt pstext -R -J -F+jTL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
echo "m@-2@-(t) = a + b\267t" | gmt pstext \
    -R -J -F+f12p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-5. Basic LS line y = a + bx + cx^2
gmt trend1d -Fxm stackMAT.txt -Np2 > modelMAT.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    -BWSne+gmintcream -Sc0.05c -Gred stackMAT.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.5p,blue modelMAT.txt -O -K >> $ps
echo "-190 1500 D" | gmt pstext -R -J -F+jTL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
echo "m@-3@-(t) = a + b\267 t + c\267t@+2@+" | gmt pstext -R -J \
    -F+f12p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-6. Basic LS line y = a + bx + cx^2 + spatial change
gmt trend1d -Fxmr stackMAT.txt -Np2,f1+l1 > modelMAT.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    -BWSne+gmintcream -Sc0.05c -Gred stackMAT.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.25p,blue modelMAT.txt -O -K >> $ps
echo "-190 1500 C" | gmt pstext -R -J -F+jTL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
echo "m@-5@-(t) = a + b\267t + c\267t@+2@+ + d\267cos(2@~p@~t) + e\267sin(2@~p@~t)" | gmt pstext -R -J \
    -F+f10p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-7. Plot residuals of last model
gmt psxy -R-200/200/-2500/1500 -J \
    -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg1000 \
    -BWSne+gmintcream -W0.1 -Sc0.05c \
    -Gred modelMAT.txt -i0,2 -Y5.0c -O -K >> $ps
echo "-190 800 B" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
echo "@~e@~(t) = y(t) - m@-5@-(t) (plot of the residuals)" | gmt pstext -R -J \
    -F+f11p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-8. Plot graph
gmt psxy -R-200/200/-7000/2000 -JX15c/4.7c envMAT.txt \
    -Bpxag100f10+l"Distance from trench (km)" \
    -Bsxg50 -Bpya2000g1000f+l"Depth (m)" -Bsyg1000 \
    --FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    --FONT_LABEL=8p,Palatino-Roman,dimgray \
    -BWSne+t"Graph of the modelled trend curves of the Guatemala Trench geomorphology" \
    -Glightgray -W0.2p -Y5.4c -O -K >> $ps
gmt psxy -R -J -W0.2p -Ey+p0.2p stackMAT.txt -O -K >> $ps
gmt psxy -R -J -W1.0p,red stackMAT.txt \
    -O -K >> $ps

# Step-9. Add test annotations
echo "0 1500 Median stacked profile with error bars" | gmt pstext -R -J -Gwhite -F+jTC+f10p,red -O -K >> $ps
echo "120 -3000 Carribean Plate " | gmt pstext -R -J -F+jTC+f10p,orangered4 -Gwhite -O -K >> $ps
echo "-10 0 Guatemala Trench" | gmt pstext -R -J -F+f10p,orangered4+jTC -Gwhite -O -K >> $ps
echo "-100 -5000 Cocos Plate" | gmt pstext -R -J -F+jTC+f10p,orangered4 -Gwhite -O -K >> $ps
echo "140 -1000 Chortis block" | gmt pstext -R -J -F+jTL+f10p,darkbrown -Gwhite -O -K >> $ps
echo "15 -5500 Oceanward Forearc" | gmt pstext -R -J -F+jTL+f10p,darkbrown+a-310 -Gwhite -O -K >> $ps
echo "-190 1500 A" | gmt pstext -R -J -F+jTL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
# Arrow
gmt psxy -R -J -Sv0.15i+bc+ea -Gyellow -W0.5p -O -K << EOF >> $ps
-3 -1000 270 2.2c
EOF
# Step-10. Add subtitle
gmt pstext -R0/10/0/15 -JX15c/4c -X0.0c -Y1.0c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 15.0 Fitted regression models y=f(x)+e, by weighted least squares (WLS), polynomial and Fourier
EOF

# Step-11. Add GMT logo
gmt logo -Dx6.2/-22.0+o0.25c/-1.3c+w2c -O >> $ps
# Step-12. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert MATtrends.ps -A0.5c -E720 -Tj -P -Z
# Step-13. Clean up
rm -f modelMAT.txt
