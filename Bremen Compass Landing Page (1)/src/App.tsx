import { useState } from "react";
import { Header } from "./components/Header";
import { HistoryPanel } from "./components/HistoryPanel";
import { HomeContent } from "./components/HomeContent";
import { ResultsContent } from "./components/ResultsContent";

export default function App() {
  const [view, setView] = useState<"home" | "results">("home");
  const [searchQuery, setSearchQuery] = useState("");

  const handleSearch = (query: string) => {
    setSearchQuery(query);
    setView("results");
  };

  const handleSectionClick = (section: string) => {
    setSearchQuery(section);
    setView("results");
  };

  const handleGoHome = () => {
    setView("home");
    setSearchQuery("");
  };

  return (
    <div
      className="min-h-screen"
      style={{ backgroundColor: "#FAF9F7" }}
    >
      <Header onGoHome={handleGoHome} />

      <div
        className="flex"
        style={{ height: "calc(100vh - 80px)" }}
      >
        <HistoryPanel />

        <main className="flex-1 overflow-y-auto px-4 md:px-8 lg:px-12 py-6 md:py-8">
          <div className="max-w-[1040px] mx-auto">
            {view === "home" ? (
              <HomeContent
                onSearch={handleSearch}
                onSectionClick={handleSectionClick}
              />
            ) : (
              <ResultsContent
                query={searchQuery}
                onSearch={handleSearch}
                onGoHome={handleGoHome}
              />
            )}
          </div>
        </main>
      </div>
    </div>
  );
}