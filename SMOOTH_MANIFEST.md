# SMOOTH_MANIFEST.md

## Projet
- Nom: vente_app (Suivi de Vente)
- Type: mobile (iOS, Android, macOS, Web, Windows)
- Client: Smooth & Design (outil interne / client commerce)
- Statut: archive

## Stack
- Frontend: Flutter 2.12+ / Dart
- Backend: Firebase (Firestore, Cloud Functions, Storage)
- Auth: N/A (pas de firebase_auth dans les dépendances)
- Base de données: Cloud Firestore
- Autres:
  - Cloud Functions Node.js (backup Firestore automatique toutes les 24h)
  - Syncfusion Calendar (calendrier professionnel)
  - API Météo (weather_icons)
  - Animations (animated_text_kit, animate_do, animated_splash_screen)
  - Internationalisation (intl, flutter_sheet_localization, localization)
  - Native Splash Screen

## Features implémentées
- Suivi des ventes journalières
- Dashboard avec statistiques de vente
- Calendrier des événements (Syncfusion Calendar)
- Gestion des produits (CRUD)
- Statistiques par mois (chiffres mensuels)
- Affichage météo
- Upload d'images (image_picker, file_picker)
- Backup automatique Firestore (Cloud Function, every 24h vers gs://suivi-backup)
- Splash screen natif personnalisé

## Patterns notables
- Architecture: MVC (model/, view/, controller/, utils/)
- State Management: Provider
- Collections Firestore: events, products (+ backup complet automatique)
- Controller pattern: FirebaseApi/, FirebaseStorage/, event_databases/, event_provider_data/, product_databases/
- Views: dashboard/, home/, layout/, stats/
- Models: my_event, product, meteo, chiffres_by_month, event_data_source, event_provider
- Conventions de nommage: snake_case pour fichiers, PascalCase pour dossiers controllers Firebase

## Réutilisabilité
- Snippets clés:
  - Cloud Function de backup Firestore automatique (functions/index.js) — réutilisable sur tout projet Firebase
  - Pattern MVC Flutter simple et clair
  - Intégration Syncfusion Calendar
  - Gestion événements avec Provider
  - Pattern FirebaseApi / FirebaseStorage séparé
