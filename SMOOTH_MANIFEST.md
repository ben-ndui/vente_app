# SMOOTH_MANIFEST.md

## Projet
- Nom: vente_app (suividevente)
- Type: mobile (iOS, Android, macOS, Web)
- Client: Smooth & Design (interne / usage personnel)
- Statut: archive (dernier push: septembre 2021)

## Stack
- Frontend: Flutter 2.x (Dart, SDK >=2.12.0 <3.0.0)
- Backend: Firebase Cloud Functions (Node.js — backup Firestore automatique)
- Auth: none (pas d'authentification utilisateur detectee)
- Base de donnees: Firestore
- Autres: Syncfusion Calendar, Provider, animated_splash_screen, flutter_native_splash, weather_icons, image_picker, file_picker

## Features implementees
- Suivi de ventes quotidien avec calendrier Syncfusion (vue jour/semaine/mois)
- Gestion de produits (CRUD complet : ajout, modification, suppression, recherche)
- Panier de vente par evenement/marche (ajout de produits au panier, calcul de total)
- Evenements de marche ("Marche du matin", "Marche du soir") avec code couleur
- Suivi meteo par evenement (soleil, nuage, pluie, orage, etc.)
- Statistiques de chiffres d'affaires par mois
- Dashboard de suivi des ventes
- Backup automatique Firestore toutes les 24h via Cloud Function
- Splash screen anime
- Upload d'images pour les produits (Firebase Storage)
- Localisation francaise
- Orientation paysage forcee

## Patterns notables
- Architecture: MVC (model / view / controller) avec Provider pour le state management
- Structure: lib/model (Product, MyEvent, EventProvider, EventDataSource, ChiffresByMonth, Meteo), lib/view (dashboard, home, layout, stats), lib/controller (FirebaseApi, FirebaseStorage, event_databases, event_provider_data, product_databases), lib/utils (constants, theme, menu_item, utils)
- Collections Firestore:
  - `products` — catalogue de produits (uid, title, price, img, nbProd, isHidden)
  - `events` — evenements de vente organises par mois/annee avec sous-collection `all`, chaque evenement a une sous-collection `panier`
  - `chiffres` — chiffres d'affaires organises par annee avec sous-collections par type de marche
- Conventions de nommage: snake_case (fichiers), camelCase (variables), PascalCase (classes)

## Reutilisabilite
- Snippets cles:
  - `lib/controller/event_databases/event_databases.dart` — service Firestore complet avec streams, CRUD, sous-collections imbriquees
  - `lib/controller/product_databases/product_database.dart` — service Firestore generique pour produits avec recherche
  - `lib/model/my_event.dart` — modele evenement avec panier integre et calcul de total
  - `lib/utils/constants.dart` et `lib/utils/theme.dart` — constantes et theming reutilisables
  - `functions/index.js` — Cloud Function de backup Firestore automatique (schedule every 24h)
