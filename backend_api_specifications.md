# Act Planner API Specification

Below is a comprehensive API specification for the Act Planner backend server. This document outlines all the endpoints, request/response formats, and authentication requirements needed to support the Flutter application.

## Base URL

```
https://api.actplanner.com/v1
```

## Authentication

### Authentication Endpoints

#### POST /auth/register
Creates a new user account.

**Request Body:**
```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response (201 Created):**
```json
{
  "id": "user123",
  "name": "John Doe",
  "email": "john@example.com",
  "createdAt": "2023-06-15T10:30:00Z"
}
```

#### POST /auth/login
Authenticates a user and returns a JWT token.

**Request Body:**
```json
{
  "email": "john@example.com",
  "password": "securePassword123"
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "userId": "user123"
}
```

#### POST /auth/refresh
Refreshes an expired JWT token.

**Request Body:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600
}
```

#### POST /auth/logout
Invalidates the current token.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "message": "Successfully logged out"
}
```

## Events

### Event Endpoints

#### GET /events
Returns a list of events accessible to the authenticated user.

**Request Headers:**
- Authorization: Bearer {token}

**Query Parameters:**
- page (optional): Page number for pagination (default: 1)
- limit (optional): Number of items per page (default: 20)
- search (optional): Search term for event name
- type (optional): Filter by event type (Wedding, SchoolAnnualDay, Society, etc.)
- fromDate (optional): Filter events from this date (ISO format)
- toDate (optional): Filter events until this date (ISO format)

**Response (200 OK):**
```json
{
  "events": [
    {
      "id": "event123",
      "name": "Smith Wedding",
      "description": "Wedding ceremony and reception",
      "date": "2023-08-15T00:00:00Z",
      "venue": "Grand Hotel",
      "startTime": "2023-08-15T16:00:00Z",
      "type": "Wedding",
      "createdBy": "user123",
      "createdAt": "2023-06-10T14:30:00Z",
      "updatedAt": "2023-06-12T09:15:00Z"
    },
    {
      "id": "event124",
      "name": "Annual School Day",
      "description": "School annual day celebration",
      "date": "2023-09-20T00:00:00Z",
      "venue": "School Auditorium",
      "startTime": "2023-09-20T10:00:00Z",
      "type": "SchoolAnnualDay",
      "createdBy": "user123",
      "createdAt": "2023-06-11T11:45:00Z",
      "updatedAt": "2023-06-11T11:45:00Z"
    }
  ],
  "pagination": {
    "total": 45,
    "pages": 3,
    "currentPage": 1,
    "limit": 20
  }
}
```

#### GET /events/{eventId}
Returns details of a specific event.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "id": "event123",
  "name": "Smith Wedding",
  "description": "Wedding ceremony and reception",
  "date": "2023-08-15T00:00:00Z",
  "venue": "Grand Hotel",
  "startTime": "2023-08-15T16:00:00Z",
  "type": "Wedding",
  "actIds": ["act1", "act2", "act3"],
  "contactIds": ["contact1", "contact2"],
  "createdBy": "user123",
  "createdAt": "2023-06-10T14:30:00Z",
  "updatedAt": "2023-06-12T09:15:00Z"
}
```

#### POST /events
Creates a new event.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "Johnson Anniversary",
  "description": "25th wedding anniversary celebration",
  "date": "2023-10-05T00:00:00Z",
  "venue": "Seaside Resort",
  "startTime": "2023-10-05T18:00:00Z",
  "type": "Anniversary"
}
```

**Response (201 Created):**
```json
{
  "id": "event125",
  "name": "Johnson Anniversary",
  "description": "25th wedding anniversary celebration",
  "date": "2023-10-05T00:00:00Z",
  "venue": "Seaside Resort",
  "startTime": "2023-10-05T18:00:00Z",
  "type": "Anniversary",
  "actIds": [],
  "contactIds": [],
  "createdBy": "user123",
  "createdAt": "2023-06-15T10:30:00Z",
  "updatedAt": "2023-06-15T10:30:00Z"
}
```

#### PUT /events/{eventId}
Updates an existing event.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "Johnson Anniversary",
  "description": "25th wedding anniversary celebration",
  "date": "2023-10-07T00:00:00Z",
  "venue": "Mountain Resort",
  "startTime": "2023-10-07T18:30:00Z",
  "type": "Anniversary"
}
```

