# MyInventory

L'assistant intelligent pour un déménagement sans stress.

## 📝 Description de l’application

MyInventory est une application mobile conçue pour simplifier l'organisation et la gestion des cartons lors d'un déménagement. Elle permet aux utilisateurs de cataloguer le contenu de chaque boîte, de générer des étiquettes uniques avec codes QR et de retrouver instantanément n'importe quel objet sans avoir à ouvrir les cartons.

## 🚀 Fonctionnalités principales

- **Inventaire dynamique** : Création de boîtes virtuelles avec liste détaillée et indicateur "Fragile".
- **Étiquettes PDF & QR** : Génération automatique d'étiquettes prêtes à imprimer.
- **Scanner QR** : Visualisation instantanée du contenu d'un carton physique.
- **Recherche globale** : Localisation rapide d'un objet parmi tous les cartons.

---

## 🛠 Installation et Lancement

### Prérequis

- Flutter SDK (dernière version stable)
- Android Studio / VS Code avec extensions Flutter & Dart
- Un émulateur ou un appareil physique

### Installation

1. Cloner le repository :

   ```bash
   git clone https://github.com/H26-DAM2/supermoms.git
   ```

2. Récupérer les dépendances :

   ```bash
   flutter pub get
   ```

### Lancement

Pour lancer l'application en mode debug :

```bash
flutter run
```

### Tests

Pour exécuter les tests unitaires et de widgets :

```bash
flutter test
```

---

## 📂 Structure du projet (Feature-First)

Le projet utilise une architecture **Feature-First** pour assurer la modularité et faciliter le travail en équipe :

```text
lib/
├── app/
│   └── theme/
│       ├── app_colors.dart      //  les dégradés et palettes
│       ├── app_text_styles.dart  // les styles (headerTitle, statsNumber, etc.)
│       └── app_theme.dart        // Configuration ThemeData (Material 3)
├── shared/
│   └── widgets/
│       └── gradient_header.dart  // Widget réutilisable pour le haut de page
|       └── primary_button.dart  // Widget réutilisable pour le scan bouton
├── src/
│   ├── Data/
│   │   └── data.dart             // MockData (les listes de cartons d'exemple)
│   ├── models/
│   │   ├── carton.dart           // Classe Carton
│   │   ├── carton_item.dart      // Classe CartonItem
│   │   └── room.dart             // Enum Room (Cuisine, Salon, etc.)
│   └── screens/
│       └── home_screen.dart      // écran principal
└── main.dart                     // Point d'entrée avec MaterialApp
```

---

## 🤝 Conventions de l'équipe

### Nommage des branches

Nous utilisons le format suivant : `type/id-description-courte`

- `feature/` : Nouvelle fonctionnalité (ex: `feature/us2-readme-config`)
- `fix/` : Correction de bug
- `chore/` : Tâches de maintenance ou config

### Conventions de Commits

Nous suivons les [Conventional Commits](https://www.conventionalcommits.org/) :

- `feat:` : Ajout d'une fonctionnalité
- `fix:` : Correction d'un bug
- `docs:` : Modification de la documentation
- `style:` : Formatage, point-virgule manquant, etc. (pas de changement de code)
- `chore:` : Mise à jour des tâches build, packages, etc.

### Qualité de code

Avant chaque push, assurez-vous de passer l'analyse :

```bash
flutter analyze
dart format .
```

---

## 📊 Données & Technologie

- **Stockage** : Local (Hive ou Isar) pour un accès offline.
- **UI** : Flutter Material 3.
- **Génération PDF** : Package `pdf`.
- **Scan QR** : Package `mobile_scanner`.
