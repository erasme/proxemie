# proxemie
Dispositif de banc jouable augmenté

## Mise en place du dispositif

*A compléter*

### Augmenta

Installer le dispositif Augmenta et veiller à bien configurer son adresse IP de destination vers la machine exécutant le programme Augmenta-Area-2-0SC, et le port sur celui écouté par Augmenta-Area-2-0SC (12000 par défaut).

### Augmenta-Area-2-0SC

**TODO : ajouter l'app Augmenta-Area-2-0SC préconfigurée**

A l'aide d'objets ou personnes positionnées aux bons emplacements sur l'assise du banc, régler les zones de détection autour de chaque emplacement.

### Hand Tracker

cf manuel ci-dessous
Régler le slider Hand Far threshold de sorte que l'assise ne soit pas détectée, et le slider Hand Near threshold de sorte que la partie haute du corps des joueurs ne soit pas détectée non plus.

## Démarrage du dispositif 

L'ordre de démarrage des applications suivantes n'a pas d'importance.

- Démarrer l'application de détection sur les assises : Augmenta-Area-2-0SC
- Démarrer l'application de détection des mains : `/ofTools/HandTracker/bin/HandDetect2.app`
- Démarrer l'application de jeu : `/augmentedBench/augmentedBench.pde`

**TODO : générer un binaire de l'application augmentedBench et ajouter l'app Augmenta-Area-2-0SC préconfigurée**

## Manuel HandTracker

### OSC

- `/handTracker/handsTracked` (int) : nombre de mains trackées
- `/handTracker/hand#` avec # étant le numéro de la main : (int)(int) position x et y de la main

### GUI

- OSC host et port : addresse de la machine où sont envoyées les données OSC
- Hand near/far threshold : seuil de détection de la main (niveau de gris entre 0-255)
- Near/far depth clipping : seuil de détection de la Kinect 