**Response (200 OK):**
```json
{
  "id": "event125",
  "name": "Johnson Anniversary",
  "description": "25th wedding anniversary celebration",
  "date": "2023-10-07T00:00:00Z",
  "venue": "Mountain Resort",
  "startTime": "2023-10-07T18:30:00Z",
  "type": "Anniversary",
  "actIds": [],
  "contactIds": [],
  "createdBy": "user123",
  "createdAt": "2023-06-15T10:30:00Z",
  "updatedAt": "2023-06-15T11:45:00Z"
}
```

#### DELETE /events/{eventId}
Deletes an event.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "message": "Event successfully deleted"
}
```

## Acts

### Act Endpoints

#### GET /events/{eventId}/acts
Returns all acts for a specific event.

**Request Headers:**
- Authorization: Bearer {token}

**Query Parameters:**
- page (optional): Page number for pagination (default: 1)
- limit (optional): Number of items per page (default: 20)
- search (optional): Search term for act name
- approved (optional): Filter by approval status (true/false)

**Response (200 OK):**
```json
{
  "acts": [
    {
      "id": "act1",
      "eventId": "event123",
      "name": "Opening Speech",
      "description": "Welcome address by the best man",
      "startTime": "2023-08-15T16:00:00Z",
      "duration": 600,
      "sequenceId": 1,
      "isApproved": true,
      "participantIds": ["contact1"],
      "createdBy": "user123",
      "createdAt": "2023-06-10T14:35:00Z",
      "updatedAt": "2023-06-10T14:35:00Z"
    },
    {
      "id": "act2",
      "eventId": "event123",
      "name": "First Dance",
      "description": "Couple's first dance",
      "startTime": "2023-08-15T16:15:00Z",
      "duration": 300,
      "sequenceId": 2,
      "isApproved": true,
      "participantIds": ["contact3", "contact4"],
      "createdBy": "user123",
      "createdAt": "2023-06-10T14:40:00Z",
      "updatedAt": "2023-06-10T14:40:00Z"
    }
  ],
  "pagination": {
    "total": 8,
    "pages": 1,
    "currentPage": 1,
    "limit": 20
  }
}
```

#### GET /acts/{actId}
Returns details of a specific act.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "id": "act1",
  "eventId": "event123",
  "name": "Opening Speech",
  "description": "Welcome address by the best man",
  "startTime": "2023-08-15T16:00:00Z",
  "duration": 600,
  "sequenceId": 1,
  "isApproved": true,
  "participantIds": ["contact1"],
  "assets": [
    {
      "id": "asset1",
      "name": "Speech Notes",
      "relativePath": "/assets/documents/speech_notes.pdf",
      "type": "Document",
      "uploadedAt": "2023-06-10T14:36:00Z"
    }
  ],
  "createdBy": "user123",
  "createdAt": "2023-06-10T14:35:00Z",
  "updatedAt": "2023-06-10T14:35:00Z"
}
```

