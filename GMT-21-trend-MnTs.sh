#!/bin/bash
# Purpose: Regression trend1d mixed models
# GMT modules: gmtset, gmtdefaults, trend1d, psxy, pstext, logo, psconvert
# Unix progs: echo, rm
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
# Step-3. generate file
ps=MnTtrendsS.ps
# Step-4. Basic LS line y = a + bx
gmt trend1d -Fxm stackMTs.txt -Np1 > model.txt
gmt psxy -R-200/200/-6500/1000 -JX15c/4c -P -Bpxag100f10 -Bsxg50 -Byaf+u"m" -Bsyg2000 \
--MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
--MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
-BWSne+gazure1 -Sc0.05c -Gred stackMTs.txt -X5.0c -K > $ps
gmt psxy -R -J -W0.5p,blue model.txt \
-UBL/-15p/-45p -O -K >> $ps
echo "m@-2@-(t) = a + b\267t" | gmt pstext -R -J -F+f12p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "-180 -1500 E" | gmt pstext -R -J -F+jBR+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-5. Basic LS line y = a + bx + cx^2
gmt trend1d -Fxm stackMTs.txt -Np2 > model.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
--MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
--MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
-BWSne+gazure1 -Sc0.05c -Gred stackMTs.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.5p,blue model.txt -O -K >> $ps
echo "m@-3@-(t) = a + b\267 t + c\267t@+2@+" | gmt pstext -R -J \
-F+f12p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "-180 -1500 D" | gmt pstext -R -J -F+jBR+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-6. Basic LS line y = a + bx + cx^2 + spatial change
gmt trend1d -Fxmr stackMTs.txt -Np2,f1+l1 > model.txt
gmt psxy -R -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg2000 \
--MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
--MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
-BWSne+gazure1 -Sc0.05c -Gred stackMTs.txt -Y5.0c -O -K >> $ps
gmt psxy -R -J -W0.25p,blue model.txt -O -K >> $ps
echo "m@-5@-(t) = a + b\267t + c\267t@+2@+ + d\267cos(2@~p@~t) + e\267sin(2@~p@~t)" | gmt pstext -R -J \
-F+f10p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "-180 -1500 C" | gmt pstext -R -J -F+jBR+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-7. Plot residuals of last model
gmt psxy -R-200/200/-2500/1500 -J -Bpxag100f10 -Bsxg50 -Bpyaf+u"m" -Bsyg1000 \
--MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
--MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
-BWSne+gazure1 -W0.1 -Sc0.05c \
-Gred model.txt -i0,2 -Y5.0c -O -K >> $ps
echo "@~e@~(t) = y(t) - m@-5@-(t) (plot of the residuals)" | gmt pstext -R -J \
-F+f11p+cBL -Dj0.1i -Glightyellow -O -K >> $ps
echo "-180 500 B" | gmt pstext -R -J -F+jBR+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps

# Step-8. Plot graph
gmt psxy -R-200/200/-6500/2000 -JX15c/4c \
-Bpxag100f10+l"Distance from trench (km)" \
-Bsxg50 -Bpya2000gf+l"Depth (m)" -Bsyg2000 \
--MAP_GRID_PEN_PRIMARY=thinnest,dimgray \
--MAP_GRID_PEN_SECONDARY=thinnest,dimgray \
-BWSne+t"Southern segment of the Manila Trench" \
-Glightgray envMTs.txt -Y5.5c -O -K >> $ps
gmt psxy -R -J -W0.1p -Ey+p0.2p stackMTs.txt -O -K >> $ps
gmt psxy -R -J -W1p,red stackMTs.txt \
-O -K >> $ps

# Step-9. Add test annotations
echo "100 -5000 Philippine Sea Plate" | gmt pstext -R -J -Gwhite -F+jBL+f11p -O -K >> $ps
echo "-150 1000 Median stacked profile with error bars" | gmt pstext -R -J -Gwhite -F+jBL+f11p,red -O -K >> $ps
echo "-50 -500 Manila Trench" | gmt pstext -R -J -Gwhite -F+jBL+f11p -O -K >> $ps
echo "120 -2000 Luzon Island" | gmt pstext -R -J -Gwhite -F+jBL+f11p -O -K >> $ps
echo "-180 0 A" | gmt pstext -R -J -F+jBR+f18p,black -Gfloralwhite -W0.5p -O -K >> $ps
# Arrow
gmt psxy -R -J -Sv0.15i+bc+ea -Gyellow -W0.5p -O -K << EOF >> $ps
-10 -1000 270 1.5c
EOF
# Step-11. Add GMT logo
gmt logo -Dx6.2/-21.0+o0.25c/-1.3c+w2c -O >> $ps
# Step-12. Convert to image file using GhostScript (portrait orientation, 720 dpi)
gmt psconvert MnTtrendsS.ps -A2.0c -E720 -Tj -P -Z
# Step-13. Clean up
rm -f model.txt
