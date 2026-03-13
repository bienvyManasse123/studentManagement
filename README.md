# 🎓 Student Management
 
> Application mobile de gestion des étudiants — notes, moyennes, statistiques et visualisations graphiques.

 
## ✨ Fonctionnalités
 
### Gestion des étudiants
- ➕ **Ajouter** un étudiant avec nom, note de maths et note de physique
- 📋 **Lister** tous les étudiants avec leurs notes et moyennes calculées automatiquement
- ✏️ **Modifier** un enregistrement via un glissement vers la droite
- 🗑️ **Supprimer** un enregistrement via un glissement vers la gauche
- 🔔 **Notifications toast** pour confirmer chaque action (ajout, modification, suppression)
 

### Visualisations graphiques
- 📊 **Histogramme** — comparaison des moyennes min / classe / max
- 🥧 **Camembert** — répartition min vs max
- Toggle animé entre les deux vues
 

### Stack technique
 
| Couche | Technologie | Rôle |
|--------|-------------|------|
| Frontend | Flutter 3.41.4 | Interface mobile |
| Backend | FastAPI | API REST |
| ORM | SQLAlchemy 2.0 | Gestion base de données |
| Base de données | PostgreSQL 15+ | Stockage des données |
| Validation | Pydantic v2 | Validation des entrées API |
| Graphiques | fl_chart | Histogramme et camembert |
| HTTP Client | http (Dart) | Appels API depuis Flutter |
 
---

## 📦 Prérequis

### Système

![FastAPI](https://img.shields.io/badge/FastAPI-0.111-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3.10+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Android SDK](https://img.shields.io/badge/Android_SDK-36-3DDC84?style=for-the-badge&logo=android&logoColor=white)
 
## ⚙️ Installation Backend
 
### 1. Cloner le projet et aller dans le dossier backend


```bash
git clone https://github.com/bienvyManasse123/studentManagement.git

cd backend/
```
 
### 2. Créer et activer l'environnement virtuel
```bash
# Créer
python -m venv venv
 
# Activer — Linux/macOS
source venv/bin/activate
 
# Activer — Windows
venv\Scripts\activate
```
 
### 3. Installer les dépendances
```bash
pip install -r requirements.txt
```

### 4. Configurer BD
```sql
-- Créer votre Base de données dans postgresql
```
### 5. Configurer les variables d'environnement
Créer un fichier `.env` à la racine du dossier `backend/` :
```env
DATABASE_URL=postgresql://postgres:votre_mot_de_passe@localhost:5432/votre_base_de_données
```

## 📱 Installation Frontend
 
### 1. Aller dans le dossier frontend
```bash
cd frontend/student_management_front/
```
 
### 2. Installer les dépendances Flutter
```bash
flutter pub get
```
 
### 3. Configurer l'URL de l'API
 
Dans `lib/services/api_service.dart` :
 
```dart
// Développement local (navigateur/émulateur)
static const String baseUrl = 'http://localhost:8000';
 
// Téléphone Android réel (remplacer par l'IP de votre PC)
static const String baseUrl = 'http://192.168.X.X:8000';
```
 
## 🚀 Lancement
 
### Backend
```bash
cd backend/
source venv/bin/activate   # ou venv\Scripts\activate sur Windows
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```
 
### Frontend
```bash
cd frontend/student_management_front/
 
# Lister les appareils disponibles
flutter devices
 
# Lancer sur Android réel
flutter run -d <DEVICE_ID>
 
# Lancer sur Chrome
flutter run -d chrome
 
# Lancer sur Windows Desktop
flutter run -d windows
```

## 👁 Aperçu

### Quelque images du projet

![HomePage](screenshots/homepage.jpeg)
![Stats](screenshots/stat.jpeg)
---