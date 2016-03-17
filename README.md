# proxemie
Dispositif de banc jouable augmenté

## Manuel HandTracker

### OSC

- `/handTracker/handsTracked` (int) : nombre de mains trackées
- `/handTracker/hand#` avec # étant le numéro de la main : (int)(int) position x et y de la main

### GUI

- OSC host et port : addresse de la machine où sont envoyées les données OSC
- Hand near/far threshold : seuil de détection de la main (niveau de gris entre 0-255)
- Near/far depth clipping : seuil de détection de la Kinect 