#### POST /events/{eventId}/acts
Creates a new act for an event.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "Toast",
  "description": "Toast by the father of the bride",
  "startTime": "2023-08-15T17:00:00Z",
  "duration": 300,
  "sequenceId": 3,
  "isApproved": false,
  "participantIds": ["contact5"]
}
```

**Response (201 Created):**
```json
{
  "id": "act3",
  "eventId": "event123",
  "name": "Toast",
  "description": "Toast by the father of the bride",
  "startTime": "2023-08-15T17:00:00Z",
  "duration": 300,
  "sequenceId": 3,
  "isApproved": false,
  "participantIds": ["contact5"],
  "assets": [],
  "createdBy": "user123",
  "createdAt": "2023-06-15T11:00:00Z",
  "updatedAt": "2023-06-15T11:00:00Z"
}
```

#### PUT /acts/{actId}
Updates an existing act.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "Toast",
  "description": "Toast by the father of the bride",
  "startTime": "2023-08-15T17:15:00Z",
  "duration": 360,
  "sequenceId": 3,
  "isApproved": true,
  "participantIds": ["contact5"]
}
```

**Response (200 OK):**
```json
{
  "id": "act3",
  "eventId": "event123",
  "name": "Toast",
  "description": "Toast by the father of the bride",
  "startTime": "2023-08-15T17:15:00Z",
  "duration": 360,
  "sequenceId": 3,
  "isApproved": true,
  "participantIds": ["contact5"],
  "assets": [],
  "createdBy": "user123",
  "createdAt": "2023-06-15T11:00:00Z",
  "updatedAt": "2023-06-15T11:30:00Z"
}
```

#### DELETE /acts/{actId}
Deletes an act.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "message": "Act successfully deleted"
}
```

#### PUT /events/{eventId}/acts/reorder
Reorders acts within an event.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "actOrders": [
    {"id": "act1", "sequenceId": 2},
    {"id": "act2", "sequenceId": 1},
    {"id": "act3", "sequenceId": 3}
  ]
}
```

**Response (200 OK):**
```json
{
  "message": "Acts successfully reordered"
}
```

## Contacts

### Contact Endpoints

#### GET /events/{eventId}/contacts
Returns all contacts for a specific event.

**Request Headers:**
- Authorization: Bearer {token}

**Query Parameters:**
- page (optional): Page number for pagination (default: 1)
- limit (optional): Number of items per page (default: 20)
- search (optional): Search term for contact name
- role (optional): Filter by role (Admin, Participant, Anchor, Audience)

**Response (200 OK):**
```json
{
  "contacts": [
    {
      "id": "contact1",
      "eventId": "event123",
      "userId": "user456",
      "role": "Admin",
      "additionalInfo": "Event organizer",
      "name": "Jane Smith",
      "phone": "+1234567890",
      "email": "jane@example.com",
      "createdAt": "2023-06-10T14:32:00Z",
      "updatedAt": "2023-06-10T14:32:00Z"
    },
    {
      "id": "contact2",
      "eventId": "event123",
      "userId": null,
      "role": "Participant",
      "additionalInfo": "Bride's father",
      "name": "Robert Johnson",
      "phone": "+1987654321",
      "email": "robert@example.com",
      "createdAt": "2023-06-10T14:33:00Z",
      "updatedAt": "2023-06-10T14:33:00Z"
    }
  ],
  "pagination": {
    "total": 12,
    "pages": 1,
    "currentPage": 1,
    "limit": 20
  }
}
```

#### GET /contacts/{contactId}
Returns details of a specific contact.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "id": "contact1",
  "eventId": "event123",
  "userId": "user456",
  "role": "Admin",
  "additionalInfo": "Event organizer",
  "name": "Jane Smith",
  "phone": "+1234567890",
  "email": "jane@example.com",
  "createdAt": "2023-06-10T14:32:00Z",
  "updatedAt": "2023-06-10T14:32:00Z"
}
```

#### POST /events/{eventId}/contacts
Creates a new contact for an event.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "userId": null,
  "role": "Participant",
  "additionalInfo": "Groom's sister",
  "name": "Emily Wilson",
  "phone": "+1122334455",
  "email": "emily@example.com"
}
```

**Response (201 Created):**
```json
{
  "id": "contact3",
  "eventId": "event123",
  "userId": null,
  "role": "Participant",
  "additionalInfo": "Groom's sister",
  "name": "Emily Wilson",
  "phone": "+1122334455",
  "email": "emily@example.com",
  "createdAt": "2023-06-15T12:00:00Z",
  "updatedAt": "2023-06-15T12:00:00Z"
}
```

