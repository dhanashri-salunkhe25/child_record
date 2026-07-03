import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'services/database_service.dart';
import 'services/encryption_service.dart';
import 'services/sync_service.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'utils/demo_data.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize services
  final authService = AuthService();
  final databaseService = DatabaseService();
  final encryptionService = EncryptionService();
  final syncService = SyncService();

  // Initialize encryption
  encryptionService.initialize();

  // Populate demo data for testing
  await DemoData.populateDemoData();

  runApp(MyApp(
    authService: authService,
    databaseService: databaseService,
    encryptionService: encryptionService,
    syncService: syncService,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final DatabaseService databaseService;
  final EncryptionService encryptionService;
  final SyncService syncService;

  const MyApp({
    super.key,
    required this.authService,
    required this.databaseService,
    required this.encryptionService,
    required this.syncService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<DatabaseService>.value(value: databaseService),
        Provider<EncryptionService>.value(value: encryptionService),
        Provider<SyncService>.value(value: syncService),
      ],
      child: MaterialApp(
        title: 'Child Health Record Booklet',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue[600],
            foregroundColor: Colors.white,
            elevation: 2,
            centerTitle: true,
          ),
          cardTheme: CardTheme(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
        ),
        home: StreamBuilder(
          stream: authService.user,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasData) {
              return const DashboardScreen();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
