# Child Health Record Booklet

A secure Flutter application for offline health data collection for children in remote areas, with secure local storage and authenticated data upload via eSignet once internet connectivity is restored.

## Features

### 🔒 **Secure Offline Data Collection**
- Complete offline functionality for health data collection
- Local SQLite database with encrypted storage
- AES-256 encryption for sensitive health data
- Secure photo capture and storage

### 👶 **Child Health Management**
- Comprehensive child registration with photo capture
- Detailed health record management
- Growth tracking with charts and visualizations
- Vaccination schedule management
- Medical history tracking

### 📊 **Health Data Collection**
- Physical measurements (weight, height, head circumference)
- Vital signs (temperature, heart rate, blood pressure)
- Vaccination records
- Medical symptoms and diagnosis
- Treatment and medication tracking
- Doctor and hospital information

### 🔄 **eSignet Integration**
- Secure data synchronization with eSignet
- Encrypted data transmission
- Offline queue management
- Connection status monitoring
- Manual and automatic sync options

### 📱 **User-Friendly Interface**
- Modern Material Design 3 UI
- Intuitive navigation
- Search and filter functionality
- Responsive design for various screen sizes
- Dark/light theme support

## Technical Architecture

### **Backend Services**
- **DatabaseService**: SQLite local database management
- **EncryptionService**: AES-256 data encryption
- **SyncService**: eSignet API integration and data synchronization

### **Data Models**
- **Child**: Child registration and demographic data
- **HealthRecord**: Comprehensive health data structure

### **Key Features**
- Offline-first architecture
- Secure data encryption
- Real-time connectivity monitoring
- Data export capabilities
- Comprehensive error handling

## Installation

### Prerequisites
- Flutter SDK (3.5.1 or higher)
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android deployment)
- Xcode (for iOS deployment)

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd child_record
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## Deployment

### Web Deployment to Netlify

#### Option 1: Manual Deployment
1. **Build the web app**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Netlify**
   - Go to [Netlify](https://app.netlify.com/)
   - Drag and drop the `build/web` folder
   - Your app will be live at the provided URL

#### Option 2: GitHub Integration
1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

2. **Connect to Netlify**
   - Go to [Netlify](https://app.netlify.com/)
   - Click "New site from Git"
   - Connect your GitHub repository
   - Set build command: `flutter build web --release`
   - Set publish directory: `build/web`
   - Deploy!

#### Option 3: Automated Deployment
This repository includes GitHub Actions for automatic deployment:
- Push to `main` branch triggers automatic deployment
- Requires `NETLIFY_AUTH_TOKEN` and `NETLIFY_SITE_ID` secrets in GitHub

### Local Testing
Run the deployment script:
```bash
chmod +x deploy.sh
./deploy.sh
```

### Platform Support
- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## Usage Guide

### **Adding a Child**
1. Navigate to the dashboard
2. Tap "Add Child" button
3. Fill in child's personal information
4. Add parent/guardian details
5. Capture child's photo
6. Save the record

### **Recording Health Data**
1. Select a child from the children list
2. Tap "Add Health Record"
3. Enter visit date and measurements
4. Record vital signs
5. Add vaccination information
6. Document symptoms and diagnosis
7. Save the health record

### **Synchronizing Data**
1. Ensure internet connectivity
2. Navigate to Sync Status screen
3. Tap "Sync Now" to upload pending records
4. Monitor sync progress and status

### **Managing Data**
- View all children in the Children List
- Search and filter children by name, parent, or village
- View detailed health records with growth charts
- Export data for backup
- Clear data when needed

## Security Features

### **Data Encryption**
- All sensitive health data is encrypted using AES-256
- Local database encryption
- Secure transmission to eSignet
- Encrypted file storage

### **Privacy Protection**
- No data transmission without explicit sync
- Local-only storage by default
- Secure authentication with eSignet
- Compliance with health data regulations

## Configuration

### **eSignet Integration**
Update the following in `lib/services/sync_service.dart`:
```dart
static const String _baseUrl = 'https://api.esignet.gov.in/child-health';
static const String _authToken = 'your_esignet_auth_token';
```

### **Database Configuration**
The SQLite database is automatically created and managed by the `DatabaseService`.

### **Encryption Settings**
Encryption keys and settings are managed in `lib/services/encryption_service.dart`.

## Dependencies

### **Core Dependencies**
- `flutter`: UI framework
- `sqflite`: Local database
- `provider`: State management
- `http`: API communication
- `crypto`: Encryption utilities
- `encrypt`: AES encryption

### **UI Dependencies**
- `flutter_slidable`: Swipeable list items
- `image_picker`: Photo capture
- `fl_chart`: Data visualization
- `qr_flutter`: QR code generation

### **Utility Dependencies**
- `connectivity_plus`: Network connectivity
- `intl`: Internationalization
- `path`: File path utilities

## Development

### **Project Structure**
```
lib/
├── models/
│   ├── child.dart
│   └── health_record.dart
├── services/
│   ├── database_service.dart
│   ├── encryption_service.dart
│   └── sync_service.dart
├── screens/
│   ├── dashboard_screen.dart
│   ├── children_list_screen.dart
│   ├── add_child_screen.dart
│   ├── child_detail_screen.dart
│   ├── add_health_record_screen.dart
│   ├── sync_status_screen.dart
│   └── settings_screen.dart
├── widgets/
├── utils/
└── main.dart
```

### **Building for Production**

**Android APK:**
```bash
flutter build apk --release
```

**iOS App:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions:
- Create an issue in the repository
- Contact the development team
- Check the documentation

## Acknowledgments

- Flutter team for the excellent framework
- eSignet for API integration
- Healthcare professionals for domain expertise
- Open source community for dependencies

---

**Note**: This application is designed for healthcare professionals and authorized personnel. Please ensure compliance with local health data regulations and privacy laws.
