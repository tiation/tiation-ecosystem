
import { Button } from "@/components/ui/button";
import { Play, Clock } from "lucide-react";

const EpisodesSection = () => {
  const episodes = [
    {
      number: 47,
      title: "Why Everyone's Wrong About Everything",
      description: "Rohan rants about social media influencers while Tia dismantles capitalism with Swedish precision.",
      duration: "1h 23m",
      date: "Dec 3, 2024",
      status: "latest"
    },
    {
      number: 46,
      title: "Dating Apps Are Digital Cancer",
      description: "Tia explains why modern dating is broken while Rohan shares horror stories from the trenches.",
      duration: "1h 15m", 
      date: "Nov 26, 2024",
      status: "popular"
    },
    {
      number: 45,
      title: "The Participation Trophy Generation",
      description: "Both hosts agree on something for once: everyone's getting soft. Chaos when they disagree on why.",
      duration: "1h 31m",
      date: "Nov 19, 2024", 
      status: "normal"
    },
    {
      number: 44,
      title: "Why Your Life Coach Is a Fraud",
      description: "Tia methodically destroys the self-help industry while Rohan questions why people need help being human.",
      duration: "1h 18m",
      date: "Nov 12, 2024",
      status: "normal"
    }
  ];

  return (
    <section id="episodes" className="py-20 bg-black">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-black text-white mb-4 text-shadow-harsh uppercase tracking-wide">
            RECENT EPISODES
          </h2>
          <p className="text-gray-400 text-lg">
            Warning: May contain traces of truth and common sense
          </p>
        </div>
        
        <div className="space-y-6 max-w-4xl mx-auto">
          {episodes.map((episode) => (
            <div key={episode.number} className="relative group">
              <div className="bg-gradient-to-r from-gray-900 to-gray-800 border border-gray-700 p-6 industrial-texture hover:border-red-600/50 transition-all duration-300">
                <div className="flex items-start justify-between">
                  <div className="flex-1 space-y-3">
                    <div className="flex items-center space-x-4">
                      <div className="flex items-center space-x-2">
                        <span className="bg-red-600/20 text-red-400 px-3 py-1 text-xs font-mono uppercase tracking-wider border border-red-600/30">
                          EP. {episode.number}
                        </span>
                        {episode.status === "latest" && (
                          <span className="bg-green-600/20 text-green-400 px-2 py-1 text-xs font-mono uppercase tracking-wider border border-green-600/30 animate-pulse">
                            NEW
                          </span>
                        )}
                        {episode.status === "popular" && (
                          <span className="bg-orange-600/20 text-orange-400 px-2 py-1 text-xs font-mono uppercase tracking-wider border border-orange-600/30">
                            🔥 HOT
                          </span>
                        )}
                      </div>
                    </div>
                    
                    <h3 className="text-xl font-bold text-white group-hover:text-red-400 transition-colors">
                      {episode.title}
                    </h3>
                    
                    <p className="text-gray-300 leading-relaxed">
                      {episode.description}
                    </p>
                    
                    <div className="flex items-center space-x-6 text-sm text-gray-400 font-mono">
                      <div className="flex items-center space-x-2">
                        <Clock className="h-4 w-4" />
                        <span>{episode.duration}</span>
                      </div>
                      <span>{episode.date}</span>
                    </div>
                  </div>
                  
                  <div className="ml-6 flex flex-col space-y-2">
                    <Button size="sm" className="bg-red-600 hover:bg-red-700 text-white font-bold">
                      <Play className="mr-2 h-4 w-4" />
                      PLAY
                    </Button>
                    <Button variant="outline" size="sm" className="border-gray-600 text-gray-300 hover:bg-gray-800 text-xs">
                      DOWNLOAD
                    </Button>
                  </div>
                </div>
              </div>
            </div>
          ))}
        </div>
        
        <div className="text-center mt-12">
          <Button className="bg-transparent border-2 border-red-600 text-red-400 hover:bg-red-600 hover:text-white font-bold px-8 py-3 text-lg">
            VIEW ALL EPISODES
          </Button>
        </div>
      </div>
    </section>
  );
};

export default EpisodesSection;
