import { User, Globe } from 'lucide-react';
import { useState } from 'react';
import bremenMusiciansImage from 'figma:asset/95041284e8673a31ff8b4b30fee0c3a998e37d6f.png';

interface HeaderProps {
  onGoHome: () => void;
}

export function Header({ onGoHome }: HeaderProps) {
  const [showUserMenu, setShowUserMenu] = useState(false);

  return (
    <header className="bg-white border-b border-gray-200" style={{ height: '80px' }}>
      <div className="h-full px-4 md:px-8 flex items-center justify-between">
        {/* Left side - Logo */}
        <button 
          onClick={onGoHome}
          className="flex items-center gap-4 hover:opacity-80 transition-opacity"
          aria-label="Go to home"
        >
          <div className="w-10 h-10 md:w-12 md:h-12 flex items-center justify-center flex-shrink-0">
            <img 
              src={bremenMusiciansImage} 
              alt="Bremen Town Musicians" 
              className="w-full h-full object-contain"
            />
          </div>
          <h1 className="text-gray-900 hidden sm:block">Govbuddy Bremen</h1>
        </button>

        {/* Right side - Icons */}
        <div className="flex items-center gap-3 md:gap-6">
          {/* Language selector */}
          <div className="flex items-center gap-2">
            <Globe className="w-5 h-5 text-gray-600" />
            <span className="text-gray-700 hidden sm:inline">DE / EN</span>
          </div>

          {/* User menu */}
          <div className="relative">
            <button
              onClick={() => setShowUserMenu(!showUserMenu)}
              className="p-2 hover:bg-gray-100 rounded-full transition-colors"
              aria-label="User menu"
            >
              <User className="w-5 h-5 text-gray-600" />
            </button>
            
            {showUserMenu && (
              <div className="absolute right-0 top-full mt-2 w-40 bg-white rounded-xl shadow-lg border border-gray-100 py-2 z-50">
                <button className="w-full px-4 py-2 text-left text-gray-700 hover:bg-gray-50 transition-colors">
                  Log in
                </button>
                <button className="w-full px-4 py-2 text-left text-gray-700 hover:bg-gray-50 transition-colors">
                  Sign up
                </button>
                <button className="w-full px-4 py-2 text-left text-gray-700 hover:bg-gray-50 transition-colors">
                  Profile
                </button>
                <button className="w-full px-4 py-2 text-left text-gray-700 hover:bg-gray-50 transition-colors">
                  Log out
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    </header>
  );
}