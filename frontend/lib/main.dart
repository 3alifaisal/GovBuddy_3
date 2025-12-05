import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/constants.dart';
import 'models/category.dart';
import 'widgets/hero_section.dart';
import 'widgets/category_card.dart';
import 'screens/detail_view.dart';
import 'services/api_service.dart';

enum AppLang { de, en }

void main() {
  runApp(const GovBuddyApp());
}

class GovBuddyApp extends StatelessWidget {
  const GovBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GovBuddy Bremen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
        textTheme: GoogleFonts.interTextTheme(),
      ),
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  AppLang _currentLang = AppLang.de;
  Category? _selectedCategory;
  final TextEditingController _searchController = TextEditingController();
  final ApiService _apiService = ApiService();
  
  // Store the initial query and response for general search
  String? _initialQuery;
  String? _initialResponse;
  bool _isSearching = false;

  // General Category for Dashboard Search
  final Category _generalCategory = const Category(
    id: 'general',
    title: LocalizedText(de: 'Allgemein', en: 'General'),
    subtitle: LocalizedText(de: '', en: ''),
    color: AppColors.textMuted,
  );
  
  final LocalizedDetail _generalDetail = const LocalizedDetail(
    intro: LocalizedText(de: '', en: ''),
    requiredDocuments: LocalizedList(de: [], en: []),
    importantInfo: LocalizedList(de: [], en: []),
    sources: LocalizedList(de: [], en: []),
    relatedTopics: LocalizedList(de: [], en: []),
  );

  void _toggleLang() {
    setState(() {
      _currentLang = _currentLang == AppLang.de ? AppLang.en : AppLang.de;
    });
  }

  void _handleCategorySelect(Category category) {
    setState(() {
      _selectedCategory = category;
      _initialQuery = null;
      _initialResponse = null;
    });
  }

  void _handleBack() {
    setState(() {
      _selectedCategory = null;
      _initialQuery = null;
      _initialResponse = null;
      _isSearching = false;
    });
  }
  
  Future<void> _handleDashboardSearch(String query) async {
    if (query.trim().isEmpty) return;
    
    setState(() {
      _isSearching = true;
    });

    try {
      // Create a temporary history with just this message
      final history = [ChatMessage(role: 'user', content: query)];
      
      // Fetch the response BEFORE navigating
      final response = await _apiService.sendChatRequest(
        history,
        _generalCategory.id,
      );

      if (mounted) {
        setState(() {
          _initialQuery = query;
          _initialResponse = response;
          _selectedCategory = _generalCategory;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        // Handle error gracefully - maybe navigate anyway and let DetailView handle it?
        // Or just show error state. For now, let's navigate with error message.
        setState(() {
          _initialQuery = query;
          _initialResponse = _currentLang == AppLang.de
              ? 'Entschuldigung, es gab einen Fehler. Bitte versuche es später noch einmal.'
              : 'Sorry, there was an error. Please try again later.';
          _selectedCategory = _generalCategory;
          _isSearching = false;
        });
      }
    }
  }

  List<Category> _buildCategories() => [
    Category(
      id: 'anmeldung_und_meldebescheinigung',
      title: const LocalizedText(
        de: 'Anmeldung & Meldebescheinigung',
        en: 'Registration & Certificate',
      ),
      subtitle: const LocalizedText(
        de: 'Wohnsitz anmelden, ummelden, abmelden',
        en: 'Register residence, change address, deregister',
      ),
      color: AppColors.mustard,
    ),
    Category(
      id: 'fuehrerschein_und_verkehr',
      title: const LocalizedText(
        de: 'Führerschein & Verkehr',
        en: 'Driving License & Traffic',
      ),
      subtitle: const LocalizedText(
        de: 'Führerschein umschreiben, Kfz-Zulassung',
        en: 'Exchange license, vehicle registration',
      ),
      color: AppColors.teal,
    ),
    Category(
      id: 'wohnen_und_mietvertrag',
      title: const LocalizedText(
        de: 'Wohnen & Mietvertrag',
        en: 'Housing & Rental',
      ),
      subtitle: const LocalizedText(
        de: 'Wohnberechtigungsschein, Mietrecht',
        en: 'Housing permit, tenancy law',
      ),
      color: AppColors.salmon,
    ),
    Category(
      id: 'krankenversicherung_und_gesundheit',
      title: const LocalizedText(
        de: 'Krankenversicherung & Gesundheit',
        en: 'Health Insurance & Care',
      ),
      subtitle: const LocalizedText(
        de: 'Gesetzlich vs. Privat, Ärzte finden',
        en: 'Public vs. Private, finding doctors',
      ),
      color: AppColors.steel,
    ),
    Category(
      id: 'arbeit_steuern_und_sozialversicherung',
      title: const LocalizedText(
        de: 'Arbeit, Steuern & Sozialversicherung',
        en: 'Work, Taxes & Social Security',
      ),
      subtitle: const LocalizedText(
        de: 'Steuer-ID, Sozialversicherungsausweis',
        en: 'Tax ID, social security card',
      ),
      color: AppColors.crimson,
    ),
    Category(
      id: 'studium_und_hochschule',
      title: const LocalizedText(
        de: 'Studium & Hochschule',
        en: 'Studies & University',
      ),
      subtitle: const LocalizedText(
        de: 'Immatrikulation, Semesterbeitrag',
        en: 'Enrollment, semester fee',
      ),
      color: AppColors.indigo,
    ),
  ];

  Map<String, LocalizedDetail> _buildDetails() => {
    'wohnen_und_mietvertrag': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Für internationale Studierende und Bewohner:innen in Bremen ist die Anmeldung einer der wichtigsten ersten Schritte. Melde deine Adresse innerhalb von 14 Tagen beim zuständigen Bürgeramt.',
        en: "For international students and residents in Bremen, the Anmeldung (registration) is one of the most important first steps. You must register your address within 14 days of moving to Bremen at your local Bürgeramt (citizen's office).",
      ),
      requiredDocuments: const LocalizedList(
        de: [
          'Personalausweis oder Reisepass',
          'Wohnungsgeberbestätigung (vom Vermieter ausgefüllt)',
          'Ggf. Visum oder Aufenthaltstitel',
        ],
        en: [
          'ID card or Passport',
          'Landlord confirmation (Wohnungsgeberbestätigung)',
          'Visa or Residence Permit (if applicable)',
        ],
      ),
      importantInfo: const LocalizedList(
        de: [
          'Die Anmeldung ist kostenlos.',
          'Du erhältst sofort eine Meldebescheinigung.',
          'Termine müssen oft im Voraus gebucht werden.',
        ],
        en: [
          'Registration is free of charge.',
          'You receive a registration certificate immediately.',
          'Appointments often need to be booked in advance.',
        ],
      ),
      sources: const LocalizedList(
        de: ['BürgerServiceCenter-Mitte', 'BürgerServiceCenter-Nord', 'Bürgeramt'],
        en: ['Citizen Service Center Mitte', 'Citizen Service Center North', 'Citizen Office'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Rundfunkbeitrag', 'Bankkonto eröffnen', 'Steuer-ID'],
        en: ['Broadcasting Fee', 'Opening Bank Account', 'Tax ID'],
      ),
    ),
    'anmeldung_und_meldebescheinigung': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Buche frühzeitig einen Termin, um Wartezeiten zu vermeiden. Online-Termine sind empfehlenswert.',
        en: 'Start your registration early to avoid delays. Booking an appointment online is recommended.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Reisepass', 'Mietvertrag'],
        en: ['Passport', 'Rental Contract'],
      ),
      importantInfo: const LocalizedList(
        de: ['Anmeldefrist: 2 Wochen', 'Persönliches Erscheinen'],
        en: ['Deadline: 2 weeks', 'Personal appearance required'],
      ),
      sources: const LocalizedList(
        de: ['Service Bremen'],
        en: ['Service Bremen'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Online-Terminvereinbarung', 'Meldebescheinigung'],
        en: ['Online booking', 'Registration certificate'],
      ),
    ),
    'fuehrerschein_und_verkehr': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Tausche deinen ausländischen Führerschein beim Bürgeramt um, wenn du länger als 6 Monate bleibst.',
        en: 'Exchange your foreign license at the Bürgeramt if you plan to stay longer than 6 months.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Führerschein', 'Passfoto', 'Sehtest'],
        en: ['Driver License', 'Passport Photo', 'Eye Test'],
      ),
      importantInfo: const LocalizedList(
        de: ['Gültigkeit prüfen', 'Kosten ca. 35€'],
        en: ['Check validity', 'Cost approx. 35€'],
      ),
      sources: const LocalizedList(
        de: ['Führerscheinstelle'],
        en: ['Driver Licensing Office'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Fahrschulen', 'Terminvergabe'],
        en: ['Driving schools', 'Appointments'],
      ),
    ),
    'krankenversicherung_und_gesundheit': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Wähle zwischen gesetzlicher und privater Krankenversicherung. Studierende benötigen oft einen Nachweis vor der Einschreibung.',
        en: 'Choose between public and private health insurance. Students usually need proof of coverage before enrollment.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Pass', 'Zulassungsbescheid'],
        en: ['Passport', 'Admission Letter'],
      ),
      importantInfo: const LocalizedList(
        de: ['Versicherungspflicht', 'Beitragshöhe'],
        en: ['Mandatory insurance', 'Contribution rates'],
      ),
      sources: const LocalizedList(
        de: ['AOK', 'TK', 'Barmer'],
        en: ['AOK', 'TK', 'Barmer'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Gesetzlich vs Privat', 'EHIC'],
        en: ['Public vs private', 'EHIC'],
      ),
    ),
    'arbeit_steuern_und_sozialversicherung': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Melde dich beim Finanzamt an, erhalte eine Steuer-ID und stelle Sozialabgaben sicher.',
        en: 'Register with the tax office, obtain a Steuer-ID, and ensure social security contributions are set up.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Meldebescheinigung', 'Pass'],
        en: ['Registration Cert', 'Passport'],
      ),
      importantInfo: const LocalizedList(
        de: ['Steuerklasse wählen', 'Rentenversicherung'],
        en: ['Choose tax class', 'Pension insurance'],
      ),
      sources: const LocalizedList(
        de: ['Finanzamt Bremen'],
        en: ['Tax Office Bremen'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Steuerklassen', 'Sozialversicherung'],
        en: ['Tax classes', 'Social security'],
      ),
    ),
    'studium_und_hochschule': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Hochschulen verlangen oft einen Krankenversicherungs- und Adressnachweis, bevor das Semesterticket ausgegeben wird.',
        en: 'Universities may require proof of health insurance and address registration before issuing the semester ticket.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Zulassungsbescheid', 'Krankenkassennachweis'],
        en: ['Admission Letter', 'Health Insurance Proof'],
      ),
      importantInfo: const LocalizedList(
        de: ['Semesterbeitrag', 'Rückmeldung'],
        en: ['Semester fee', 'Re-registration'],
      ),
      sources: const LocalizedList(
        de: ['Sekretariat Uni Bremen'],
        en: ['Secretariat Uni Bremen'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Semesterticket', 'Mensa'],
        en: ['Semester ticket', 'Canteen'],
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final categories = _buildCategories();
    final details = _buildDetails();
    details['general'] = _generalDetail;

    final heroTitle = const LocalizedText(
      de: 'Willkommen in Bremen',
      en: 'Welcome to Bremen',
    );
    final heroSubtitle = const LocalizedText(
      de: 'Dein KI-Begleiter für alle Behördengänge & Fragen.',
      en: 'Your AI companion for all administrative tasks & questions.',
    );
    final searchHint = const LocalizedText(
      de: 'Wonach suchst du heute?',
      en: 'What are you looking for today?',
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: AppColors.background,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _toggleLang,
                    child: Text(
                      _currentLang == AppLang.de ? 'EN' : 'DE',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 60),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedCategory == null
                  ? SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          HeroSection(
                            controller: _searchController,
                            currentLang: _currentLang,
                            heroTitle: heroTitle,
                            heroSubtitle: heroSubtitle,
                            searchHint: searchHint,
                            onSearch: _handleDashboardSearch,
                            isSearching: _isSearching,
                          ),
                          const SizedBox(height: 60),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Wrap(
                              spacing: 16,
                              runSpacing: 16,
                              alignment: WrapAlignment.center,
                              children: categories.map((cat) {
                                return CategoryCard(
                                  category: cat,
                                  currentLang: _currentLang,
                                  onTap: () => _handleCategorySelect(cat),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    )
                  : DetailView(
                      key: ValueKey('detail_${_selectedCategory!.id}'),
                      category: _selectedCategory!,
                      detail: details[_selectedCategory!.id]!,
                      currentLang: _currentLang,
                      onBack: _handleBack,
                      searchController: _searchController,
                      initialQuery: _initialQuery,
                      initialResponse: _initialResponse,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
