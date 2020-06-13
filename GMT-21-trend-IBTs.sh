#!/bin/bash
# Purpose: Regression trend1d mixed models, Izu-Bonin Trench (SOUTHERN segment)
# GMT modules: gmtset, gmtdefaults, trend1d, psxy, pstext, logo, psconvert
# Unix progs:   echo, rm
#
# Step-1. GMT set up
gmt set FORMAT_GEO_MAP=dddF \
    MAP_FRAME_PEN=dimgray \
    MAP_FRAME_WIDTH=0.1c \
    MAP_TITLE_OFFSET=0.8c \
    MAP_ANNOT_OFFSET=0.2c \
    MAP_TICK_PEN_PRIMARY=thinner,dimgray \
    MAP_DEFAULT_PEN thin dimgray \
    FONT_TITLE=14p,Palatino-Roman,black \
    FONT_ANNOT_PRIMARY=10p,Palatino-Roman,black \
    FONT_LABEL=12p,Palatino-Roman,black \
# Step-2. Overwrite defaults of GMT
gmtdefaults -D > .gmtdefaults
# Step-3. Generate file
ps=IBTstrends.ps
# Step-4. Basic LS line y = a + bx
gmt trend1d -Fxm stackIBTs.txt -Np1 > model.txt
gmt psxy -R-200/200/-11000/3000 -JX15c/4c -P -Bpxag100f10 -Bsxg50 -Bya2000f+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -Sc0.05c -Gred stackIBTs.txt -X5.0c -K > $ps
gmt psxy -R -J -W0.5p,blue model.txt \
    -UBL/-15p/-45p -O -K >> $ps
echo "m@-2@-(t) = a + b\267t" | gmt pstext -R -J -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "170 0 E" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-5. Basic LS line y = a + bx + cx^2
gmt trend1d -Fxm stackIBTs.txt -Np2 > model.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -Sc0.05c -Gred stackIBTs.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.5p,blue model.txt -O -K >> $ps
echo "m@-3@-(t) = a + b\267 t + c\267t@+2@+" | gmt pstext -R -J \
    -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "170 0 D" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-6. Basic LS line y = a + bx + cx^2 + spatial change
gmt trend1d -Fxmr stackIBTs.txt -Np2,f1+l1 > model.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -Sc0.05c -Gred stackIBTs.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.25p,blue model.txt -O -K >> $ps
echo "m@-5@-(t) = a + b\267t + c\267t@+2@+ + d\267cos(2@~p@~t) + e\267sin(2@~p@~t)" | gmt pstext -R -J \
    -F+f10p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "170 0 C" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-7. Plot residuals of last model
gmt psxy -R-200/200/-4000/3000 -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg1000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -W0.1 -Sc0.05c \
    -Gred model.txt -i0,2 -Y5.0c -O -K >> $ps
echo "@~e@~(t) = y(t) - m@-5@-(t) (plot of the residuals)" | gmt pstext -R -J \
    -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "170 1500 B" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-8. Plot graph
gmt psxy -R-200/200/-11000/2000 -JX15c/4c \
    -Bpxag100f10+l"Distance from trench (km)" -Bsxg50 -Bpya2000g2000f+l"Depth (m)" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
-BWSne+t"Izu-Bonin Trench: modelled trends of the slope gradients in the profiles curves" \
    -Glightgray -W0.5p envIBTs.txt -Y5.5c -O -K >> $ps
gmt psxy -R -J -W0.05p -Ey+p0.2p stackIBTs.txt -O -K >> $ps
gmt psxy -R -J -W1.0p,red stackIBTs.txt \
    -O -K >> $ps

# texts
echo "110 -8000 Pacific Plate" | gmt pstext -R -J -Gwhite -F+jBL+f10p,brown -O -K >> $ps
echo "-160 -7000 Philippine Sea Plate" | gmt pstext -R -J -Gwhite -F+jBL+f10p,brown -O -K >> $ps
echo "-70 0 SOUTHERN segment: median stacked profile with error bars" | gmt pstext -R -J -Gwhite -F+jBL+f10p,red -O -K >> $ps
echo "-160 0 Izu-Bonin Arc" | gmt pstext -R -J -Gwhite -F+jBL+f10p,darkbrown -O -K >> $ps
echo "-5 -1500 Izu-Bonin Trench" | gmt pstext -R -J -Gwhite -F+jBL+f10p,navyblue -O -K >> $ps
echo "-60 -6500 Slope" | gmt pstext -R -J -F+jBL+f10p,darkbrown+a-50 -Gwhite -O -K >> $ps
echo "170 -2000 A" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
# Arrow
gmt psxy -R -J -Sv0.15i+bc+ea -Gyellow -W0.5p -O -K << EOF >> $ps
0 -2000 270 2.0c
EOF

# Step-10. Add subtitle
gmt pstext -R0/10/0/15 -JX15c/4c -X0.0c -Y0.5c -N -O -K \
-F+f10p,Palatino-Roman,black+jLB >> $ps << EOF
0.0 15.0 Fitted regression models y=f(x)+e, by weighted least squares (WLS), polynomial and Fourier
EOF
# Step-11. Add GMT logo
gmt logo -Dx6.2/-21.0+o0.25c/-2.0c+w2c -O >> $ps
# Step-12. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert IBTstrends.ps -A1.0c -E720 -Tj -P -Z
# Step-13. Clean up
rm -f model.txt
