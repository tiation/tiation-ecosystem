# 🤖 AGENT BRIEFING CHECKLIST

> **Purpose**: Ensure all AI agents have comprehensive understanding of the Rigger project before contributing

## 📋 MANDATORY READING ORDER

### 1. Primary Context Documents
- [ ] **RIGGER_PROJECT_OVERVIEW.md** - Complete project understanding
- [ ] **User Rules** - Preferences for themes, design, documentation standards
- [ ] **tiation-rigger-workspace-docs/repository-split-plan.md** - Repository structure
- [ ] **tiation-rigger-workspace-docs/deployment-strategies.md** - Technical implementation

### 2. Component-Specific Documentation
- [ ] **Backend**: `/tiation-rigger-automation-server/package.json` + README
- [ ] **Mobile Apps**: `/tiation-rigger-connect-app/package.json` + README
- [ ] **Infrastructure**: Current deployment and CI/CD strategies

## ✅ KNOWLEDGE VERIFICATION CHECKLIST

Before making any changes, verify you understand:

### Business Context
- [ ] **Target Industry**: Mining and construction in Western Australia
- [ ] **Business Model**: B2B SaaS with dual revenue streams
- [ ] **NGO Purpose**: Income-producing app to fund Chase White Rabbit NGO
- [ ] **Key User**: Perth-based rigger/crane operator managing operations
- [ ] **Success Goal**: Low overheads, high income for NGO work

### Technical Architecture
- [ ] **Backend Stack**: Node.js, Express, TypeScript, MongoDB, Redis
- [ ] **Mobile Stack**: React Native, TypeScript
- [ ] **Infrastructure**: AWS, Kubernetes, Docker
- [ ] **Deployment**: Blue-green strategy, zero downtime
- [ ] **Security**: JWT, bcrypt, rate limiting, regular audits

### Component Relationships
- [ ] **RiggerConnect**: Business-facing mobile app
- [ ] **RiggerJobs**: Worker-facing mobile app  
- [ ] **Automation Server**: Central backend API
- [ ] **Infrastructure**: DevOps and deployment automation
- [ ] **Shared Libraries**: Common utilities across components
- [ ] **Metrics Dashboard**: Business intelligence and analytics

### Design Standards
- [ ] **Theme**: Dark neon with cyan/magenta gradients
- [ ] **Target Users**: Field workers, mining/construction professionals
- [ ] **Enterprise Grade**: Professional, trustworthy, scalable appearance
- [ ] **Mobile-First**: Optimized for mobile field work

### Development Standards
- [ ] **Test Coverage**: Minimum 80%
- [ ] **TypeScript**: Strict typing required
- [ ] **Code Quality**: ESLint, Prettier enforced
- [ ] **Documentation**: Architecture diagrams, screenshots, examples
- [ ] **Repository Standards**: Enterprise-grade README with clear sections

## 🎯 ROLE-SPECIFIC KNOWLEDGE

### Backend Development Agents
- [ ] Understand existing API structure in automation-server
- [ ] Know about controllers: Booking, Worker, Job, Payment, etc.
- [ ] Familiar with middleware: Auth, Validation, Error Handling
- [ ] Understand database schema requirements
- [ ] Know integration requirements (Stripe, AWS, notifications)

### Frontend/Mobile Development Agents
- [ ] Understand React Native setup for both apps
- [ ] Know the difference between business and worker apps
- [ ] Familiar with offline capabilities requirements
- [ ] Understand real-time features (WebSocket connections)
- [ ] Know about map integration and location services

### DevOps/Infrastructure Agents
- [ ] Understand blue-green deployment requirements
- [ ] Know monitoring and alerting requirements
- [ ] Familiar with AWS/Kubernetes architecture
- [ ] Understand security and compliance requirements
- [ ] Know about CI/CD pipeline expectations

