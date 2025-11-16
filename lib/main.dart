import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'calcpowierzchni.dart';
import 'workcalc.dart';
import 'materialcalc.dart';
import 'history_manager.dart';
import 'volumemasscalc.dart';
import 'vattaxcalc.dart';
import 'knowledge_base.dart';
import 'room_measurement.dart';
import 'smart_renovation_planner.dart';
import 'nearby_stores_page.dart';
import 'weather_page.dart';
import 'splash_screen.dart';
import 'services/auth_service.dart';
import 'services/preferences_service.dart';
import 'services/cache_service.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/forgot_password_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    debugPrint('Failed to load .env: $e');
  }
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    SplashScreen(
      onInit: () async {
        await PreferencesService().init();
        await CacheService().init();
        await HistoryManager().init();
        await FirebaseAuth.instance.signOut();
      },
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late Locale? _locale;
  final PreferencesService _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    // Load saved preferences
    _themeMode = _prefsService.getThemeMode();
    _locale = _prefsService.getLocale();
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _prefsService.saveThemeMode(mode);
  }

  void _setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
    _prefsService.saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        title: 'Kalkulator Budowlany',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        themeMode: _themeMode,
        locale: _locale,
        supportedLocales: const [
          Locale('pl'),
          Locale('en'),
          Locale('es'),
          Locale('de'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const AuthWrapper(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/home': (context) => HomePage(
            themeMode: _themeMode,
            onThemeModeChanged: _setThemeMode,
            locale: _locale,
            onLocaleChanged: _setLocale,
          ),
        },
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late ThemeMode _themeMode;
  late Locale? _locale;
  final PreferencesService _prefsService = PreferencesService();

  @override
  void initState() {
    super.initState();
    // Load saved preferences
    _themeMode = _prefsService.getThemeMode();
    _locale = _prefsService.getLocale();
  }

  void _setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    _prefsService.saveThemeMode(mode);
  }

  void _setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
    _prefsService.saveLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        return StreamBuilder(
          stream: authService.authStateChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            
            if (snapshot.hasData) {
              final user = snapshot.data;
              
              if (user != null && !user.emailVerified) {
                authService.signOut();
                return const LoginScreen();
              }
              return HomePage(
                themeMode: _themeMode,
                onThemeModeChanged: _setThemeMode,
                locale: _locale,
                onLocaleChanged: _setLocale,
              );
            } else {
              // Użytkownik nie jest zalogowany - pokaż LoginScreen
              return const LoginScreen();
            }
          },
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  final ThemeMode themeMode;
  final void Function(ThemeMode) onThemeModeChanged;
  final Locale? locale;
  final void Function(Locale?) onLocaleChanged;
  const HomePage({super.key, this.themeMode = ThemeMode.system, required this.onThemeModeChanged, this.locale, required this.onLocaleChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> get _pages => [
    const DashboardPage(),
    const CalculatorsPage(),
    const HistoryPage(),
    SettingsPage(
      themeMode: widget.themeMode,
      onThemeModeChanged: widget.onThemeModeChanged,
      locale: widget.locale,
      onLocaleChanged: widget.onLocaleChanged,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.construction, size: 30, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    loc.appTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: Text(loc.dashboard),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calculate),
              title: Text(loc.calculators),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(loc.history),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book),
              title: Text(loc.knowledgeBase),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const KnowledgeBasePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: Text(loc.roomMeasurement),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RoomMeasurementScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.home_repair_service),
              title: Text(loc.smartRenovationPlanner),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SmartRenovationPlannerScreen()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny),
              title: const Text('Pogoda'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WeatherPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Sklepy budowlane w okolicy'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyStoresPage()));
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(loc.settings ?? 'Ustawienia'),
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(loc.logout),
              onTap: () async {
                try {
                  final authService = Provider.of<AuthService>(context, listen: false);
                  await authService.signOut();
                  Navigator.pop(context);
                } catch (e) {
                  debugPrint('Logout error: $e');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Błąd wylogowania: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard),
            label: loc.dashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.calculate),
            label: loc.calculators,
          ),
          NavigationDestination(
            icon: const Icon(Icons.history),
            label: loc.history,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings),
            label: loc.settings ?? 'Ustawienia',
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context, loc),
          const SizedBox(height: 20),
          
          Text(
            'Szybkie akcje',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.3,
            cacheExtent: 200, // Optymalizacja: cache dla płynnego scrollowania
            children: [
              _buildQuickActionCard(
                context,
                'Kalkulator powierzchni',
                Icons.calculate,
                Colors.blue,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AreaCalcPage())),
              ),
              _buildQuickActionCard(
                context,
                'Kalkulator pracy',
                Icons.work,
                Colors.orange,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WorkCalcPage())),
              ),
              _buildQuickActionCard(
                context,
                'Kalkulator materiałów',
                Icons.inventory,
                Colors.green,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialCalcPage())),
              ),
              _buildQuickActionCard(
                context,
                'Historia',
                Icons.history,
                Colors.purple,
                () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage())),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          Text(
            'Ostatnie obliczenia',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          _buildRecentCalculations(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context, AppLocalizations loc) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[500]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny, color: Colors.white, size: 28),
              const SizedBox(width: 8),
              Text(
                'Witaj z powrotem!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Gotowy na nowe projekty?',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentCalculations(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.history, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text(
              'Brak ostatnich obliczeń',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              'Rozpocznij nowy projekt!',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculatorsPage extends StatelessWidget {
  const CalculatorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return GridView.count(
      padding: const EdgeInsets.all(16),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 0.85,
      cacheExtent: 300, // Optymalizacja: cache dla płynnego scrollowania
      children: [
        _buildModernCard(
          context,
          loc.areaCalculator,
          Icons.calculate,
          Colors.blue,
          const AreaCalcPage(),
        ),
        _buildModernCard(
          context,
          loc.workCalculator,
          Icons.work,
          Colors.orange,
          const WorkCalcPage(),
        ),
        _buildModernCard(
          context,
          loc.materialCalculator,
          Icons.inventory,
          Colors.green,
          const MaterialCalcPage(),
        ),
        _buildModernCard(
          context,
          loc.volumeMassCalculator,
          Icons.straighten,
          Colors.teal,
          const VolumeMassCalcPage(),
        ),
        _buildModernCard(
          context,
          loc.vatTaxCalculator ?? 'VAT & Tax',
          Icons.attach_money,
          Colors.deepPurple,
          const VatTaxCalcPage(),
        ),
        _buildModernCard(
          context,
          loc.knowledgeBase,
          Icons.menu_book,
          Colors.pink,
          const KnowledgeBasePage(),
        ),
        _buildModernCard(
          context,
          loc.roomMeasurement,
          Icons.camera_alt,
          Colors.indigo,
          const RoomMeasurementScreen(),
        ),
        _buildModernCard(
          context,
          loc.smartRenovationPlanner,
          Icons.home_repair_service,
          Colors.cyan,
          const SmartRenovationPlannerScreen(),
        ),
      ],
    );
  }

  Widget _buildModernCard(BuildContext context, String title, IconData icon, Color color, Widget page) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.08), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, size: 40, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                width: 30,
                height: 3,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeModeChanged;
  final Locale? locale;
  final Function(Locale?) onLocaleChanged;

  const SettingsPage({
    Key? key,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.locale,
    required this.onLocaleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.appearance,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.system,
                  groupValue: themeMode,
                  onChanged: (mode) {
                    if (mode != null) onThemeModeChanged(mode);
                  },
                  title: Text(loc.themeSystem),
                  secondary: const Icon(Icons.brightness_auto),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.light,
                  groupValue: themeMode,
                  onChanged: (mode) {
                    if (mode != null) onThemeModeChanged(mode);
                  },
                  title: Text(loc.themeLight),
                  secondary: const Icon(Icons.light_mode),
                ),
                RadioListTile<ThemeMode>(
                  value: ThemeMode.dark,
                  groupValue: themeMode,
                  onChanged: (mode) {
                    if (mode != null) onThemeModeChanged(mode);
                  },
                  title: Text(loc.themeDark),
                  secondary: const Icon(Icons.dark_mode),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.language,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 16),
                RadioListTile<Locale?>(
                  value: const Locale('pl'),
                  groupValue: locale ?? Localizations.localeOf(context),
                  onChanged: (loc) => onLocaleChanged(loc),
                  title: Text(loc.polish),
                  secondary: const Icon(Icons.language),
                ),
                RadioListTile<Locale?>(
                  value: const Locale('en'),
                  groupValue: locale ?? Localizations.localeOf(context),
                  onChanged: (loc) => onLocaleChanged(loc),
                  title: Text(loc.english),
                  secondary: const Icon(Icons.language),
                ),
                RadioListTile<Locale?>(
                  value: const Locale('es'),
                  groupValue: locale ?? Localizations.localeOf(context),
                  onChanged: (loc) => onLocaleChanged(loc),
                  title: Text(loc.spanish),
                  secondary: const Icon(Icons.language),
                ),
                RadioListTile<Locale?>(
                  value: const Locale('de'),
                  groupValue: locale ?? Localizations.localeOf(context),
                  onChanged: (loc) => onLocaleChanged(loc),
                  title: Text(loc.german),
                  secondary: const Icon(Icons.language),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final areaHistory = HistoryManager().getAreaHistory();
    final workHistory = HistoryManager().getWorkHistory();
    final materialHistory = HistoryManager().getMaterialHistory();
    final volumeMassHistory = HistoryManager().getVolumeMassHistory();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historia Obliczeń'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildHistorySection(
            context,
            'Kalkulator Powierzchni',
            Icons.calculate,
            Colors.blue,
            areaHistory,
            (i) async {
              await HistoryManager().removeAreaHistoryItem(i);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildHistorySection(
            context,
            'Kalkulator Robót',
            Icons.work,
            Colors.orange,
            workHistory,
            (i) async {
              await HistoryManager().removeWorkHistoryItem(i);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildHistorySection(
            context,
            'Kalkulator Materiałów',
            Icons.inventory,
            Colors.green,
            materialHistory,
            (i) async {
              await HistoryManager().removeMaterialHistoryItem(i);
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          _buildHistorySection(
            context,
            'Kalkulator Objętości i Masy',
            Icons.straighten,
            Colors.teal,
            volumeMassHistory,
            (i) async {
              await HistoryManager().removeVolumeMassHistoryItem(i);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHistorySection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Map<String, dynamic>> history,
    void Function(int) onRemove,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (history.isEmpty)
              const Text('Brak historii obliczeń', style: TextStyle(color: Colors.grey))
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: history.length,
                separatorBuilder: (context, i) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final entry = history[i];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(_historyEntryTitle(title, entry)),
                    subtitle: Text(_historyEntrySubtitle(title, entry)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      tooltip: 'Usuń',
                      onPressed: () => onRemove(i),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  String _historyEntryTitle(String title, Map<String, dynamic> entry) {
    switch (title) {
      case 'Kalkulator Powierzchni':
        return 'Długość: ${entry['length']} m, Szerokość: ${entry['width']} m';
      case 'Kalkulator Robót':
        return 'Powierzchnia: ${entry['area']} m², Cena: ${entry['price']} zł/m²';
      case 'Kalkulator Materiałów':
        return 'Powierzchnia: ${entry['area']} m², Zużycie: ${entry['usage']} na m²';
      case 'Kalkulator Objętości i Masy':
        return 'Objętość: ${entry['volume']} m³, Masa: ${entry['mass']} kg';
      default:
        return '';
    }
  }

  String _historyEntrySubtitle(String title, Map<String, dynamic> entry) {
    switch (title) {
      case 'Kalkulator Powierzchni':
        return 'Wynik: ${entry['result'].toStringAsFixed(2)} m²';
      case 'Kalkulator Robót':
        return 'Wynik: ${entry['result'].toStringAsFixed(2)} zł';
      case 'Kalkulator Materiałów':
        return 'Wynik: ${entry['result'].toStringAsFixed(2)}';
      case 'Kalkulator Objętości i Masy':
        return 'Wynik: ${entry['result'].toStringAsFixed(2)}';
      default:
        return '';
    }
  }
}
