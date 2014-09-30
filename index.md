# Réseaux meshés avec `babeld`

> Auteur: Paul Ollivier <contact@paulollivier.fr>  Date:   2014-09-29

![Logo Babel](babel.png)

## Introduction

[Babel][1] est un protocol de routage destiné principalement aux réseaux sans
fil en mode ad-hoc.

![exemple de mesh de stations en mode ad-hoc](rsf_ad-hoc.png)

Les réseaux meshés posent plusieurs problèmes pour déterminer comment contacter
la machine cible. Si `A` veut contacter `E`, par quel chemin passer? Une
solution serait de rentrer les routes à la main, sur chaque station. Ce n'est
pas viable sur le long terme, et impacte sévèrement la mobilité des stations.

Afin d'obtenir un réseau dont la topologie puisse changer, nous avons
obligatoirement besoin d'une couche d'automatisation, afin de pouvoir réagir
assez rapidement. Babel a donc pour but de permettre un partage de route entre
différentes stations, qu'elles soient sans fils ou câblées. Ainsi, les tables de
routages de chaque station sont tenues à jour, avec une métrique adaptée au coût
de la liaison.

Babel est un protocole de routage pro actif à vecteur de distance, comme OSLR,
mais avec des capacités réactives, comme AODV (Il va trouver une route inconnue
très rapidement, même si non optimale. Elle sera optimisée par la suite). Il est
également conçu pour fonctionner aussi bien sur IPv4 que IPv6.

## Mise en place d'un réseau sous `babeld`

### Outils et matériels

`babeld` est l'implémentation la plus répandue du protocole Babel. Elle a été
portée sur la majorité des systèmes GNU/Linux et BSD. Il existe des paquets
Debian, des paquets RedHat, et des paquets (légèrement modifiés) existent même
pour OpenWRT. Bien que ces paquets fournissent des scripts d'init afin de
tourner en tant que service, nous avons préféré lancer directement les
exécutables `babeld` et `ahcpd` avec le paramètre `-d2`, pour afficher plus
d'informations à l'écran.

Il semble logique dans le cadre de la mise en place d'un réseau sans fils ad-hoc
d'avoir besoin d'interface sans fils. De plus, nous allons utiliser un minimum
de trois machines, dont une disposant d'une connexion internet, sous la
distribution GNU/Linux Debian.

La machine `A` disposera de deux interfaces dont une connectée à internet,
l'autre étant utilisée pour le réseau ad-hoc. Les deux autres machines n'ont
besoin que d'une interface.

Voici un schéma représentant ce réseau:
![topologie du réseau étudié](topologie.png)

Babel s'occupe de la partie routage, mais pas de la partie adressage IP des
stations. Pour ce faire, un protocole compagnon a été développé (avec son
implémentation), AHCP. AHCP fonctionne plus ou moins comme DHCP, mais adapté aux
réseaux ad-hoc. Les différents clients et serveur AHCP vont donc propager les
requêtes d'adresses IP, afin d'assurer une distribution dans tout le réseau.

### Configuration des interfaces

Nous allons configurer de manière temporaire les stations. Pour cela, nous
allons utiliser `ifconfig` et `iwconfig`. Dans un premier temps, nous
utiliserons une configuration IP manuelle.  <!-- TODO: réécrire ça avec iw et ip
-->



Pour commencer, nous allons configurer les interfaces participant au mesh sur
les stations `A`, `B` et `C`:

```bash
ifconfig wlan0 down
iwconfig wlan0 mode ad-hoc essid babel-mesh
iwconfig wlan0 channel 1 ap ca:fe:ca:fe:ca:fe
```

Remarquons l'usage d'`ap ca:fe:ca:fe:ca:fe` afin de définir la cellule que nous
souhaitons rejoindre. Cela permet de s'assurer aisément que deux stations soient
bien dans la même cellule.

Après avoir vérifié que les trois interfaces se situent dans la même cellule,
nous allons pouvoir configurer les addresses IP. La commande `ifconfig` permet
de donner une addresse à une interface, avec la syntaxe suivante: `ifconfig
wlan0 <ip>/<masque>`.

- `A`: `192.168.0.129/25`
- `B`: `192.168.0.130/25`
- `C`: `192.168.0.131/25`

Enfin, nous allons pouvoir rallumer les interfaces: `ifconfig wlan0 up`

À ce stade, nous allons pouvoir lancer babel et observer les tables de routage
se remplir. Pour ce faire, il est intéressant d'utiliser un multiplexeur de
terminal, comme [`tmux`][2] ou [`screen`][3]. Notons que la commande `watch -d`
permet de surligner les différences entre deux exécutions de la commande passée
en paramètre. Il est ainsi recommandé de surveiller au moins la commande `ip r`,
qui affiche les routes, ainsi que leurs états. `ip a s wlan0` affiche des
détails sur l'interface.


<!-- footer -->
## Aller plus loin

Babel est capable d'utiliser deux interfaces pour communiquer avec d'autres
stations en duplex. Il peut être intéressant d'étudier cet aspect.

[1]: http://www.pps.univ-paris-diderot.fr/~jch/software/babel/
[2]: http://tmux.sourceforge.net/
[3]: http://www.gnu.org/software/screen/

<!--  vim: tw=80:ts=4:spell:spelllang=fr,en
-->
