import { ChevronRight } from 'lucide-react';
import { motion } from 'motion/react';

interface SectionCardProps {
  title: string;
  description: string;
  color: string;
  onClick: () => void;
}

export function SectionCard({ title, description, color, onClick }: SectionCardProps) {
  return (
    <motion.button
      onClick={onClick}
      className="w-full p-4 md:p-6 rounded-xl text-left transition-transform hover:scale-[1.02] active:scale-[0.98]"
      style={{ backgroundColor: color }}
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      <div className="flex items-start justify-between gap-3 md:gap-4">
        <div className="flex-1 min-w-0">
          <h3 className="text-white mb-1 md:mb-2">
            {title}
          </h3>
          <p className="text-white/90 text-sm md:text-base">
            {description}
          </p>
        </div>
        
        <ChevronRight className="w-5 h-5 md:w-6 md:h-6 text-white flex-shrink-0 mt-0.5 md:mt-1" />
      </div>
    </motion.button>
  );
}