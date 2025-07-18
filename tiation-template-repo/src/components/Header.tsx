
import { Volume2, Menu, ExternalLink, Grid } from "lucide-react";
import { Button } from "@/components/ui/button";
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu";

const Header = () => {
  const showcaseSites = [
    {
      name: "{{PROJECT_NAME}}",
      url: "{{SURGE_URL}}",
      current: true,
      description: "{{PROJECT_DESCRIPTION}}"
    },
    {
      name: "Developer Portfolio",
      url: "https://tiation.github.io/tiation-dev-portfolio",
      current: false,
      description: "Coming Soon"
    },
    {
      name: "Analytics Dashboard",
      url: "https://tiation.github.io/tiation-analytics-dashboard",
      current: false,
      description: "Coming Soon"
    },
    {
      name: "E-commerce Demo",
      url: "https://tiation.github.io/tiation-commerce-demo",
      current: false,
      description: "Coming Soon"
    }
  ];

  return (
    <header className="relative bg-black/95 backdrop-blur-sm border-b border-cyan-500/30 shadow-lg">
      <div className="absolute inset-0 bg-gradient-to-r from-cyan-500/10 via-transparent to-magenta-500/10"></div>
      
      {/* Showcase Navigation Bar */}
      <div className="bg-black/80 border-b border-cyan-500/20 py-2">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between text-xs">
            <div className="flex items-center space-x-2">
              <div className="w-2 h-2 bg-cyan-400 rounded-full animate-pulse"></div>
              <span className="text-cyan-400 font-mono uppercase tracking-wider">
                Tiation Showcase Portfolio
              </span>
            </div>
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="ghost" size="sm" className="text-gray-400 hover:text-cyan-400 text-xs">
                  <Grid className="h-3 w-3 mr-1" />
                  View All Sites
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent className="bg-black/95 border-cyan-500/30 backdrop-blur-sm">
                {showcaseSites.map((site) => (
                  <DropdownMenuItem key={site.name} className="text-gray-300 hover:text-cyan-400 hover:bg-cyan-500/10">
                    <a href={site.url} className="flex items-center justify-between w-full" target={site.current ? '_self' : '_blank'}>
                      <div>
                        <div className="font-medium">{site.name}</div>
                        <div className="text-xs text-gray-500">{site.description}</div>
                      </div>
                      {!site.current && <ExternalLink className="h-3 w-3 ml-2" />}
                    </a>
                  </DropdownMenuItem>
                ))}
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </div>
      </div>
      
      <div className="container mx-auto px-4 py-4 relative">
        <div className="flex items-center justify-between">
          <div className="flex items-center space-x-3">
            <div className="relative">
              <Volume2 className="h-8 w-8 text-cyan-400" />
              <div className="absolute inset-0 blur-sm">
                <Volume2 className="h-8 w-8 text-cyan-400/50" />
              </div>
            </div>
            <div>
              <h1 className="text-2xl font-bold text-white tracking-tight">
                <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
                  TIATION
                </span>{' '}
                {{PROJECT_NAME}}
              </h1>
              <p className="text-xs text-gray-400 font-mono uppercase tracking-wider">
                {{PROJECT_DESCRIPTION}}
              </p>
            </div>
          </div>
          
          <nav className="hidden md:flex items-center space-x-6">
            <a href="#episodes" className="text-gray-300 hover:text-cyan-400 transition-colors font-medium uppercase tracking-wide">
              Episodes
            </a>
            <a href="#about" className="text-gray-300 hover:text-cyan-400 transition-colors font-medium uppercase tracking-wide">
              The Hosts
            </a>
            <a href="#contact" className="text-gray-300 hover:text-cyan-400 transition-colors font-medium uppercase tracking-wide">
              Contact
            </a>
            <Button className="bg-gradient-to-r from-cyan-600 to-magenta-600 hover:from-cyan-700 hover:to-magenta-700 text-white font-bold px-6 py-2 shadow-lg shadow-cyan-500/25">
              LISTEN NOW
            </Button>
          </nav>
          
          <Button variant="ghost" size="icon" className="md:hidden text-white hover:text-cyan-400">
            <Menu className="h-6 w-6" />
          </Button>
        </div>
      </div>
    </header>
  );
};

export default Header;