#### PUT /contacts/{contactId}
Updates an existing contact.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "role": "Anchor",
  "additionalInfo": "Groom's sister and MC",
  "name": "Emily Wilson",
  "phone": "+1122334455",
  "email": "emily@example.com"
}
```

**Response (200 OK):**
```json
{
  "id": "contact3",
  "eventId": "event123",
  "userId": null,
  "role": "Anchor",
  "additionalInfo": "Groom's sister and MC",
  "name": "Emily Wilson",
  "phone": "+1122334455",
  "email": "emily@example.com",
  "createdAt": "2023-06-15T12:00:00Z",
  "updatedAt": "2023-06-15T12:30:00Z"
}
```

#### DELETE /contacts/{contactId}
Deletes a contact.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "message": "Contact successfully deleted"
}
```

## Assets

### Asset Endpoints

#### GET /events/{eventId}/assets
Returns all assets for a specific event.

**Request Headers:**
- Authorization: Bearer {token}

**Query Parameters:**
- page (optional): Page number for pagination (default: 1)
- limit (optional): Number of items per page (default: 20)
- type (optional): Filter by asset type (Audio, Image, Video, Document, Other)

**Response (200 OK):**
```json
{
  "assets": [
    {
      "id": "asset1",
      "name": "Speech Notes",
      "relativePath": "/assets/documents/speech_notes.pdf",
      "type": "Document",
      "uploadedAt": "2023-06-10T14:36:00Z",
      "eventId": "event123",
      "actId": "act1"
    },
    {
      "id": "asset2",
      "name": "First Dance Music",
      "relativePath": "/assets/audio/first_dance.mp3",
      "type": "Audio",
      "uploadedAt": "2023-06-10T14:41:00Z",
      "eventId": "event123",
      "actId": "act2"
    }
  ],
  "pagination": {
    "total": 15,
    "pages": 1,
    "currentPage": 1,
    "limit": 20
  }
}
```

#### GET /acts/{actId}/assets
Returns all assets for a specific act.

**Request Headers:**
- Authorization: Bearer {token}

**Query Parameters:**
- page (optional): Page number for pagination (default: 1)
- limit (optional): Number of items per page (default: 20)
- type (optional): Filter by asset type (Audio, Image, Video, Document, Other)

**Response (200 OK):**
```json
{
  "assets": [
    {
      "id": "asset1",
      "name": "Speech Notes",
      "relativePath": "/assets/documents/speech_notes.pdf",
      "type": "Document",
      "uploadedAt": "2023-06-10T14:36:00Z",
      "eventId": "event123",
      "actId": "act1"
    }
  ],
  "pagination": {
    "total": 1,
    "pages": 1,
    "currentPage": 1,
    "limit": 20
  }
}
```

#### GET /assets/{assetId}
Returns details of a specific asset.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "id": "asset1",
  "name": "Speech Notes",
  "relativePath": "/assets/documents/speech_notes.pdf",
  "type": "Document",
  "uploadedAt": "2023-06-10T14:36:00Z",
  "eventId": "event123",
  "actId": "act1",
  "url": "https://storage.actplanner.com/assets/documents/speech_notes.pdf"
}
```

#### POST /assets
Uploads a new asset.

**Request Headers:**
- Authorization: Bearer {token}
- Content-Type: multipart/form-data

**Request Form Data:**
- file: The file to upload
- name: Asset name
- type: Asset type (Audio, Image, Video, Document, Other)
- eventId (optional): Associated event ID
- actId (optional): Associated act ID

**Response (201 Created):**
```json
{
  "id": "asset3",
  "name": "Venue Layout",
  "relativePath": "/assets/images/venue_layout.jpg",
  "type": "Image",
  "uploadedAt": "2023-06-15T13:00:00Z",
  "eventId": "event123",
  "actId": null,
  "url": "https://storage.actplanner.com/assets/images/venue_layout.jpg"
}
```

#### PUT /assets/{assetId}
Updates asset metadata.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "Updated Venue Layout",
  "eventId": "event123",
  "actId": "act1"
}
```

