import { motion } from "motion/react";
import { SearchBar } from "./SearchBar";
import { SectionCard } from "./SectionCard";
import bremenMusiciansImage from "figma:asset/95041284e8673a31ff8b4b30fee0c3a998e37d6f.png";

interface HomeContentProps {
  onSearch: (query: string) => void;
  onSectionClick: (section: string) => void;
}

const sections = [
  {
    title: "Anmeldung & Meldebescheinigung",
    description:
      "Register your address and get your registration certificate",
    color: "#D4A643", // Mustard yellow
  },
  {
    title: "Führerschein & Verkehr",
    description:
      "Convert your driver's license and learn about traffic rules",
    color: "#2A9D8F", // Teal
  },
  {
    title: "Wohnen & Mietvertrag",
    description:
      "Find housing, understand rental contracts, and tenant rights",
    color: "#E76F51", // Burnt orange
  },
  {
    title: "Krankenversicherung & Gesundheit",
    description:
      "Get health insurance and access healthcare services",
    color: "#457B9D", // Muted blue
  },
  {
    title: "Arbeit, Steuern & Sozialversicherung",
    description:
      "Work permits, tax registration, and social security",
    color: "#DC3545", // Bright red
  },
  {
    title: "Studium & Hochschule",
    description:
      "University enrollment, student services, and academic resources",
    color: "#D4A643", // Mustard yellow (repeating)
  },
];

export function HomeContent({
  onSearch,
  onSectionClick,
}: HomeContentProps) {
  return (
    <motion.div
      initial={{ opacity: 1 }}
      exit={{ opacity: 0, y: -40 }}
      transition={{ duration: 0.3, ease: "easeOut" }}
    >
      {/* Hero Section */}
      <div className="text-center mb-6 md:mb-8">
        <div className="flex justify-center mb-4 md:mb-6">
          <img
            src={bremenMusiciansImage}
            alt="Bremen Town Musicians"
            className="w-40 h-40 md:w-64 md:h-64 object-contain"
          />
        </div>

        <h1 className="text-gray-900 mb-3 px-4">
          Your friendly guide to Bremen bureaucracy
        </h1>

        <p className="text-gray-600 max-w-2xl mx-auto px-4">
          Ask questions about Anmeldung, Führerschein, health
          insurance, and more – tailored to Bremen laws and
          offices.
        </p>
      </div>

      {/* Search Bar */}
      <div className="mb-6 md:mb-8">
        <SearchBar onSearch={onSearch} />
      </div>

      {/* Section Cards */}
      <div className="space-y-3 md:space-y-4">
        {sections.map((section, index) => (
          <SectionCard
            key={index}
            title={section.title}
            description={section.description}
            color={section.color}
            onClick={() => onSectionClick(section.title)}
          />
        ))}
      </div>
    </motion.div>
  );
}