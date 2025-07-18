
import { Button } from "@/components/ui/button";
import { Play } from "lucide-react";

const Hero = () => {
  return (
    <section className="relative min-h-[70vh] bg-gradient-to-br from-black via-gray-900 to-black overflow-hidden">
      {/* Neon overlay pattern */}
      <div className="absolute inset-0 opacity-20">
        <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 via-transparent to-magenta-500/10"></div>
        <div className="absolute inset-0 bg-repeat" style={{
          backgroundImage: `radial-gradient(circle at 1px 1px, rgba(0,255,255,0.1) 1px, transparent 0)`,
          backgroundSize: '20px 20px'
        }}></div>
      </div>
      
      <div className="relative container mx-auto px-4 py-20">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div className="space-y-8">
            <div className="space-y-4">
              <div className="inline-block">
                <span className="bg-gradient-to-r from-cyan-600/20 to-magenta-600/20 text-cyan-400 px-4 py-2 text-sm font-mono uppercase tracking-wider border border-cyan-500/30 shadow-lg shadow-cyan-500/25">
                  ⚡ TIATION ENTERPRISE PLATFORM
                </span>
              </div>
              
              <h1 className="text-5xl lg:text-7xl font-black text-white leading-tight">
                <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
                  TIATION
                </span>
                <span className="block text-white">TOUGH TALK</span>
              </h1>
              
              <p className="text-xl text-gray-300 max-w-lg leading-relaxed">
                Enterprise-grade podcast platform with dark neon aesthetics. 
                <span className="text-cyan-400 font-semibold">Professional. Streamlined. Powerful.</span>
              </p>
            </div>
            
            <div className="flex flex-col sm:flex-row gap-4">
              <Button size="lg" className="bg-gradient-to-r from-cyan-600 to-magenta-600 hover:from-cyan-700 hover:to-magenta-700 text-white font-bold px-8 py-4 text-lg shadow-lg shadow-cyan-500/25 group">
                <Play className="mr-3 h-5 w-5 group-hover:scale-110 transition-transform" />
                LISTEN TO LATEST EPISODE
              </Button>
              
              <Button variant="outline" size="lg" className="border-cyan-500/50 text-cyan-400 hover:bg-cyan-500/10 font-bold px-8 py-4 text-lg">
                VIEW ALL EPISODES
              </Button>
            </div>
            
            <div className="flex items-center space-x-8 text-sm text-gray-400 font-mono">
              <div className="flex items-center space-x-2">
                <div className="w-2 h-2 bg-cyan-500 rounded-full animate-pulse shadow-lg shadow-cyan-500/50"></div>
                <span>LIVE EVERY TUESDAY</span>
              </div>
              <div>ENTERPRISE GRADE</div>
              <div>PROFESSIONAL</div>
            </div>
          </div>
          
          <div className="relative">
            <div className="relative bg-gray-900/50 border border-cyan-500/30 backdrop-blur-sm p-8 shadow-2xl shadow-cyan-500/10">
              <div className="space-y-6">
                <h3 className="text-xl font-bold text-white uppercase tracking-wide">
                  <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
                    Latest Episode
                  </span>
                </h3>
                
                <div className="space-y-4">
                  <h4 className="text-lg font-semibold text-cyan-400">
                    Ep. 47: "Enterprise Platform Architecture"
                  </h4>
                  
                  <p className="text-gray-300 text-sm leading-relaxed">
                    Deep dive into modern enterprise architecture patterns and 
                    scalable platform design with dark neon aesthetics.
                  </p>
                  
                  <div className="flex items-center justify-between pt-4 border-t border-cyan-500/20">
                    <span className="text-xs text-gray-400 font-mono">
                      RELEASED: DEC 3, 2024
                    </span>
                    
                    <Button size="sm" className="bg-transparent border border-cyan-500 text-cyan-400 hover:bg-cyan-500 hover:text-black transition-all">
                      <Play className="mr-2 h-3 w-3" />
                      PLAY
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Hero;
