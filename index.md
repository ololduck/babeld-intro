# Réseaux meshés avec `babeld`

> Auteur: Paul Ollivier <contact@paulollivier.fr>  
> Date:   2014-09-29

![Logo Babel](babel.png)

## Introduction

[Babel][1] est un protocol de routage destiné principalement aux réseaux sans fil en mode ad-hoc.

![exemple de mesh de stations en mode ad-hoc](rsf_ad-hoc.png)

Les réseaux meshés posent plusieurs problèmes pour déterminer comment contacter la machine cible. Si `A` veut contacter `E`, par quel chemin passer? Une solution serait de rentrer les routes à la main, sur chaque station. Ce n'est pas viable sur le long terme, et impacte sévèrement la mobilité des stations.

Afin d'obtenir un réseau dont la topologie puisse changer, nous avons obligatoirement besoin d'une couche d'automatisation, afin de pouvoir réagir assez rapidement. Babel a donc pour but de permettre un partage de route entre différentes stations, qu'elles soient sans fils ou câblées. Ainsi, les tables de routages de chaque station sont tenues à jour, avec une métrique adaptée au coût de la liaison.

Babel est conçu pour fonctionner aussi bien sur IPv4 que IPv6.

## Mise en place d'un réseau sous `babeld`

### Outils et matériels

Il semble logique dans le cadre de la mise en place d'un réseau sans fils ad-hoc d'avoir besoin d'interface sans fils. De plus, nous allons utiliser un minimum de trois machines, dont une disposant d'une connexion internet, sous Debian.

La machine `A` disposera de deux 

`babeld` est l'implémentation la plus répandue du protocole Babel. Elle a été portée sur la majorité des systèmes GNU/Linux et BSD. Il existe des paquets Debian, des paquets RedHat, et des paquets (légèrement modifiés) existent même pour OpenWRT. 

Babel s'occupe de la partie routage, mais pas de la partie adressage IP des stations. Pour ce faire, un protocole compagnon a été développé (avec son implémentation), AHCP. AHCP fonctionne plus ou moins comme DHCP, mais adapté aux réseaux ad-hoc. Les différents clients et serveur AHCP vont donc propager les requêtes d'adresses IP, afin d'assurer une distribution dans tout le réseau.



## Aller plus loin

Babel est capable d'utiliser deux interfaces pour communiquer avec d'autres station en duplex. Il peut être intéressant d'étudier cet aspect.

[1]: http://www.pps.univ-paris-diderot.fr/~jch/software/babel/
