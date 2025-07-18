
const HostsSection = () => {
  return (
    <section id="about" className="py-20 bg-gray-950 relative overflow-hidden">
      {/* Background gradient */}
      <div className="absolute inset-0 bg-gradient-to-br from-cyan-500/5 via-transparent to-magenta-500/5"></div>
      
      <div className="container mx-auto px-4 relative">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-black text-white mb-4 uppercase tracking-wide">
            <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
              THE ENTERPRISE TEAM
            </span>
          </h2>
          <p className="text-gray-400 text-lg max-w-2xl mx-auto">
            Professional development experts bringing enterprise-grade solutions to modern challenges
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 gap-12 max-w-6xl mx-auto">
          {/* Rohan */}
          <div className="relative group">
            <div className="bg-gradient-to-br from-gray-900 to-black border border-cyan-500/30 p-8 hover:border-cyan-500/50 transition-all duration-300 shadow-2xl shadow-cyan-500/10">
              <div className="space-y-6">
                <div className="flex items-center space-x-4">
                  <div className="w-16 h-16 bg-gradient-to-r from-cyan-600/20 to-magenta-600/20 border-2 border-cyan-500 flex items-center justify-center font-black text-xl text-cyan-400">
                    R
                  </div>
                  <div>
                    <h3 className="text-2xl font-black text-white">ROHAN</h3>
                    <p className="text-cyan-400 font-mono text-sm uppercase tracking-wider">
                      FULL-STACK ARCHITECT
                    </p>
                  </div>
                </div>
                
                <div className="space-y-4 text-gray-300">
                  <p className="leading-relaxed">
                    <span className="text-cyan-400 font-semibold">Enterprise architecture specialist.</span> Delivers robust, 
                    scalable solutions with a focus on performance and maintainability.
                  </p>
                  
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div>
                      <span className="text-gray-500 font-mono">SPECIALTY:</span>
                      <p className="text-white">System Architecture</p>
                    </div>
                    <div>
                      <span className="text-gray-500 font-mono">EXPERTISE:</span>
                      <p className="text-white">React, Node.js, AWS</p>
                    </div>
                    <div>
                      <span className="text-gray-500 font-mono">FOCUS:</span>
                      <p className="text-white">Performance</p>
                    </div>
                    <div>
                      <span className="text-gray-500 font-mono">APPROACH:</span>
                      <p className="text-white">"Build it right, build it fast"</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          {/* Tia */}
          <div className="relative group">
            <div className="bg-gradient-to-br from-gray-900 to-black border border-magenta-500/30 p-8 hover:border-magenta-500/50 transition-all duration-300 shadow-2xl shadow-magenta-500/10">
              <div className="space-y-6">
                <div className="flex items-center space-x-4">
                  <div className="w-16 h-16 bg-gradient-to-r from-magenta-600/20 to-cyan-600/20 border-2 border-magenta-500 flex items-center justify-center font-black text-xl text-magenta-400">
                    T
                  </div>
                  <div>
                    <h3 className="text-2xl font-black text-white">TIA</h3>
                    <p className="text-magenta-400 font-mono text-sm uppercase tracking-wider">
                      UI/UX STRATEGIST
                    </p>
                  </div>
                </div>
                
                <div className="space-y-4 text-gray-300">
                  <p className="leading-relaxed">
                    <span className="text-magenta-400 font-semibold">Design systems and user experience expert.</span> 
                    Creates intuitive, accessible interfaces that users love and businesses depend on.
                  </p>
                  
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    <div>
                      <span className="text-gray-500 font-mono">SPECIALTY:</span>
                      <p className="text-white">Design Systems</p>
                    </div>
                    <div>
                      <span className="text-gray-500 font-mono">EXPERTISE:</span>
                      <p className="text-white">TypeScript, Tailwind</p>
                    </div>
                    <div>
                      <span className="text-gray-500 font-mono">FOCUS:</span>
                      <p className="text-white">User Experience</p>
                    </div>
                    <div>
                      <span className="text-gray-500 font-mono">APPROACH:</span>
                      <p className="text-white">"Design with purpose"</p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        
        <div className="text-center mt-12">
          <div className="inline-block bg-gradient-to-r from-cyan-600/10 to-magenta-600/10 border border-cyan-500/30 px-6 py-3">
            <p className="text-cyan-400 font-mono text-sm uppercase tracking-wider">
              ⚡ TIATION: ENTERPRISE EXCELLENCE ⚡
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};

export default HostsSection;
