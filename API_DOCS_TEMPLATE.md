# 🔌 API Documentation

<div align="center">
  
  ![API Documentation](./assets/api-banner.png)
  
  [![API Status](https://img.shields.io/badge/API-Active-00ff00?style=for-the-badge)](https://api.tiation.com/status)
  [![Version](https://img.shields.io/badge/Version-v1.0-00ffff?style=for-the-badge)](https://api.tiation.com/v1)
  [![Rate Limit](https://img.shields.io/badge/Rate%20Limit-1000%2Fhr-ff00ff?style=for-the-badge)](https://api.tiation.com/docs)
  
</div>

---

## 📋 Overview

The **[Project Name] API** provides a comprehensive set of endpoints for integrating with our enterprise-grade platform. This RESTful API follows industry best practices and offers robust authentication, rate limiting, and error handling.

### 🎯 Key Features

- 🔐 **JWT Authentication**: Secure token-based authentication
- 🚀 **High Performance**: Sub-100ms response times
- 📊 **Rate Limiting**: Configurable request limits
- 🛡️ **Security**: Enterprise-grade security measures
- 📝 **OpenAPI 3.0**: Complete specification available
- 🔄 **Webhooks**: Real-time event notifications

---

## 🚀 Quick Start

### 🔑 Authentication

```bash
# Get API token
curl -X POST https://api.tiation.com/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password"}'
```

```javascript
// JavaScript SDK
import { TiationAPI } from 'tiation-api-client';

const api = new TiationAPI({
  baseURL: 'https://api.tiation.com/v1',
  apiKey: process.env.TIATION_API_KEY
});
```

### 🌐 Base URL

```
https://api.tiation.com/v1
```

### 📋 Request Headers

```http
Authorization: Bearer YOUR_JWT_TOKEN
Content-Type: application/json
User-Agent: YourApp/1.0
```

---

## 🛠️ Core Endpoints

### 🔐 Authentication

#### POST `/auth/login`
Authenticate user and receive JWT token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "securepassword"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600,
    "user": {
      "id": "user_123",
      "email": "user@example.com",
      "role": "admin"
    }
  }
}
```

#### POST `/auth/refresh`
Refresh JWT token.

**Response:**
```json
{
  "success": true,
  "data": {
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_in": 3600
  }
}
```

---

### 📊 Data Management

#### GET `/data`
Retrieve data with optional filtering and pagination.

**Query Parameters:**
- `page` (integer): Page number (default: 1)
- `limit` (integer): Items per page (default: 20, max: 100)
- `filter` (string): Filter criteria
- `sort` (string): Sort field and direction

**Example Request:**
```bash
curl -X GET "https://api.tiation.com/v1/data?page=1&limit=50&sort=created_at:desc" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "item_123",
        "name": "Sample Item",
        "created_at": "2024-01-15T10:30:00Z",
        "updated_at": "2024-01-15T10:30:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 50,
      "total": 1000,
      "pages": 20
    }
  }
}
```

#### POST `/data`
Create new data entry.

**Request Body:**
```json
{
  "name": "New Item",
  "description": "Item description",
  "metadata": {
    "category": "example",
    "tags": ["api", "demo"]
  }
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "item_124",
    "name": "New Item",
    "description": "Item description",
    "metadata": {
      "category": "example",
      "tags": ["api", "demo"]
    },
    "created_at": "2024-01-15T10:35:00Z",
    "updated_at": "2024-01-15T10:35:00Z"
  }
}
```

#### GET `/data/{id}`
Retrieve specific data entry.

**Path Parameters:**
- `id` (string): Unique identifier

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "item_123",
    "name": "Sample Item",
    "description": "Item description",
    "metadata": {
      "category": "example",
      "tags": ["api", "demo"]
    },
    "created_at": "2024-01-15T10:30:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

#### PUT `/data/{id}`
Update existing data entry.

**Path Parameters:**
- `id` (string): Unique identifier

**Request Body:**
```json
{
  "name": "Updated Item",
  "description": "Updated description"
}
```

#### DELETE `/data/{id}`
Delete data entry.

**Path Parameters:**
- `id` (string): Unique identifier

**Response:**
```json
{
  "success": true,
  "message": "Item deleted successfully"
}
```

---

### 📈 Analytics

#### GET `/analytics/metrics`
Retrieve analytics metrics.

**Query Parameters:**
- `start_date` (string): Start date (ISO 8601)
- `end_date` (string): End date (ISO 8601)
- `metric_type` (string): Type of metric to retrieve

**Response:**
```json
{
  "success": true,
  "data": {
    "metrics": [
      {
        "date": "2024-01-15",
        "value": 1250,
        "type": "page_views"
      }
    ],
    "summary": {
      "total": 37500,
      "average": 1250,
      "growth": 12.5
    }
  }
}
```

---

## 🔔 Webhooks

### 📋 Overview
Webhooks allow real-time notifications when events occur in the system.

### 🔧 Setup
1. Configure webhook endpoint in your application
2. Register webhook URL via API or dashboard
3. Handle incoming webhook events

### 📬 Event Types

| Event | Description | Payload |
|-------|-------------|---------|
| `data.created` | New data entry created | Data object |
| `data.updated` | Data entry updated | Data object |
| `data.deleted` | Data entry deleted | `{ "id": "item_123" }` |
| `user.registered` | New user registered | User object |

### 📨 Webhook Payload

```json
{
  "event": "data.created",
  "timestamp": "2024-01-15T10:30:00Z",
  "data": {
    "id": "item_123",
    "name": "Sample Item",
    "created_at": "2024-01-15T10:30:00Z"
  }
}
```

### 🔐 Security
Webhooks are signed using HMAC-SHA256. Verify signatures using your webhook secret.

```javascript
const crypto = require('crypto');

