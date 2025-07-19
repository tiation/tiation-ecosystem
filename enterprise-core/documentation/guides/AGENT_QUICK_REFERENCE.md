# ⚡ AGENT QUICK REFERENCE GUIDE

> **One-page summary for fast agent onboarding to the Rigger project**

## 🎯 PROJECT ESSENCE
**What**: B2B SaaS platform for mining/construction industry in WA  
**Why**: Generate income for Chase White Rabbit NGO  
**Who**: Perth-based rigger/crane operator manages operations  
**Goal**: Low overhead, high income, enterprise-grade platform  

## 🏗️ COMPONENT MAP
```
Backend API ←→ RiggerConnect (Business App) ←→ Workers/Jobs
     ↓              ↓                           ↓
Infrastructure → Metrics Dashboard ←→ Shared Libraries
```

## 🎨 DESIGN PRINCIPLES
- **Theme**: Dark neon with cyan/magenta gradients
- **Users**: Field workers, mining/construction professionals  
- **Priority**: Mobile-first, rugged, enterprise-grade
- **Style**: Professional, trustworthy, functional

## 💻 TECH STACK
- **Backend**: Node.js, Express, TypeScript, MongoDB, Redis
- **Mobile**: React Native, TypeScript
- **Web**: React, TypeScript
- **Infra**: AWS, Kubernetes, Docker
- **Security**: JWT, bcrypt, rate limiting

## 🔧 QUALITY STANDARDS
- **Tests**: 80%+ coverage required
- **Code**: TypeScript strict, ESLint/Prettier
- **Docs**: Architecture diagrams, screenshots, examples
- **Security**: Regular audits, dependency scanning
- **Performance**: <200ms API response time

---

## 👨‍💻 BACKEND AGENTS
### Your Focus
- Complete API endpoints in automation-server
- Implement authentication, validation, error handling
- Integration with Stripe, AWS, notifications
- Database schema for jobs, users, payments

### Key Files
- `/tiation-rigger-automation-server/`
- Controllers: Booking, Worker, Job, Payment
- Middleware: Auth, Validation, Error

### Success Criteria
- Scalable API architecture
- Comprehensive error handling
- Secure authentication
- 80%+ test coverage

---

## 📱 MOBILE AGENTS
### Your Focus
- RiggerConnect (business app) and RiggerJobs (worker app)
- Offline capabilities, real-time notifications
- Map integration, location services
- Field-worker friendly UI/UX

### Key Files
- `/tiation-rigger-connect-app/`
- `/tiation-rigger-jobs-app/`
- React Native components

### Success Criteria
- Responsive mobile design
- Offline functionality
- Real-time features
- Dark neon theme implementation

---

## 🚀 DEVOPS AGENTS
### Your Focus
- Blue-green deployment strategy
- CI/CD pipelines (GitHub Actions)
- Monitoring and alerting
- AWS/Kubernetes infrastructure

### Key Files
- `/tiation-rigger-infrastructure/`
- CI/CD configurations
- Kubernetes manifests

### Success Criteria
- Zero-downtime deployments
- Comprehensive monitoring
- Automated testing pipelines
- Security scanning

---

## 🎨 DESIGN/UX AGENTS
### Your Focus
- Mining/construction industry aesthetics
- Dark neon theme with cyan/magenta gradients
- Mobile-first, field-worker optimized
- Enterprise-grade appearance

### Key Requirements
- Professional, trustworthy design
- Rugged use case optimization
- Accessibility considerations
- Consistent branding

### Success Criteria
- User-friendly interfaces
- Industry-appropriate design
- Mobile optimization
- Theme consistency

---

## 📚 DOCUMENTATION AGENTS
### Your Focus
- Standardized README templates
- Architecture diagrams
- API documentation (Swagger)
- User guides and technical docs

### Key Files
- All README.md files
- `/docs/` directories
- Architecture diagrams
- API documentation

### Success Criteria
- Clear setup instructions
- Comprehensive API docs
- Architecture diagrams
- Live demo links

---

## 🧠 CRITICAL REMINDERS

### Always Remember
1. **Enterprise Grade**: Production-ready, scalable code
2. **Mining/Construction Focus**: Industry-specific features
3. **NGO Mission**: Maximize income for charitable work
4. **Field Workers**: Simple, reliable, mobile-first tools
5. **Perth Operations**: Australian standards and regulations

### Never Forget
- Security is paramount (sensitive business data)
- Performance matters (field workers need fast tools)
- Documentation is required (enterprise standard)
- Testing is mandatory (80%+ coverage)
- Theme consistency (dark neon with cyan/magenta)

---

## 📋 BEFORE YOU START CHECKLIST

- [ ] Read RIGGER_PROJECT_OVERVIEW.md
- [ ] Review user rules and preferences
- [ ] Understand your component's role
- [ ] Check existing code patterns
- [ ] Verify quality requirements
- [ ] Confirm security standards

## 🚨 WHEN IN DOUBT

1. **Check existing code** for patterns
2. **Review project overview** for business context
3. **Consult user rules** for preferences
4. **Ask rather than assume**
5. **Prioritize quality over speed**

---

## 📞 QUICK CONTACTS

- **Technical Lead**: tiatheone@protonmail.com
- **Business Owner**: Perth-based rigger/crane operator
- **Parent Organization**: Chase White Rabbit NGO

---

## 🎯 SUCCESS MANTRA
> "Enterprise-grade, mining-industry focused, NGO-funded, field-worker friendly, Perth-operated"

**Remember**: Every line of code, every design decision, every deployment contributes to funding important NGO work while serving the mining and construction industry in Western Australia.
