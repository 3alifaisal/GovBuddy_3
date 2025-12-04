import { motion } from 'motion/react';
import { SearchBar } from './SearchBar';
import { ExternalLink, Languages } from 'lucide-react';
import { useState } from 'react';

interface ResultsContentProps {
  query: string;
  onSearch: (query: string) => void;
  onGoHome: () => void;
}

const sources = [
  { name: 'bremen.de', url: 'https://www.bremen.de' },
  { name: 'service.bremen.de', url: 'https://service.bremen.de' },
  { name: 'uni-bremen.de', url: 'https://www.uni-bremen.de' }
];

const relatedTopics = [
  { label: 'Bürgeramt locations', color: '#D4A643' },
  { label: 'Required documents', color: '#2A9D8F' },
  { label: 'Appointment booking', color: '#E76F51' },
  { label: 'Processing time', color: '#457B9D' },
  { label: 'Costs and fees', color: '#DC3545' }
];

export function ResultsContent({ query, onSearch, onGoHome }: ResultsContentProps) {
  const [simpleLanguage, setSimpleLanguage] = useState(false);

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: 1 }}
      transition={{ duration: 0.3, ease: 'easeOut' }}
      className="pb-32 md:pb-36"
    >
      {/* Simple Language Toggle */}
      <div className="flex justify-end mb-4">
        <button
          onClick={() => setSimpleLanguage(!simpleLanguage)}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg transition-colors ${
            simpleLanguage 
              ? 'bg-blue-100 text-blue-700' 
              : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
          }`}
        >
          <Languages className="w-4 h-4" />
          <span className="hidden sm:inline">Leichte Sprache</span>
          <span className="sm:hidden">Simple</span>
        </button>
      </div>

      {/* Main Answer Card */}
      <motion.div 
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3, delay: 0.1 }}
        className="bg-white rounded-xl shadow-sm p-6 md:p-8 mb-6"
      >
        <h2 className="text-gray-900 mb-4 md:mb-6">{query}</h2>
        
        <div className="space-y-4 text-gray-700 mb-6 md:mb-8">
          {simpleLanguage ? (
            <>
              <p>
                You must register your address in Bremen. This is called "Anmeldung". 
                You need to do this within 14 days when you move to a new home.
              </p>
              
              <div className="space-y-2">
                <p className="text-gray-900">What you need to bring:</p>
                <ul className="list-disc pl-6 space-y-1">
                  <li>Your passport</li>
                  <li>A form (you can get this at the office)</li>
                  <li>A paper from your landlord</li>
                  <li>Your rental contract</li>
                </ul>
              </div>

              <p>
                You can book a time online or just go to the office. The office is called "Bürgeramt".
              </p>

              <p>
                The service is free. You get a certificate on the same day.
              </p>
            </>
          ) : (
            <>
              <p>
                For international students and residents in Bremen, the Anmeldung (registration) is one of the most important first steps. 
                You must register your address within 14 days of moving to Bremen at your local Bürgeramt (citizen's office).
              </p>
              
              <div className="space-y-2">
                <p className="text-gray-900">Required documents:</p>
                <ul className="list-disc pl-6 space-y-1">
                  <li>Valid passport or ID card</li>
                  <li>Completed registration form (Anmeldeformular)</li>
                  <li>Landlord confirmation (Wohnungsgeberbestätigung)</li>
                  <li>Rental contract or proof of accommodation</li>
                </ul>
              </div>

              <p>
                You can book an appointment online through the Bremen service portal or visit the Bürgeramt during walk-in hours. 
                The most convenient locations for students are Bürgeramt Mitte and Bürgeramt Walle.
              </p>

              <div className="space-y-2">
                <p className="text-gray-900">Important information:</p>
                <ul className="list-disc pl-6 space-y-1">
                  <li>The service is free of charge</li>
                  <li>You'll receive a Meldebescheinigung (registration certificate) on the same day</li>
                  <li>Bring all original documents - copies are not sufficient</li>
                  <li>Processing time is typically 15-30 minutes</li>
                </ul>
              </div>
            </>
          )}
        </div>

        {/* Sources */}
        <div className="pt-6 border-t border-gray-200">
          <p className="text-gray-600 mb-3">Sources in Bremen</p>
          <div className="flex flex-wrap gap-2">
            {sources.map((source, index) => (
              <a
                key={index}
                href={source.url}
                target="_blank"
                rel="noopener noreferrer"
                className="inline-flex items-center gap-2 px-3 md:px-4 py-2 bg-gray-100 hover:bg-gray-200 rounded-full text-gray-700 transition-colors text-sm md:text-base"
              >
                {source.name}
                <ExternalLink className="w-3 h-3 md:w-4 md:h-4" />
              </a>
            ))}
          </div>
        </div>
      </motion.div>

      {/* Related Topics */}
      <div>
        <p className="text-gray-600 mb-3">Related topics</p>
        <div className="flex flex-wrap gap-2 md:gap-3">
          {relatedTopics.map((topic, index) => (
            <button
              key={index}
              className="px-4 md:px-5 py-2 rounded-full text-white transition-transform hover:scale-105 text-sm md:text-base"
              style={{ backgroundColor: topic.color }}
            >
              {topic.label}
            </button>
          ))}
        </div>
      </div>

      {/* Search Bar - Fixed at bottom (chatbot style) */}
      <motion.div 
        initial={{ y: 100, opacity: 0 }}
        animate={{ y: 0, opacity: 1 }}
        transition={{ duration: 0.4, ease: 'easeOut', delay: 0.2 }}
        className="fixed bottom-0 left-0 right-0 p-4 md:p-6 bg-gradient-to-t from-[#FAF9F7] via-[#FAF9F7] to-transparent z-30 md:pl-[276px]"
      >
        <div className="max-w-[1040px] mx-auto md:pl-8 lg:pl-12">
          <SearchBar onSearch={onSearch} initialValue="" placeholder="Ask a follow-up question..." />
        </div>
      </motion.div>
    </motion.div>
  );
}