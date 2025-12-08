
import 'package:flutter/material.dart';
import '../../models/category.dart';
import '../constants.dart';

class ContentData {
  static List<Category> get categories => [
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
    Category(
      id: 'verwaltung_und_buergerservice',
      title: const LocalizedText(
        de: 'Verwaltung & Bürgerservice',
        en: 'Admin & Citizen Service',
      ),
      subtitle: const LocalizedText(
        de: 'Beglaubigungen, Führungszeugnisse, Termine',
        en: 'Certifications, records, appointments',
      ),
      color: Colors.deepPurple, 
    ),
  ];

  static Map<String, LocalizedDetail> get details => {
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
    'verwaltung_und_buergerservice': LocalizedDetail(
      intro: const LocalizedText(
        de: 'Das Bürgeramt bietet viele Dienstleistungen zentral an. Hier kannst du Beglaubigungen erhalten, Führungszeugnisse beantragen oder Fundsachen melden.',
        en: 'The Citizen Office offers many central services. Here you can get certifications, apply for criminal records, or report lost property.',
      ),
      requiredDocuments: const LocalizedList(
        de: ['Personalausweis', 'Gebühren (Bar/Karte)', 'Originaldokumente (für Beglaubigungen)'],
        en: ['ID Card', 'Fees (Cash/Card)', 'Original documents (for certifications)'],
      ),
      importantInfo: const LocalizedList(
        de: ['Termin erforderlich', 'Gebührenpflichtig'],
        en: ['Appointment required', 'Fees apply'],
      ),
      sources: const LocalizedList(
        de: ['BürgerServiceCenter Mitte', 'BürgerServiceCenter Nord', 'Ortsämter'],
        en: ['Citizen Service Center Mitte', 'Citizen Service Center North', 'Local Offices'],
      ),
      relatedTopics: const LocalizedList(
        de: ['Beglaubigung', 'Führungszeugnis', 'Fundbüro', 'Terminvereinbarung'],
        en: ['Certification', 'Criminal Record', 'Lost & Found', 'Appointments'],
      ),
    ),
  };
}
