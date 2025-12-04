import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'models/category.dart';
import 'widgets/history_panel.dart';
import 'screens/dashboard_view.dart';
import 'screens/detail_view.dart';

/// Entry point that starts the Govbuddy app.
void main() {
  runApp(const GovbuddyApp());
}

/// Supported app languages.
enum AppLang { de, en }

/// Quick label helper for language chips.
extension on AppLang {
  String get label => this == AppLang.de ? 'DE' : 'EN';
}

/// Root widget that sets up themes and routing.
class GovbuddyApp extends StatefulWidget {
  const GovbuddyApp({super.key});

  @override
  State<GovbuddyApp> createState() => _GovbuddyAppState();
}

/// State that holds the chosen language and sets up the MaterialApp.
class _GovbuddyAppState extends State<GovbuddyApp> {
  AppLang currentLang = AppLang.en;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Govbuddy Bremen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          background: AppColors.background,
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      home: LandingPage(
        currentLang: currentLang,
        onLangChange: (lang) => setState(() => currentLang = lang),
      ),
    );
  }
}

/// Main page that shows the hero, search bar, and category list.
class LandingPage extends StatefulWidget {
  final AppLang currentLang;
  final ValueChanged<AppLang> onLangChange;

  const LandingPage({
    super.key,
    required this.currentLang,
    required this.onLangChange,
  });

  @override
  State<LandingPage> createState() => _LandingPageState();
}

/// State that manages language, search, and selected category.
class _LandingPageState extends State<LandingPage> {
  final TextEditingController _searchController = TextEditingController();

  late final List<Category> categories;
  late final Map<String, LocalizedDetail> details;
  
  final LocalizedText heroTitle = const LocalizedText(
    de: 'Dein freundlicher Guide durch Bremens Bürokratie',
    en: 'Your friendly guide to Bremen bureaucracy',
  );
  final LocalizedText heroSubtitle = const LocalizedText(
    de: 'Frag alles zu Anmeldung, Führerschein, Krankenversicherung und mehr - zugeschnitten auf Bremens Regeln.',
    en: 'Ask questions about Anmeldung, Führerschein, health insurance, and more - tailored to Bremen laws and offices.',
  );
  final LocalizedText searchHint = const LocalizedText(
    de: 'Frag etwas zum Leben in Bremen...',
    en: 'Ask anything about living in Bremen...',
  );

  final List<String> historyItems = const [
    'Anmeldung - Bürgeramt Walle',
    'Führerschein Umschreibung',
    'Wohnungsgeberbestätigung',
    'Krankenversicherung',
    'Steuer-ID beantragen',
  ];

  Category? selectedCategory;