**Response (200 OK):**
```json
{
  "id": "asset3",
  "name": "Updated Venue Layout",
  "relativePath": "/assets/images/venue_layout.jpg",
  "type": "Image",
  "uploadedAt": "2023-06-15T13:00:00Z",
  "eventId": "event123",
  "actId": "act1",
  "url": "https://storage.actplanner.com/assets/images/venue_layout.jpg"
}
```

#### DELETE /assets/{assetId}
Deletes an asset.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "message": "Asset successfully deleted"
}
```

#### POST /acts/{actId}/assets
Associates an existing asset with an act.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "assetId": "asset3"
}
```

**Response (200 OK):**
```json
{
  "message": "Asset successfully associated with act"
}
```

#### DELETE /acts/{actId}/assets/{assetId}
Removes an asset association from an act.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "message": "Asset association successfully removed"
}
```

## Users

### User Endpoints

#### GET /users/me
Returns the authenticated user's profile.

**Request Headers:**
- Authorization: Bearer {token}

**Response (200 OK):**
```json
{
  "id": "user123",
  "name": "John Doe",
  "email": "john@example.com",
  "createdAt": "2023-06-01T10:00:00Z",
  "updatedAt": "2023-06-01T10:00:00Z"
}
```

#### PUT /users/me
Updates the authenticated user's profile.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "name": "John Smith",
  "email": "john.smith@example.com"
}
```

**Response (200 OK):**
```json
{
  "id": "user123",
  "name": "John Smith",
  "email": "john.smith@example.com",
  "createdAt": "2023-06-01T10:00:00Z",
  "updatedAt": "2023-06-15T14:00:00Z"
}
```

#### PUT /users/me/password
Changes the authenticated user's password.

**Request Headers:**
- Authorization: Bearer {token}

**Request Body:**
```json
{
  "currentPassword": "securePassword123",
  "newPassword": "evenMoreSecure456"
}
```

**Response (200 OK):**
```json
{
  "message": "Password successfully updated"
}
```

## Error Responses

All endpoints should return appropriate error responses with the following format:

**400 Bad Request:**
```json
{
  "error": "Bad Request",
  "message": "Invalid request parameters",
  "details": {
    "name": "Name is required"
  }
}
```

**401 Unauthorized:**
```json
{
  "error": "Unauthorized",
  "message": "Authentication required"
}
```

**403 Forbidden:**
```json
{
  "error": "Forbidden",
  "message": "You don't have permission to access this resource"
}
```

**404 Not Found:**
```json
{
  "error": "Not Found",
  "message": "The requested resource was not found"
}
```

**409 Conflict:**
```json
{
  "error": "Conflict",
  "message": "Resource already exists"
}
```

**500 Internal Server Error:**
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred"
}
```

## Pagination

All list endpoints support pagination with the following query parameters:
- `page`: Page number (default: 1)
- `limit`: Number of items per page (default: 20)

Pagination information is included in the response:
```json
"pagination": {
  "total": 45,
  "pages": 3,
  "currentPage": 1,
  "limit": 20
}
```

## Filtering and Searching

Most list endpoints support filtering and searching with query parameters specific to the resource type.

## Rate Limiting

The API implements rate limiting to prevent abuse. Rate limit information is included in the response headers:
- `X-RateLimit-Limit`: Number of requests allowed in the time window
- `X-RateLimit-Remaining`: Number of requests remaining in the current window
- `X-RateLimit-Reset`: Time when the rate limit resets (Unix timestamp)

When rate limit is exceeded, the API returns a 429 Too Many Requests response.
