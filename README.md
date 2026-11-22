<div align="center">

# 🐄🌸 Cutie Farm 🌸🐰

### Un jeu d'habillage mignon avec mes 4 animaux dessinés à la main

![Godot](https://img.shields.io/badge/Godot-4.7-478CBF?style=for-the-badge&logo=godotengine&logoColor=white)
![GDScript](https://img.shields.io/badge/GDScript-2D-FF5FA8?style=for-the-badge)
![Plateforme](https://img.shields.io/badge/Windows-PC-FFB3D1?style=for-the-badge&logo=windows&logoColor=white)
![Statut](https://img.shields.io/badge/Statut-Premier%20projet-FF8DC2?style=for-the-badge)

*Choisis ton animal, habille-le, mets-le dans un décor, ajoute un cadre, et prends ta photo.* 📸

</div>

---

##  Hey, les gens !

C'est mon **tout premier projet avec Godot**, et mon premier projet fait avec l'aide d'une **IA** pour la partie code (les scripts GDScript).

C'est un **jeu 2D** avec **4 animaux que j'ai dessinés moi-même** : une vache, un chat, un singe et un lapin. Tout ce qui est visuel et toute l'idée du jeu viennent de moi :

- j'ai **dessiné les 4 personnages**
-  j'ai **designé les vêtements** (hauts, jupes, shorts, pantalons...)
-  j'ai **choisi et designé l'écriture** (les polices, le texte blanc avec un petit contour)
-  j'ai **pensé tout le jeu** : l'ambiance, les écrans, le rose Barbie, le curseur barbe à papa, la musique
-  l'IA m'a aidée à **corriger les scripts** pendant que je testais et que je demandais des changements

> Ce projet m'a pris beaucoup de temps, contrairement à ce que je pensais , pour une première je trouve que je me débrouille pas mal

---

##  Comment ça se joue

| Étape | Écran | Ce qu'on fait |
|:---:|---|---|
| 1 |  **Accueil** | Une ferme, un bouton **PLAY** |
| 2 |  **Choix de l'animal** | Vache, chat, singe ou lapin |
| 3 |  **Habillage** | Hauts et bas, placés à la main sur le personnage |
| 4 |  **Photo** | Fond, cadre, et enregistrement d'une vraie photo PNG |

### ✨ Ce qu'on peut faire

- **Habiller** l'animal avec des hauts et des bas (les dossiers sont lus automatiquement)
- **Déplacer** un vêtement avec la souris, le **agrandir / rétrécir** avec **+** et **-** ou la molette, le **tourner** avec **Maj + molette**
- **Choisir un fond** parmi 14 décors roses
- **Ajouter un cadre** et le déplacer, le redimensionner, le tourner
- **Écouter de la musique** en boucle pendant tout le jeu, et la changer quand on veut
- **Enregistrer sa photo** en PNG dans le dossier `Images/CutieFarm`
- Un **curseur personnalisé** en barbe à papa 🍭

###  Commandes

| Action | Commande |
|---|---|
| Sélectionner un vêtement | Clic dessus |
| Déplacer | Clic maintenu + glisser |
| Taille | Molette, ou boutons **+** / **-** |
| Rotation | **Maj + molette**, ou bouton **Tourner** |
| Revenir au placement de départ | Bouton **Reset** |

---

## Diagrammes

> Les diagrammes ci-dessous sont écrits en **Mermaid** : GitHub les affiche automatiquement.

### Diagramme de classes

```mermaid
classDiagram
    class Global {
        <<Autoload>>
        +String chosen_animal
        +String top_path
        +String bottom_path
        +String background_path
        +String frame_path
        +Dictionary top_xf
        +Dictionary bottom_xf
        +_setup_cursor()
    }

    class MusicPlayer {
        <<Autoload>>
        +Array songs
        +bool is_on
        +_play_song(path)
        +_stop()
        +_on_play_pressed()
    }

    class UIStyle {
        <<Utilitaire>>
        +Color PINK
        +Color PINK_BG
        +style_label(label, size)
        +style_button(btn, size)
        +style_button_inverse(btn, size)
        +make_tools(plus, minus, rotate, reset)
    }

    class AssetUtil {
        <<Utilitaire>>
        +list_files(dir, exts)
        +list_images(dir)
        +find(base)
    }

    class OptionPanel {
        +Array tabs
        +add_section(title, dir, callback)
        +_select(index)
    }

    class AnimalDoll {
        +String animal_name
        +float height
        +bool editable
        +setup(animal, h)
        +set_top(path)
        +set_bottom(path)
        +scale_selected(factor)
        +rotate_selected(deg)
        +reset_selected()
    }

    class MainMenu {
        <<Scene>>
        +_on_start_pressed()
    }
    class CharacterSelect {
        <<Scene>>
        +_on_animal_chosen(animal)
    }
    class DressUp {
        <<Scene>>
        +_on_top(path)
        +_on_bottom(path)
    }
    class Photo {
        <<Scene>>
        +_on_background(path)
        +_on_frame(path)
        +_take_photo()
    }

    MainMenu --> CharacterSelect : change de scène
    CharacterSelect --> DressUp : change de scène
    DressUp --> Photo : change de scène

    CharacterSelect ..> Global : écrit l'animal
    DressUp ..> Global : écrit les vêtements
    Photo ..> Global : écrit fond et cadre

    DressUp *-- AnimalDoll
    DressUp *-- OptionPanel
    Photo *-- AnimalDoll
    Photo *-- OptionPanel

    AnimalDoll ..> Global : lit et sauvegarde les réglages
    OptionPanel ..> AssetUtil : liste les images
    OptionPanel ..> UIStyle
    MusicPlayer ..> AssetUtil
    MusicPlayer ..> UIStyle
```

###  Diagramme d'états : le parcours du jeu

```mermaid
stateDiagram-v2
    [*] --> Accueil

    Accueil --> ChoixAnimal : PLAY
    ChoixAnimal --> Accueil : Retour
    ChoixAnimal --> Habillage : choisir un animal

    Habillage --> ChoixAnimal : Retour
    Habillage --> Photo : Suivant

    Photo --> Habillage : Retour
    Photo --> Photo : enregistrer la photo

    state Habillage {
        [*] --> RienDeSelectionne
        RienDeSelectionne --> VetementSelectionne : clic sur un vêtement
        VetementSelectionne --> VetementSelectionne : glisser, +, -, tourner
        VetementSelectionne --> RienDeSelectionne : clic à côté
    }
```

###  Diagramme d'états : la musique

```mermaid
stateDiagram-v2
    [*] --> Silence
    Silence --> Lecture : choisir une chanson
    Lecture --> Lecture : choisir une autre chanson
    Lecture --> Pause : bouton pause
    Pause --> Lecture : bouton lecture
    Lecture --> Silence : "Pas de musique"
    Pause --> Silence : "Pas de musique"
```

> La musique est un *Autoload* : elle continue pendant tous les écrans et se lit en boucle.

### Diagramme d'interaction (séquence) : habiller l'animal

```mermaid
sequenceDiagram
    actor J as Joueuse
    participant C as CharacterSelect
    participant G as Global
    participant D as DressUp
    participant P as OptionPanel
    participant A as AnimalDoll

    J->>C: Clique sur un animal
    C->>G: chosen_animal = "cow"
    C->>D: change_scene_to_file
    D->>A: setup(animal, hauteur)
    D->>P: add_section(Hauts) et add_section(Bas)
    P-->>J: Affiche les vêtements (dossiers lus automatiquement)

    J->>P: Clique sur un haut
    P->>D: _on_top(path)
    D->>G: top_path = path
    D->>A: set_top(path)
    A-->>J: Le haut apparaît, déjà sélectionné

    J->>A: Glisse le vêtement
    A->>G: sauvegarde position, taille, rotation
    A-->>J: Le cadre rose suit le vêtement
```

### Diagramme d'interaction (séquence) : prendre une photo

```mermaid
sequenceDiagram
    actor J as Joueuse
    participant P as Photo
    participant V as SubViewport
    participant FS as Dossier Images

    J->>P: Choisit un fond
    P->>V: bg_rect.texture = fond
    J->>P: Choisit un cadre
    P->>V: frame_rect.texture = cadre
    J->>P: Glisse, molette, Maj + molette
    P->>V: déplace, agrandit, tourne le cadre

    J->>P: Clique sur "Photo"
    P->>V: attend la fin du dessin
    V-->>P: image 810 x 1080
    P->>FS: enregistre photo_date_heure.png
    P-->>J: "Photo enregistrée"
```

### Vue d'ensemble de l'architecture

```mermaid
flowchart LR
    subgraph Autoloads["Toujours actifs"]
        G[Global<br/>mémoire du jeu]
        M[MusicPlayer<br/>musique en boucle]
    end

    subgraph Scenes["Scènes"]
        S1[main_menu] --> S2[character_select] --> S3[dress_up] --> S4[photo]
    end

    subgraph Outils["Scripts utilitaires"]
        U1[UIStyle]
        U2[AssetUtil]
        U3[OptionPanel]
        U4[AnimalDoll]
    end

    Scenes --> G
    Scenes --> Outils
    M --> Outils
```

---

## Structure du projet

```
cutie-farm/
├── art/
│   ├── cow.png  cat.png  monkey.png  rabbit.png   ← mes 4 animaux
│   ├── farm.JPG                                    ← l'écran d'accueil
│   ├── top/                                        ← les hauts
│   ├── pants/                                      ← les bas
│   ├── backgrounds/                                ← les fonds
│   ├── frame/                                      ← les cadres
│   ├── boutons/                                    ← play, run, pause, curseur
│   ├── fonts/                                      ← les polices
│   └── music/                                      ← les musiques
├── scene/
│   ├── main_menu.tscn
│   ├── character_select.tscn
│   ├── dress_up.tscn
│   └── photo.tscn
├── script/
│   ├── global.gd            (Autoload)
│   ├── music_player.gd      (Autoload)
│   ├── ui_style.gd
│   ├── asset_util.gd
│   ├── option_panel.gd
│   ├── animal_doll.gd
│   ├── main_menu.gd
│   ├── character_select.gd
│   ├── dress_up.gd
│   └── photo.gd
└── project.godot
```

>  Les dossiers `top`, `pants`, `backgrounds`, `frame` et `music` sont **lus automatiquement** : pour ajouter un vêtement, un fond ou une chanson, il suffit de déposer le fichier dans le bon dossier.

---

## Lancer le jeu

1. Installer [Godot 4](https://godotengine.org/download)
2. Cloner ce dépôt :
   ```bash
   git clone https://github.com/NanouDi/cutie-farm.git
   ```
3. Ouvrir Godot, cliquer sur **Importer**, choisir le fichier `project.godot`
4. Cliquer sur le bouton **▶** en haut à droite

---

##  Fait avec

- **Godot Engine 4.7** (2D, GDScript)
- **Un assistant IA** pour corriger les scripts
- **Mes dessins** pour tout le reste 🎨
- **Pinterest** pour bcp, merci pour les travaux

---

##  La suite (Insh'Allah écoute)

- [ ] Un onglet **Accessoires** (chapeaux, lunettes, bijoux)
- [ ] Ajouter du **texte** sur la photo, avec mes polices
- [ ] Plus de vêtements et plus de fonds
- [ ] Enregistrer la photo sur téléphone
- [ ] Exporter le jeu en `.exe` pour Windows

---

## ⚠️ À propos des images et des musiques

Les dessins des animaux, des vêtements sont **à moi**, et on été crée par moi (genre déssinés cause AI art isn't it ). les fonds, cadres (dont des cadres Hello Kitty) et toutes les chansons viennent d'autres personnes (pinterest) ou d'autres marques : ils sont utilisés ici pour un **projet personnel d'apprentissage** et ne sont pas libres de droits. Si le jeu est publié un jour (même si je pense pas mdr ), ils seront remplacés.

---

<div align="center">

## 🌷 Créé par

### **Nabintou Diakite**
*Nanou pour les intimes*

⏱️ **Temps passé sur le projet :** 12h-15h heures sur 3 jours

*Fait avec beaucoup de rose, de patience et de musique de Doja* 🍭

</div>
