import { Clock, ChevronLeft, ChevronRight } from "lucide-react";
import { useState } from "react";

const historyItems = [
  "Anmeldung – Bürgeramt Walle",
  "Führerschein Umschreibung",
  "Wohnungsgeberbestätigung",
  "Krankenversicherung",
  "Steuer-ID beantragen",
];

export function HistoryPanel() {
  const [isCollapsed, setIsCollapsed] = useState(false);

  if (isCollapsed) {
    return (
      <button
        onClick={() => setIsCollapsed(false)}
        className="fixed left-0 top-24 z-40 p-2 bg-white rounded-r-lg shadow-md hover:bg-gray-50 transition-colors hidden md:block"
        aria-label="Show history"
      >
        <ChevronRight className="w-5 h-5 text-gray-600" />
      </button>
    );
  }

  return (
    <aside className="w-[260px] p-4 md:p-6 flex-shrink-0 hidden md:block">
      <div className="bg-white rounded-xl shadow-sm p-4 md:p-6 h-full relative">
        {/* Collapse button */}
        <button
          onClick={() => setIsCollapsed(true)}
          className="absolute right-2 top-2 p-1 hover:bg-gray-100 rounded transition-colors"
          aria-label="Hide history"
        >
          <ChevronLeft className="w-4 h-4 text-gray-600" />
        </button>

        {/* Logged in indicator */}
        <div className="inline-block px-3 py-1 bg-blue-50 text-blue-700 rounded-full text-sm mb-4">
          Only visible when logged in
        </div>

        {/* Title */}
        <div className="flex items-center gap-2 mb-4">
          <Clock className="w-5 h-5 text-gray-600" />
          <h2 className="text-gray-900">History</h2>
        </div>

        {/* History items */}
        <div className="space-y-2">
          {historyItems.map((item, index) => (
            <button
              key={index}
              className="w-full text-left px-4 py-3 bg-gray-50 hover:bg-gray-100 rounded-lg transition-colors text-gray-700 break-words"
            >
              {item}
            </button>
          ))}
        </div>
      </div>
    </aside>
  );
}