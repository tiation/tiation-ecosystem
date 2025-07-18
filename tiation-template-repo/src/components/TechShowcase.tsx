import { Code, Database, Cloud, Shield, Zap, Globe } from "lucide-react";
import { Button } from "@/components/ui/button";

const TechShowcase = () => {
  const technologies = [
    {
      icon: Code,
      title: "Frontend Excellence",
      description: "React 18, TypeScript, Tailwind CSS, and modern component architectures",
      gradient: "from-cyan-500 to-blue-500",
      items: ["React 18", "TypeScript", "Tailwind CSS", "Vite", "shadcn/ui"]
    },
    {
      icon: Database,
      title: "Backend Systems",
      description: "Scalable server architectures with modern databases and APIs",
      gradient: "from-green-500 to-emerald-500",
      items: ["Node.js", "PostgreSQL", "MongoDB", "Redis", "GraphQL"]
    },
    {
      icon: Cloud,
      title: "Cloud Infrastructure",
      description: "Enterprise-grade deployment and scaling solutions",
      gradient: "from-purple-500 to-pink-500",
      items: ["AWS", "Docker", "Kubernetes", "CI/CD", "Serverless"]
    },
    {
      icon: Shield,
      title: "Security & Performance",
      description: "Industry-standard security practices and optimization",
      gradient: "from-red-500 to-orange-500",
      items: ["JWT", "OAuth", "SSL/TLS", "CDN", "Monitoring"]
    },
    {
      icon: Zap,
      title: "Development Tools",
      description: "Modern development workflow and productivity tools",
      gradient: "from-yellow-500 to-amber-500",
      items: ["Git", "ESLint", "Jest", "Webpack", "Prettier"]
    },
    {
      icon: Globe,
      title: "Deployment & DevOps",
      description: "Automated deployment and infrastructure management",
      gradient: "from-indigo-500 to-purple-500",
      items: ["GitHub Actions", "Vercel", "Netlify", "PM2", "Nginx"]
    }
  ];

  return (
    <section className="py-20 bg-black relative overflow-hidden">
      {/* Background effects */}
      <div className="absolute inset-0 bg-gradient-to-br from-cyan-500/5 via-transparent to-magenta-500/5"></div>
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_center,rgba(0,255,255,0.1)_1px,transparent_1px)] bg-[length:20px_20px] opacity-20"></div>
      
      <div className="container mx-auto px-4 relative">
        <div className="text-center mb-16">
          <h2 className="text-4xl font-black text-white mb-4 uppercase tracking-wide">
            <span className="bg-gradient-to-r from-cyan-400 to-magenta-400 bg-clip-text text-transparent">
              TECHNICAL EXCELLENCE
            </span>
          </h2>
          <p className="text-gray-400 text-lg max-w-3xl mx-auto">
            Showcasing the full-stack capabilities and enterprise-grade technologies that power our solutions
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-7xl mx-auto">
          {technologies.map((tech) => {
            const Icon = tech.icon;
            return (
              <div
                key={tech.title}
                className="group relative bg-gradient-to-br from-gray-900 to-black border border-cyan-500/20 p-6 hover:border-cyan-500/50 transition-all duration-300 shadow-2xl hover:shadow-cyan-500/10"
              >
                <div className="space-y-4">
                  <div className="flex items-center space-x-3">
                    <div className={`w-12 h-12 rounded-lg bg-gradient-to-r ${tech.gradient} p-3 flex items-center justify-center`}>
                      <Icon className="h-6 w-6 text-white" />
                    </div>
                    <div>
                      <h3 className="text-xl font-bold text-white">{tech.title}</h3>
                    </div>
                  </div>
                  
                  <p className="text-gray-300 text-sm leading-relaxed">
                    {tech.description}
                  </p>
                  
                  <div className="flex flex-wrap gap-2">
                    {tech.items.map((item) => (
                      <span
                        key={item}
                        className="px-2 py-1 bg-gray-800 text-cyan-400 text-xs font-mono rounded border border-cyan-500/30"
                      >
                        {item}
                      </span>
                    ))}
                  </div>
                </div>
              </div>
            );
          })}
        </div>

        <div className="text-center mt-16">
          <div className="space-y-6">
            <div className="inline-block bg-gradient-to-r from-cyan-600/10 to-magenta-600/10 border border-cyan-500/30 px-8 py-4 rounded-lg">
              <p className="text-cyan-400 font-mono text-sm uppercase tracking-wider mb-2">
                🚀 ENTERPRISE-GRADE DEVELOPMENT
              </p>
              <p className="text-gray-300 text-sm">
                From concept to deployment, we deliver scalable solutions that grow with your business
              </p>
            </div>
            
            <div className="flex flex-col sm:flex-row gap-4 justify-center">
              <Button className="bg-gradient-to-r from-cyan-600 to-magenta-600 hover:from-cyan-700 hover:to-magenta-700 text-white font-bold px-8 py-3">
                VIEW PORTFOLIO
              </Button>
              <Button variant="outline" className="border-cyan-500/50 text-cyan-400 hover:bg-cyan-500/10">
                CONTACT US
              </Button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default TechShowcase;

