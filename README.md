# MyInventory

L'assistant intelligent pour un déménagement sans stress.

## Description de l’application

MyInventory est une application mobile conçue pour simplifier l'organisation et la gestion des cartons lors d'un déménagement. Elle permet aux utilisateurs de cataloguer le contenu de chaque boîte, de générer des étiquettes uniques avec codes QR et de retrouver instantanément n'importe quel objet sans avoir à ouvrir les cartons. L'application s'adresse à toute personne en phase de transition résidentielle souhaitant gagner du temps et de l'efficacité lors du déballage.

## Problème ou besoin

Lors d'un déménagement, il est fréquent de perdre la trace d'objets précis (ex: la cafetière, les câbles réseau ou les draps) parmi des dizaines de cartons identiques. Le problème est double : l'étiquetage manuel au marqueur est souvent trop vague ("Cuisine 1"), et l'utilisateur perd un temps considérable à ouvrir des boîtes scellées pour trouver un article urgent. MyInventory résout ce problème en rendant chaque carton "transparent" grâce à la technologie QR.

## Fonctionnalités principales

**Fonctionnalité 1** : Inventaire dynamique par carton — Création de boîtes virtuelles avec ajout d'une liste détaillée d'objets, sélection de la pièce de destination (salon, cuisine, etc.) et indicateur "Fragile".

**Fonctionnalité 2** : Génération d'étiquettes PDF & QR — Création automatique d'une fiche au format PDF contenant un code QR unique lié à l'ID du carton, prête à être partagée ou imprimée.

**Fonctionnalité 3** : Scanner de contenu instantané — Utilisation de la caméra pour scanner le code QR d'un carton physique et afficher immédiatement à l'écran la liste complète de son contenu.

## Parcours utilisateur (User Flow)

**1**. L'utilisateur ouvre l'application et accède au tableau de bord.

**2**. Il appuie sur le bouton "+" pour créer un nouveau carton.

**3**. Il saisit le nom du carton, choisit la pièce de destination et liste les objets à l'intérieur.

**4**. Il génère l'étiquette QR qu'il peut imprimer ou sauvegarder.

**5**. Une fois le carton scellé, il peut à tout moment utiliser l'icône de scan pour vérifier ce qui se trouve à l'intérieur.

**6**. Il peut utiliser la barre de recherche globale pour trouver dans quel carton se situe un objet spécifique.

## Interface (UI) envisagée

**Écran d'accueil** : Une liste élégante (Cards) des cartons existants avec un bouton d'action flottant (FAB) pour le scan.

**Écran de création** : Un formulaire structuré avec des champs texte et une liste dynamique pour ajouter/supprimer des articles.

**Écran de visualisation** : Un affichage clair du contenu après scan, utilisant des icônes pour distinguer les catégories d'objets.

## Données utilisées

**Saisie utilisateur** : Noms des objets, descriptions, noms des pièces.

**Données locales** : Toutes les informations sont stockées localement sur le téléphone (via une base de données comme Isar ou Hive) pour garantir un accès hors-ligne pendant le déménagement.

**Génération de fichiers** : Production de fichiers PDF encodant les données sous forme de Barcode/QR.

## Complexité estimée

**Ce qui semble facile** : La création de l'interface utilisateur avec Flutter (Material 3) et la navigation entre les écrans.

**Ce qui semble plus difficile** : L'intégration fluide de la caméra pour le scan de codes QR en temps réel et la mise en page dynamique du PDF pour l'exportation des étiquettes.

## Idées d’amélioration (optionnel)

**1**: Ajout de photos pour chaque carton ou même pour chaque objet.

**2** : Synchronisation avec un service Cloud (Firebase) pour permettre à plusieurs membres de la famille de gérer l'inventaire en même temps.