function verifyWebhook(payload, signature, secret) {
  const hmac = crypto.createHmac('sha256', secret);
  hmac.update(payload);
  const digest = hmac.digest('hex');
  return crypto.timingSafeEqual(
    Buffer.from(signature),
    Buffer.from(digest)
  );
}
```

---

## 🚦 Response Codes

| Code | Status | Description |
|------|--------|-------------|
| `200` | OK | Request successful |
| `201` | Created | Resource created successfully |
| `400` | Bad Request | Invalid request parameters |
| `401` | Unauthorized | Authentication required |
| `403` | Forbidden | Access denied |
| `404` | Not Found | Resource not found |
| `429` | Too Many Requests | Rate limit exceeded |
| `500` | Internal Server Error | Server error |

---

## 🔄 Error Handling

### 📋 Error Response Format

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request parameters",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

### 🛠️ Error Codes

| Code | Description |
|------|-------------|
| `VALIDATION_ERROR` | Request validation failed |
| `AUTHENTICATION_ERROR` | Authentication failed |
| `AUTHORIZATION_ERROR` | Insufficient permissions |
| `RATE_LIMIT_ERROR` | Rate limit exceeded |
| `RESOURCE_NOT_FOUND` | Requested resource not found |
| `INTERNAL_ERROR` | Internal server error |

---

## 🚀 Rate Limiting

### 📊 Limits

| Tier | Requests per Hour | Burst Limit |
|------|-------------------|-------------|
| Free | 1,000 | 100 |
| Pro | 10,000 | 1,000 |
| Enterprise | 100,000 | 10,000 |

### 📋 Headers

```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1642262400
```

---

## 🛠️ SDKs & Libraries

### 📦 Official SDKs

- **JavaScript/Node.js**: `npm install tiation-api-client`
- **Python**: `pip install tiation-api-client`
- **Go**: `go get github.com/tiaastor/tiation-go-sdk`
- **Java**: Maven/Gradle dependencies available

### 🔧 Community SDKs

- **Ruby**: `gem install tiation-ruby`
- **PHP**: `composer require tiation/api-client`
- **C#**: NuGet package available

---

## 📚 Examples

### 🌟 Complete Integration Example

```javascript
const { TiationAPI } = require('tiation-api-client');

class MyApp {
  constructor() {
    this.api = new TiationAPI({
      baseURL: 'https://api.tiation.com/v1',
      apiKey: process.env.TIATION_API_KEY
    });
  }

  async createItem(data) {
    try {
      const response = await this.api.post('/data', data);
      console.log('Item created:', response.data);
      return response.data;
    } catch (error) {
      console.error('Error creating item:', error.message);
      throw error;
    }
  }

  async getItems(filters = {}) {
    try {
      const response = await this.api.get('/data', { params: filters });
      return response.data;
    } catch (error) {
      console.error('Error fetching items:', error.message);
      throw error;
    }
  }
}

// Usage
const app = new MyApp();
app.createItem({
  name: 'Test Item',
  description: 'This is a test item'
});
```

---

## 🔗 Additional Resources

- **📖 OpenAPI Spec**: [Download OpenAPI 3.0 specification](https://api.tiation.com/openapi.json)
- **🎮 Interactive Docs**: [Try API in browser](https://api.tiation.com/docs)
- **📧 Support**: [tiatheone@protonmail.com](mailto:tiatheone@protonmail.com)
- **💬 Community**: [GitHub Discussions](https://github.com/tiaastor/api-discussions)

---

<div align="center">
  
  **🔌 Ready to integrate? Get your API key today!**
  
  ![API Footer](./assets/api-footer-gradient.png)
  
  *Powered by Tiation Enterprise Platform*
  
</div>
