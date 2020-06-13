#!/bin/bash
# Purpose: Regression trend1d mixed models
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
ps=KTTtrends_Kermadec.ps
# Step-4. Basic LS line y = a + bx
gmt trend1d -Fxm stackK.txt -Np1 > model.txt
gmt psxy -R-200/200/-10000/0 -JX15c/4c -P -Bpxag100f10 -Bsxg50 -Byaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -Sc0.05c -Gred stackK.txt -X5.0c -K > $ps
gmt psxy -R -J -W0.5p,blue model.txt \
    -UBL/-15p/-45p -O -K >> $ps
echo "m@-2@-(t) = a + b\267t" | gmt pstext -R -J -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "180 -1500 E" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-5. Basic LS line y = a + bx + cx^2
gmt trend1d -Fxm stackK.txt -Np2 > model.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -Sc0.05c -Gred stackK.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.5p,blue model.txt -O -K >> $ps
echo "m@-3@-(t) = a + b\267 t + c\267t@+2@+" | gmt pstext -R -J \
    -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "180 -1500 D" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-6. Basic LS line y = a + bx + cx^2 + spatial change
gmt trend1d -Fxmr stackK.txt -Np2,f1+l1 > model.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -Sc0.05c -Gred stackK.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.25p,blue model.txt -O -K >> $ps
echo "m@-5@-(t) = a + b\267t + c\267t@+2@+ + d\267cos(2@~p@~t) + e\267sin(2@~p@~t)" | gmt pstext -R -J \
    -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "180 -1500 C" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-7. Plot residuals of last model
gmt psxy -R-200/200/-3000/3000 -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg1000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne+gazure1 -W0.1 -Sc0.05c \
    -Gred model.txt -i0,2 -Y5.0c -O -K >> $ps
echo "@~e@~(t) = y(t) - m@-5@-(t) (plot of the residuals)" | gmt pstext -R -J \
    -F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "180 2000 B" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-8. Plot graph
gmt psxy -R-200/200/-11000/1000 -JX15c/4c \
    -Bpxag100f10+l"Distance from trench (km)" -Bsxg50 -Bpyagf+l"Depth (m)" -Bsyg2000 \
    --MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
    --MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
    -BWSne \
    -Glightgray -W0.5p envK.txt -Y5.5c -O -K >> $ps
gmt psxy -R -J -W0.05p -Ey+p0.2p stackK.txt -O -K >> $ps
gmt psxy -R -J -W1.0p,red stackK.txt \
    -O -K >> $ps

# Step-9. Add test annotations
echo "-190 -5300 Kermadec Ridge" | gmt pstext -R -J -Gwhite -F+jBL+f11p -O -K >> $ps
echo "50 1500 Median stacked profile with error bars" | gmt pstext -R -J -Gwhite -F+jTC+f11p,red -O -K >> $ps
echo "0 -100 Kermadec Trench" | gmt pstext -R -J -Gwhite -F+jTC+f11p -O -K >> $ps
echo "150 -7000 Pacific Plate" | gmt pstext -R -J -Gwhite -F+jTC+f12p,darkbrown -O -K >> $ps
echo "150 -3000 Pacific Ocean" | gmt pstext -R -J -Gwhite -F+jTC+f12p,darkblue -O -K >> $ps
echo "-120 -6500 Oceanward Forearc" | gmt pstext -R -J -F+jBL+f11p,darkbrown+a-20 -Gwhite -O -K >> $ps
echo "180 -1500 A" | gmt pstext -R -J -F+jBL+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
# Arrow
gmt psxy -R -J -Sv0.15i+bc+ea -Gyellow -W0.5p -O -K << EOF >> $ps
0 -1500 270 1.6c
EOF
# Step-11. Add GMT logo
gmt logo -Dx6.2/-21.0+o0.25c/-1.3c+w2c -O >> $ps
# Step-12. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert KTTtrends_Kermadec.ps -A2.0c -E720 -Tj -P -Z
# Step-13. Clean up
rm -f model.txt
