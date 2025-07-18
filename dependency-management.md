# 🔗 Cross-Repository Dependency Management

## Overview

This document outlines the dependency management strategy for the split RiggerConnect repositories, ensuring proper integration and version control across all components.

## Repository Dependencies

### 1. **tiation-rigger-automation-server**
- **Dependencies**: 
  - `tiation-rigger-shared-libraries` (shared utilities)
- **Used by**: 
  - `tiation-rigger-connect-app` (API consumption)
  - `tiation-rigger-jobs-app` (API consumption)
  - `tiation-rigger-metrics-dashboard` (data source)

### 2. **tiation-rigger-connect-app**
- **Dependencies**: 
  - `tiation-rigger-shared-libraries` (shared utilities)
  - `tiation-rigger-automation-server` (API endpoints)
- **Used by**: None (end-user application)

### 3. **tiation-rigger-jobs-app**
- **Dependencies**: 
  - `tiation-rigger-shared-libraries` (shared utilities)
  - `tiation-rigger-automation-server` (API endpoints)
- **Used by**: None (end-user application)

### 4. **tiation-rigger-infrastructure**
- **Dependencies**: None
- **Used by**: All repositories (deployment and CI/CD)

### 5. **tiation-rigger-shared-libraries**
- **Dependencies**: None (base library)
- **Used by**: All application repositories

### 6. **tiation-rigger-metrics-dashboard**
- **Dependencies**: 
  - `tiation-rigger-shared-libraries` (shared utilities)
  - `tiation-rigger-automation-server` (data source)
- **Used by**: None (internal dashboard)

### 7. **tiation-rigger-workspace-docs**
- **Dependencies**: None
- **Used by**: All repositories (documentation reference)

## Dependency Configuration

### NPM Package Configuration

For JavaScript/TypeScript dependencies, configure each repository to use the shared libraries:

```json
{
  "dependencies": {
    "@tiation/rigger-shared": "^1.0.0"
  }
}
```

### Git Submodules Configuration

For repositories that need direct access to shared code:

```bash
# Add shared libraries as submodule
git submodule add https://github.com/tiation/tiation-rigger-shared-libraries.git shared

# Update submodules
git submodule update --init --recursive
```

### Docker Dependencies

For containerized deployments:

```dockerfile
# Dockerfile for automation server
FROM node:18-alpine

# Copy shared libraries
COPY shared/ ./shared/

# Copy application code
COPY . .

# Install dependencies
RUN npm ci --only=production

EXPOSE 3000
CMD ["npm", "start"]
```

## Version Management

### Semantic Versioning Strategy

- **Major version**: Breaking changes to APIs or shared interfaces
- **Minor version**: New features, backward compatible
- **Patch version**: Bug fixes, security updates

### Release Coordination

```yaml
# .github/workflows/release.yml
name: Coordinated Release

on:
  workflow_dispatch:
    inputs:
      version:
        description: 'Release version'
        required: true
        type: string

jobs:
  release-shared:
    runs-on: ubuntu-latest
    steps:
      - name: Release shared libraries
        uses: ./.github/actions/release-package
        with:
          version: ${{ github.event.inputs.version }}
          repository: tiation-rigger-shared-libraries

  release-automation:
    needs: release-shared
    runs-on: ubuntu-latest
    steps:
      - name: Release automation server
        uses: ./.github/actions/release-package
        with:
          version: ${{ github.event.inputs.version }}
          repository: tiation-rigger-automation-server

  release-apps:
    needs: release-automation
    runs-on: ubuntu-latest
    strategy:
      matrix:
        app: [tiation-rigger-connect-app, tiation-rigger-jobs-app]
    steps:
      - name: Release mobile apps
        uses: ./.github/actions/release-package
        with:
          version: ${{ github.event.inputs.version }}
          repository: ${{ matrix.app }}
```

## Integration Testing

### Cross-Repository Integration Tests

```yaml
# .github/workflows/integration-test.yml
name: Integration Tests

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  integration-test:
    runs-on: ubuntu-latest
    
    steps:
      - name: Checkout automation server
        uses: actions/checkout@v3
        with:
          repository: tiation/tiation-rigger-automation-server
          path: automation-server

      - name: Checkout connect app
        uses: actions/checkout@v3
        with:
          repository: tiation/tiation-rigger-connect-app
          path: connect-app

      - name: Checkout shared libraries
        uses: actions/checkout@v3
        with:
          repository: tiation/tiation-rigger-shared-libraries
          path: shared

      - name: Setup test environment
        run: |
          docker-compose -f integration-test-compose.yml up -d

      - name: Run integration tests
        run: |
          npm run test:integration:cross-repo
```

