
import { Volume2, Github } from "lucide-react";

const Footer = () => {
  return (
    <footer className="bg-black border-t border-cyan-500/20 shadow-2xl shadow-cyan-500/10">
      <div className="absolute inset-0 bg-gradient-to-t from-cyan-500/5 via-transparent to-transparent"></div>
      <div className="container mx-auto px-4 py-12 relative">
        <div className="grid md:grid-cols-3 gap-8">
          <div className="space-y-4">
            <div className="flex items-center space-x-3">
              <Volume2 className="h-6 w-6 text-cyan-400" />
              <span className="font-bold text-white text-lg">
                <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
                  TIATION
                </span>{' '}
                TOUGH TALK
              </span>
            </div>
            <p className="text-gray-400 text-sm leading-relaxed">
              Enterprise-grade podcast platform with dark neon aesthetics.
              Professional, streamlined, and powerful.
            </p>
          </div>
          
          <div className="space-y-4">
            <h4 className="font-bold text-white uppercase tracking-wide">
              <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
                Listen On
              </span>
            </h4>
            <div className="space-y-2">
              <a href="#" className="block text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                Spotify
              </a>
              <a href="#" className="block text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                Apple Podcasts
              </a>
              <a href="#" className="block text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                Google Podcasts
              </a>
              <a href="#" className="block text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                YouTube
              </a>
            </div>
          </div>
          
          <div className="space-y-4">
            <h4 className="font-bold text-white uppercase tracking-wide">
              <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
                Connect
              </span>
            </h4>
            <div className="space-y-2">
              <a href="https://github.com/tiation/tough-talk-podcast-chaos" className="flex items-center space-x-2 text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                <Github className="h-4 w-4" />
                <span>GitHub Repository</span>
              </a>
              <a href="mailto:tiatheone@protonmail.com" className="block text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                Contact
              </a>
              <a href="https://tiation.github.io/tough-talk-podcast-chaos" className="block text-gray-400 hover:text-cyan-400 text-sm transition-colors">
                Live Demo
              </a>
            </div>
          </div>
        </div>
        
        <div className="border-t border-cyan-500/20 mt-8 pt-8">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <p className="text-gray-500 text-sm font-mono">
              © 2024 Tiation. All rights reserved. Enterprise-grade platform.
            </p>
            <p className="text-gray-600 text-xs mt-2 md:mt-0">
              Built with React, TypeScript, and Tailwind CSS.
            </p>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
