#!/bin/bash
# Purpose: Regression trend1d mixed models for the Aleutian Trench
# GMT modules: gmtset, gmtdefaults, trend1d, psxy, pstext, logo, psconvert
# Unix progs: echo, rm
# Step-1. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=0.8c \
    MAP_ANNOT_OFFSET=0.2c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_DEFAULT_PEN thin dimgray \
    FONT_TITLE=11p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    FONT_LABEL=9p,Palatino-Roman,dimgray \
# Step-2. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-3. generate file
ps=ATtrends.ps

# Step-4. Basic LS line y = a + bx
gmt trend1d -Fxm stackA2.txt -Np1 > modelAT.txt
gmt psxy -R-200/200/-8800/2000 -JX15c/4c -P \
    -Bpxag100f10 -Bsxg50 -Byaf+u"m" -Bsyg2000 -Wthinnest\
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gmintcream -Sc0.05c -Gred stackA2.txt -X5.0c -K > $ps
gmt psxy -R -J -W0.5p,blue modelAT.txt \
    -UBL/-15p/-45p -O -K >> $ps
echo "m@-2@-(t) = a + b\267t" | gmt pstext -R -J \
    -F+f12p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-5. Basic LS line y = a + bx + cx^2
gmt trend1d -Fxm stackA2.txt -Np2 > modelAT.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gmintcream -Sc0.05c -Gred stackA2.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.5p,blue modelAT.txt -O -K >> $ps
echo "m@-3@-(t) = a + b\267 t + c\267t@+2@+" | gmt pstext -R -J \
    -F+f12p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-6. Basic LS line y = a + bx + cx^2 + spatial change
gmt trend1d -Fxmr stackA2.txt -Np2,f1+l1 > modelAT.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gmintcream -Sc0.05c -Gred stackA2.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.25p,blue modelAT.txt -O -K >> $ps
echo "m@-5@-(t) = a + b\267t + c\267t@+2@+ + d\267cos(2@~p@~t) + e\267sin(2@~p@~t)" | gmt pstext -R -J \
    -F+f12p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-7. Plot residuals of last model
gmt psxy -R-200/200/-2000/1000 -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg1000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gmintcream -W0.1 -Sc0.05c \
    -Gred modelAT.txt -i0,2 -Y5.0c -O -K >> $ps
echo "@~e@~(t) = y(t) - m@-5@-(t) (plot of the residuals)" | gmt pstext -R -J \
    -F+f12p+cBL -Dj0.1i -Gcornsilk -O -K >> $ps

# Step-8. Plot graph
gmt psxy -R-200/200/-10000/1000 -JX15c/4c envA2.txt \
    -Bpxag100f10+l"Distance from trench (km)" \
    -Bsxg50 -Bpya2000gf+l"Depth (m)" -Bsyg2000 \
    --FONT_ANNOT_PRIMARY=8p,Palatino-Roman,dimgray \
    --FONT_LABEL=8p,Palatino-Roman,dimgray \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+t"Graph of the modelled trend curves of the Aleutian Trench geomorphology (north)" \
    -Glightgray -W0.2p -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.2p -Ey+p0.2p stackA2.txt -O -K >> $ps
gmt psxy -R -J -W1.0p,red stackA2.txt \
    -O -K >> $ps

# Step-9. Add test annotations
echo "160 -4000 Aleutian Islands" | gmt pstext -R -J -Gwhite -F+jTC+f9p -O -K >> $ps
echo "-50 -300 Mean stacked profile with error bars" | gmt pstext -R -J -Gwhite -F+jTC+f10p,red -O -K >> $ps
echo "0 -9000 Aleutian Trench" | gmt pstext -R -J -Gwhite -F+jTC+f9p -O -K >> $ps
echo "-150 -8000 Pacific Plate" | gmt pstext -R -J -Gwhite -F+jTC+f9p -O -K >> $ps
# Step-10. Add subtitle
gmt pstext -R0/10/0/15 -JX15c/4c -X0.0c -Y0.5c -N -O -K \
    -F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 15.0 Fitted regression models y=f(x)+e, by weighted least squares (WLS), polynomial and Fourier
EOF

# Step-11. Add GMT logo
gmt logo -Dx6.2/-21.0+o0.25c/-1.3c+w2c -O >> $ps
# Step-12. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert ATtrends.ps -A0.2c -E720 -Tj -P -Z
# Step-13. Clean up
rm -f modelAT.txt