## API Versioning

### API Contract Management

```typescript
// shared/types/api-contracts.ts
export interface ApiContract {
  version: string;
  endpoints: {
    [key: string]: {
      method: string;
      path: string;
      request: any;
      response: any;
    };
  };
}

// Automation server API contract
export const AutomationServerV1: ApiContract = {
  version: "1.0.0",
  endpoints: {
    createJob: {
      method: "POST",
      path: "/api/v1/jobs",
      request: "CreateJobRequest",
      response: "CreateJobResponse"
    },
    getJobs: {
      method: "GET",
      path: "/api/v1/jobs",
      request: "GetJobsRequest",
      response: "GetJobsResponse"
    }
  }
};
```

### API Gateway Configuration

```yaml
# API Gateway routing
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rigger-api-gateway
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: api.riggerconnect.com
    http:
      paths:
      - path: /automation/v1
        pathType: Prefix
        backend:
          service:
            name: automation-server
            port:
              number: 3000
      - path: /metrics/v1
        pathType: Prefix
        backend:
          service:
            name: metrics-dashboard
            port:
              number: 3001
```

## Development Workflow

### Local Development Setup

```bash
#!/bin/bash
# setup-dev-environment.sh

echo "Setting up local development environment..."

# Clone all repositories
git clone https://github.com/tiation/tiation-rigger-shared-libraries.git
git clone https://github.com/tiation/tiation-rigger-automation-server.git
git clone https://github.com/tiation/tiation-rigger-connect-app.git
git clone https://github.com/tiation/tiation-rigger-jobs-app.git

# Link shared libraries
cd tiation-rigger-shared-libraries
npm link

# Link in automation server
cd ../tiation-rigger-automation-server
npm link @tiation/rigger-shared

# Link in connect app
cd ../tiation-rigger-connect-app
npm link @tiation/rigger-shared

# Link in jobs app
cd ../tiation-rigger-jobs-app
npm link @tiation/rigger-shared

echo "Development environment setup complete!"
```

### Automated Dependency Updates

```yaml
# .github/workflows/dependency-update.yml
name: Dependency Update

on:
  schedule:
    - cron: '0 2 * * 1' # Weekly on Monday at 2 AM

jobs:
  update-dependencies:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        repository: [
          tiation-rigger-automation-server,
          tiation-rigger-connect-app,
          tiation-rigger-jobs-app,
          tiation-rigger-metrics-dashboard
        ]
    
    steps:
      - name: Checkout repository
        uses: actions/checkout@v3
        with:
          repository: tiation/${{ matrix.repository }}
          token: ${{ secrets.GITHUB_TOKEN }}

      - name: Update dependencies
        run: |
          npm update @tiation/rigger-shared
          npm audit fix

      - name: Create pull request
        uses: peter-evans/create-pull-request@v4
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          commit-message: "chore: update dependencies"
          title: "Automated dependency update"
          body: "Automated dependency update for ${{ matrix.repository }}"
```

## Monitoring and Alerting

### Dependency Health Monitoring

```typescript
// shared/monitoring/dependency-health.ts
export class DependencyHealthMonitor {
  async checkApiHealth(endpoint: string): Promise<boolean> {
    try {
      const response = await fetch(`${endpoint}/health`);
      return response.ok;
    } catch (error) {
      console.error(`Health check failed for ${endpoint}:`, error);
      return false;
    }
  }

  async checkAllDependencies(): Promise<DependencyStatus> {
    const status = {
      automationServer: await this.checkApiHealth('https://api.riggerconnect.com'),
      metrics: await this.checkApiHealth('https://metrics.riggerconnect.com'),
      timestamp: new Date().toISOString()
    };

    if (!status.automationServer || !status.metrics) {
      await this.alertOnFailure(status);
    }

    return status;
  }

  private async alertOnFailure(status: DependencyStatus): Promise<void> {
    // Send alert to monitoring system
    console.error('Dependency health check failed:', status);
  }
}
```

## Best Practices

### 1. **Shared Library Updates**
- Always update shared libraries first
- Test all dependent repositories after updates
- Use semantic versioning strictly

### 2. **API Changes**
- Maintain backward compatibility
- Version API endpoints properly
- Document breaking changes

### 3. **CI/CD Integration**
- Run integration tests on every change
- Use dependency caching for faster builds
- Implement automated rollback on failures

### 4. **Documentation**
- Keep API documentation in sync
- Document dependency relationships
- Maintain change logs for all repositories

This dependency management strategy ensures that all repositories work together seamlessly while maintaining independent development and deployment cycles.
