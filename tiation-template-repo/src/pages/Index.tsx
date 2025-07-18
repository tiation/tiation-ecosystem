
import Header from "@/components/Header";
import Hero from "@/components/Hero";
import HostsSection from "@/components/HostsSection";
import TechShowcase from "@/components/TechShowcase";
import EpisodesSection from "@/components/EpisodesSection";
import Footer from "@/components/Footer";

const Index = () => {
  return (
    <div className="min-h-screen bg-black">
      <Header />
      <Hero />
      <HostsSection />
      <TechShowcase />
      <EpisodesSection />
      <Footer />
    </div>
  );
};

export default Index;