### Design/UX Agents
- [ ] Understand industry-specific design requirements
- [ ] Know about field worker usability needs
- [ ] Familiar with dark neon theme requirements
- [ ] Understand mobile-first design principles
- [ ] Know about accessibility and rugged use cases

### Documentation Agents
- [ ] Understand standardized README template requirements
- [ ] Know about architecture diagram requirements
- [ ] Familiar with centralized documentation approach
- [ ] Understand screenshot and demo requirements
- [ ] Know about API documentation standards (Swagger)

## 🚨 CRITICAL SUCCESS FACTORS

### Must Always Consider
1. **Enterprise Grade**: Everything must be production-ready, scalable
2. **Industry Focus**: Mining/construction specific features and design
3. **Low Overhead**: Automated systems to minimize operational costs
4. **NGO Mission**: Generate maximum income for charitable work
5. **User Experience**: Field workers need simple, reliable tools
6. **Security**: Handle sensitive business and worker data safely
7. **Compliance**: Meet Australian industry safety and employment standards

### Never Do
- [ ] Create toy or demo-quality code
- [ ] Ignore security considerations
- [ ] Break existing established patterns
- [ ] Skip comprehensive testing
- [ ] Forget mobile-first design
- [ ] Ignore enterprise scalability needs
- [ ] Compromise on documentation quality

## 📊 QUALITY GATES

Before submitting any work, ensure:

### Code Quality
- [ ] Follows existing patterns in the codebase
- [ ] Includes comprehensive tests (80%+ coverage)
- [ ] Passes all linting and type checking
- [ ] Includes proper error handling
- [ ] Has appropriate logging and monitoring

### Documentation Quality  
- [ ] Includes clear architecture diagrams
- [ ] Has screenshots or demos where relevant
- [ ] Provides setup and usage instructions
- [ ] Links to centralized documentation
- [ ] Follows established README template

### Security & Performance
- [ ] Implements proper authentication/authorization
- [ ] Includes input validation and sanitization  
- [ ] Considers performance implications
- [ ] Includes monitoring and alerting
- [ ] Follows security best practices

## 🔄 CONTINUOUS LEARNING

### Stay Updated On
- [ ] Changes to RIGGER_PROJECT_OVERVIEW.md
- [ ] Updates to user rules and preferences
- [ ] New components added to the ecosystem
- [ ] Changes in business requirements
- [ ] Technical architecture evolution

### Regular Reviews
- [ ] **Weekly**: Check for project updates
- [ ] **Before Major Changes**: Re-read overview and requirements
- [ ] **After Components Change**: Update knowledge of relationships
- [ ] **Before Production**: Verify all quality gates

## 📞 ESCALATION PATHS

### When You Need Clarification
1. **Technical Questions**: Reference existing code patterns first
2. **Business Questions**: Check RIGGER_PROJECT_OVERVIEW.md
3. **Design Questions**: Review user rules and preferences
4. **Architecture Questions**: Check deployment strategies document

### When You're Unsure
- **Stop and ask** rather than making assumptions
- **Reference this checklist** to ensure you have complete context
- **Review existing implementations** for patterns to follow
- **Check user rules** for specific preferences

---

## ✅ AGENT CERTIFICATION

By proceeding to work on any Rigger project component, I certify that:

- [ ] I have read and understood the complete RIGGER_PROJECT_OVERVIEW.md
- [ ] I am familiar with the user's rules and preferences
- [ ] I understand the business context and NGO mission
- [ ] I know the technical architecture and component relationships
- [ ] I will follow established development and documentation standards
- [ ] I will prioritize enterprise-grade quality and security
- [ ] I will contribute to the goal of low-overhead, high-income operation

**Agent ID**: [To be filled by agent]  
**Certification Date**: [Current date]  
**Project Version**: 2025-07-18  

---

> 🎯 **Success Mantra**: "Enterprise-grade, mining-industry focused, NGO-funded, field-worker friendly, Perth-operated"
