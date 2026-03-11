# my_inventory
# Definition of Done (DoD) — supermoms

Cette DoD s’applique à toute User Story / Issue terminée.

## 1) Fonctionnel

 La fonctionnalité demandée est implémentée et correspond à la description de l’issue.
 Les critères d’acceptation de l’issue sont respectés (ou mis à jour et approuvés).
 Les cas d’erreur sont gérés (ex: champs obligatoires, QR invalide, carton introuvable).
 Aucun crash connu sur le parcours principal.
## 2) Qualité de code

 Le code est lisible (noms clairs, pas de code mort, pas de TODO oubliés).
 L’architecture du projet est respectée (UI / logique / data séparés selon vos conventions).
 Les changements sont limités au scope de l’issue (pas de refactor “gratuit” non lié).
## 3) Tests
Minimum requis selon le type de travail :

 Si logique métier / data : tests unitaires ajoutés ou mis à jour.
 Si UI critique : au moins 1 test widget (smoke test) ou une justification écrite si non applicable.
 Tous les tests passent localement :
flutter test
## 4) Build / Lint / Analyse

 flutter analyze ne rapporte aucune erreur (warnings acceptés seulement si justifiés).
 Le projet compile (au minimum sur la/les plateforme(s) ciblée(s)) :
Android : flutter build apk ou flutter run sur émulateur/appareil
 Aucune dépendance cassée : flutter pub get fonctionne.
## 5) UX / UI

 Les textes sont compréhensibles (FR cohérent), pas de libellés “placeholder”.
 Les états sont gérés : chargement / vide / erreur.
 Navigation OK (retour arrière, ouverture écran détail, etc.).
## 6) Données & Persistance (si applicable)

 Les données créées/modifiées sont persistées correctement (après redémarrage de l’app).
 Les changements de modèle (si DB) incluent migration ou stratégie équivalente.
 Aucun fichier local dépendant de la machine n’est commité (ex: android/local.properties).
**## 7) Git / PR **

 La branche est à jour avec main si nécessaire.
 Le commit message est clair et lié à l’issue (ex: #12 Add carton creation screen).
 La PR contient : description + capture(s) si UI.
 Revue : au moins 1 approbation (ou règle d’équipe).
 CI verte (si configurée).
## 8) Documentation

 Si l’usage a changé : README / doc mise à jour (ou note dans la PR).
 Si nouvelle dépendance/permission : documentée (ex: caméra pour QR).
### Definition of Ready

 L’issue a des critères d’acceptation clairs.
 Les maquettes/écrans attendus sont connus (ou “best effort” accepté).
 Dépendances identifiées (ex: lib QR, permissions).
 
## First Flutter project.
## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