  @override
  void initState() {
    super.initState();
    categories = _buildCategories();
    details = _buildDetails();
    // Start with no category selected (Dashboard view)
    selectedCategory = null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleCategorySelect(Category category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _handleBack() {
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check if screen is wide enough for history panel
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: AppColors.panel,
            boxShadow: [
              BoxShadow(
                color: Color(0x11000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const _Logo(),
              const SizedBox(width: 12),
              // Make title clickable to go home
              InkWell(
                onTap: _handleBack,
                child: const Text(
                  'Govbuddy Bremen',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ),
              const Spacer(),
              _LangSwitcher(
                current: widget.currentLang,
                onChanged: widget.onLangChange,
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.person_outline, size: 20),
                tooltip: 'Account',
              ),
            ],
          ),
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWideScreen)
            HistoryPanel(historyItems: historyItems),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: selectedCategory == null
                  ? DashboardView(
                      key: const ValueKey('dashboard'),
                      searchController: _searchController,
                      currentLang: widget.currentLang,
                      categories: categories,
                      onCategorySelect: _handleCategorySelect,
                      heroTitle: heroTitle,
                      heroSubtitle: heroSubtitle,
                      searchHint: searchHint,
                    )
                  : DetailView(
                      key: ValueKey('detail_${selectedCategory!.id}'),
                      category: selectedCategory!,
                      detail: details[selectedCategory!.id]!,
                      currentLang: widget.currentLang,
                      onBack: _handleBack,
                      searchController: _searchController,
                      onSearch: (val) {}, // TODO: Implement search logic
                    ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the list of category cards with their base info.
  List<Category> _buildCategories() => [
    Category(
      id: 'anmeldung',
      title: const LocalizedText(
        de: 'Anmeldung & Meldebescheinigung',
        en: 'Registration & Certificate',
      ),
      subtitle: const LocalizedText(
        de: 'Adresse anmelden und Meldebescheinigung erhalten',
        en: 'Register your address and get your registration certificate',
      ),
      color: AppColors.mustard,
    ),
    Category(
      id: 'fuehrerschein',
      title: const LocalizedText(
        de: 'Führerschein & Verkehr',
        en: 'Driving License & Traffic',
      ),
      subtitle: const LocalizedText(
        de: 'Führerschein umschreiben und Verkehrsregeln lernen',
        en: "Convert your driver's license and learn about traffic rules",
      ),
      color: AppColors.teal,
    ),
    Category(
      id: 'wohnen',
      title: const LocalizedText(
        de: 'Wohnen & Mietvertrag',
        en: 'Housing & Rental',
      ),
      subtitle: const LocalizedText(
        de: 'Wohnung finden, Mietvertrag verstehen, Mieterrechte',
        en: 'Find housing, understand rental contracts, and tenant rights',
      ),
      color: AppColors.salmon,
    ),
    Category(
      id: 'gesundheit',
      title: const LocalizedText(
        de: 'Krankenversicherung & Gesundheit',
        en: 'Health Insurance & Care',
      ),
      subtitle: const LocalizedText(
        de: 'Krankenversicherung abschließen und Leistungen nutzen',
        en: 'Get health insurance and access healthcare services',
      ),
      color: AppColors.steel,
    ),
    Category(
      id: 'arbeit',
      title: const LocalizedText(
        de: 'Arbeit, Steuern & Sozialversicherung',
        en: 'Work, Taxes & Social Security',
      ),
      subtitle: const LocalizedText(
        de: 'Arbeitsgenehmigung, Steuer-ID, Sozialabgaben',
        en: 'Work permits, tax registration, and social security',
      ),
      color: AppColors.crimson,
    ),
    Category(
      id: 'studium',
      title: const LocalizedText(
        de: 'Studium & Hochschule',
        en: 'Studies & University',
      ),
      subtitle: const LocalizedText(
        de: 'Einschreibung, Studierendenservices, Ressourcen',
        en: 'University enrollment, student services, and resources',
      ),
      color: AppColors.sand,
    ),
  ];

  /// Builds sample detail data per category.
  Map<String, LocalizedDetail> _buildDetails() => {
    'wohnen': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Für internationale Studierende und Bewohner:innen in Bremen ist die Anmeldung einer der wichtigsten ersten Schritte. Melde deine Adresse innerhalb von 14 Tagen beim zuständigen Bürgeramt.',
        en: "For international students and residents in Bremen, the Anmeldung (registration) is one of the most important first steps. You must register your address within 14 days of moving to Bremen at your local Bürgeramt (citizen's office).",
      ),
      requiredDocuments: const LocalizedList(
        de: [
          'Gültiger Reisepass oder Ausweis',
          'Ausgefülltes Anmeldeformular',
          'Wohnungsgeberbestätigung',
          'Mietvertrag oder Unterkunftsnachweis',
        ],
        en: [
          'Valid passport or ID card',
          'Completed registration form (Anmeldeformular)',
          'Landlord confirmation (Wohnungsgeberbestätigung)',
          'Rental contract or proof of accommodation',
        ],
      ),
      importantInfo: const LocalizedList(
        de: [
          'Die Anmeldung ist kostenfrei.',
          'Die Meldebescheinigung erhältst du am gleichen Tag.',
          'Originaldokumente mitbringen (Kopien reichen nicht).',
          'Bearbeitungszeit meist 15-30 Minuten.',
        ],
        en: [
          'The service is free of charge.',
          'You will receive a registration certificate on the same day.',
          'Bring all original documents - copies are not sufficient.',
          'Processing time is typically 15-30 minutes.',
        ],
      ),
      sources: const LocalizedList(
        de: ['bremen.de', 'service.bremen.de', 'uni-bremen.de'],
        en: ['bremen.de', 'service.bremen.de', 'uni-bremen.de'],
      ),
      relatedTopics: const LocalizedList(
        de: [
          'Bürgeramt Standorte',
          'Erforderliche Dokumente',
          'Terminbuchung',
          'Bearbeitungszeit',
          'Kosten und Gebühren',
        ],
        en: [
          'Bürgeramt locations',
          'Required documents',
          'Appointment booking',
          'Processing time',
          'Costs and fees',
        ],
      ),
    ),
    'anmeldung': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Buche frühzeitig einen Termin, um Wartezeiten zu vermeiden. Online-Termine sind empfehlenswert.',
        en: 'Start your registration early to avoid delays. Booking an appointment online is recommended.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Pass oder Ausweis', 'Ausgefülltes Anmeldeformular'],
        en: ['Passport or ID', 'Completed Anmeldeformular'],
      ),
      importantInfo: const LocalizedList(
        de: ['Anmeldung innerhalb von 14 Tagen erforderlich.'],
        en: ['Registration is required within 14 days.'],
      ),
      sources: const LocalizedList(
        de: ['service.bremen.de'],
        en: ['service.bremen.de'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Online-Termin', 'Meldebescheinigung'],
        en: ['Online booking', 'Registration certificate'],
      ),
    ),
    'fuehrerschein': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Tausche deinen ausländischen Führerschein beim Bürgeramt um, wenn du länger als 6 Monate bleibst.',
        en: 'Exchange your foreign license at the Bürgeramt if you plan to stay longer than 6 months.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Original-Führerschein', 'Biometrisches Passfoto'],
        en: ["Original driver's license", 'Biometric photo'],
      ),
      importantInfo: const LocalizedList(
        de: ['Die Bearbeitung kann mehrere Wochen dauern.'],
        en: ['Processing may take several weeks.'],
      ),
      sources: const LocalizedList(
        de: ['buergeramt.bremen.de'],
        en: ['buergeramt.bremen.de'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Fahrschulen', 'Termine'],
        en: ['Driving schools', 'Appointments'],
      ),
    ),
    'gesundheit': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Wähle zwischen gesetzlicher und privater Krankenversicherung. Studierende benötigen oft einen Nachweis vor der Einschreibung.',
        en: 'Choose between public and private health insurance. Students usually need proof of coverage before enrollment.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Immatrikulationsbescheinigung', 'Pass oder Ausweis'],
        en: ['Proof of enrollment', 'Passport or ID'],
      ),
      importantInfo: const LocalizedList(
        de: ['Versicherungsbestätigung für alle Anmeldungen bereithalten.'],
        en: ['Keep your insurance confirmation for all registrations.'],
      ),
      sources: const LocalizedList(
        de: ['krankenkasse.de'],
        en: ['krankenkasse.de'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Gesetzlich vs privat', 'EHIC'],
        en: ['Public vs private', 'EHIC'],
      ),
    ),
    'arbeit': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Melde dich beim Finanzamt an, erhalte eine Steuer-ID und stelle Sozialabgaben sicher.',
        en: 'Register with the tax office, obtain a Steuer-ID, and ensure social security contributions are set up.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Arbeitsvertrag', 'Pass oder Ausweis'],
        en: ['Employment contract', 'Passport or ID'],
      ),
      importantInfo: const LocalizedList(
        de: ['Die Steuer-ID kommt nach der Anmeldung per Post.'],
        en: ['Your Steuer-ID arrives by mail after registration.'],
      ),
      sources: const LocalizedList(
        de: ['finanzamt.bremen.de'],
        en: ['finanzamt.bremen.de'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Steuerklassen', 'Sozialversicherung'],
        en: ['Tax classes', 'Social security'],
      ),
    ),
    'studium': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Hochschulen verlangen oft einen Krankenversicherungs- und Adressnachweis, bevor das Semesterticket ausgegeben wird.',
        en: 'Universities may require proof of health insurance and address registration before issuing the semester ticket.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Zulassungsbescheid', 'Pass oder Ausweis'],
        en: ['Admission letter', 'Passport or ID'],
      ),
      importantInfo: const LocalizedList(
        de: ['Beachte Fristen für die Rückmeldung jedes Semester.'],
        en: ['Check deadlines for re-registration each semester.'],
      ),
      sources: const LocalizedList(
        de: ['uni-bremen.de'],
        en: ['uni-bremen.de'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Semesterticket', 'Studierendenservices'],
        en: ['Semester ticket', 'Student services'],
      ),
    ),
  };
}

/// Toggle chips to switch between German and English.
class _LangSwitcher extends StatelessWidget {
  final AppLang current;
  final ValueChanged<AppLang> onChanged;

  const _LangSwitcher({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppLang.values
          .map(
            (lang) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ChoiceChip(
                label: Text(lang.label),
                selected: current == lang,
                onSelected: (_) => onChanged(lang),
              ),
            ),
          )
          .toList(),
    );
  }
}

/// Small square logo holder with fallback icon.
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      width: 42,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.subtleBorder),
      ),
      clipBehavior: Clip.antiAlias,
      child: Image.asset(
        'assets/govbuddy_logo.png',
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.shield_outlined, color: AppColors.textMuted),
      ),
    );
  }
}
