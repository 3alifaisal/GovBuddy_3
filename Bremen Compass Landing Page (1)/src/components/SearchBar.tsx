import { Search } from 'lucide-react';
import { useState, FormEvent } from 'react';

interface SearchBarProps {
  onSearch: (query: string) => void;
  initialValue?: string;
  placeholder?: string;
}

export function SearchBar({ onSearch, initialValue = '', placeholder = 'Ask anything about living in Bremen…' }: SearchBarProps) {
  const [query, setQuery] = useState(initialValue);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    if (query.trim()) {
      onSearch(query);
      setQuery(''); // Clear input after submission
    }
  };

  return (
    <form onSubmit={handleSubmit} className="relative">
      <div className="relative flex items-center bg-white rounded-full shadow-md overflow-hidden border border-gray-200 hover:border-gray-300 transition-colors">
        <div className="pl-4 md:pl-6 pr-2 md:pr-3">
          <Search className="w-4 h-4 md:w-5 md:h-5 text-gray-400" />
        </div>
        
        <input
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder={placeholder}
          className="flex-1 py-3 md:py-4 pr-2 md:pr-4 bg-transparent outline-none text-gray-900 placeholder-gray-400 text-sm md:text-base"
        />
        
        <div className="pr-4 md:pr-6 pl-2 md:pl-3">
          <span 
            className="inline-block px-2 md:px-3 py-1 rounded-full text-white text-xs md:text-sm whitespace-nowrap"
            style={{ backgroundColor: '#457B9D' }}
          >
            AI-powered
          </span>
        </div>
      </div>
    </form>
  );
}