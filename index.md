# Act Planner App

## Project Overview
The Act Planner App is a Flutter application designed to help users plan and manage events with multiple acts or performances. It provides functionality for creating events, managing acts within those events, assigning contacts to events and acts, and handling assets like audio, images, and documents. The app uses Hive for local data storage and Provider for state management.

## Project Structure

### Models

#### Event
**Description**: Represents an event such as a wedding or school annual day.
**Attributes**:
- `id`: String - Unique identifier
- `name`: String - Event name
- `description`: String - Event description
- `date`: DateTime - Event date
- `venue`: String - Event venue
- `startTime`: DateTime - Event start time
- `actIds`: List<String> - IDs of acts in this event
- `contactIds`: List<String> - IDs of contacts associated with this event
- `type`: EventType - Type of event (Wedding, SchoolAnnualDay, Society)

#### Act
**Description**: Represents a performance or activity within an event.
**Attributes**:
- `id`: String - Unique identifier
- `eventId`: String - ID of the parent event
- `name`: String - Act name
- `description`: String - Act description
- `startTime`: DateTime - Act start time
- `duration`: Duration - Length of the act
- `sequenceId`: int - Order in the event timeline
- `isApproved`: bool - Approval status
- `participantIds`: List<String> - IDs of participants
- `assets`: List<Asset> - Assets associated with this act
- `createdBy`: String - ID of the user who created the act

#### Contact
**Description**: Represents a person associated with an event.
**Attributes**:
- `id`: String - Unique identifier
- `eventId`: String - ID of the associated event
- `userId`: String - User ID
- `role`: Role - Role in the event (Admin, Participant, Anchor, Audience)
- `additionalInfo`: String? - Additional information
- `name`: String - Contact name
- `phone`: String - Phone number
- `email`: String - Email address

#### Asset
**Description**: Represents a file resource used in the app.
**Attributes**:
- `id`: String - Unique identifier
- `name`: String - Asset name
- `relativePath`: String - Path to the asset file
- `type`: AssetType - Type of asset (Audio, Image, Video, Document, Other)
- `uploadedAt`: DateTime - Upload timestamp
- `eventId`: String? - Associated event ID
- `actId`: String? - Associated act ID

**Methods**:
- `getTypeFromExtension(String fileName)`: Determines asset type from file extension

### Providers

#### EventsProvider
**Description**: Manages event data and state.
**Methods**:
- `loadEvents()`: Loads events from storage
- `addEvent(Event)`: Adds a new event
- `updateEvent(Event)`: Updates an existing event
- `deleteEvent(String)`: Deletes an event
- `setSearchQuery(String)`: Sets search filter
- `setFilterType(EventType?)`: Sets type filter

#### ActsProvider
**Description**: Manages act data and state.
**Methods**:
- `loadActs()`: Loads acts from storage
- `addAct(Act)`: Adds a new act
- `updateAct(Act)`: Updates an existing act
- `deleteAct(String)`: Deletes an act
- `reorderAct(int, int)`: Reorders acts in the sequence
- `getAssetsForAct(String)`: Gets assets for a specific act
- `addAssetToAct(String, Asset)`: Adds an asset to an act
- `removeAssetFromAct(String, Asset)`: Removes an asset from an act
- `setCurrentEvent(String?)`: Sets the current event context

#### ContactsProvider
**Description**: Manages contact data and state.
**Methods**:
- `loadContacts()`: Loads contacts from storage
- `addContact(Contact)`: Adds a new contact
- `updateContact(Contact)`: Updates an existing contact
- `deleteContact(String)`: Deletes a contact

#### AssetsProvider
**Description**: Manages asset data and state.
**Methods**:
- `loadAssets()`: Loads assets from storage
- `addAsset(Asset)`: Adds a new asset
- `updateAsset(Asset)`: Updates an existing asset
- `deleteAsset(String)`: Deletes an asset

#### FilterProvider
**Description**: Manages filtering state across the app.
**Methods**:
- `setFilter(String)`: Sets the current filter

### Screens

#### EventListScreen
**Description**: Displays a list of events with search and filter functionality.

#### EventFormScreen
**Description**: Form for creating or editing events.

#### EventDetailScreen
**Description**: Shows detailed information about an event.

#### ActListScreen
**Description**: Displays acts for a specific event.

#### ActFormScreen
**Description**: Form for creating or editing acts.

#### ActDetailsScreen
**Description**: Shows detailed information about an act.

#### ContactListScreen
**Description**: Displays contacts for a specific event.

#### ContactFormScreen
**Description**: Form for creating or editing contacts.

#### TimelineScreen
**Description**: Displays a timeline view of acts in an event.

#### AssetListScreen
**Description**: Displays assets for a specific act or event.

### Widgets

#### ActForm
**Description**: Reusable form component for acts.

#### AssetSelectorDialog
**Description**: Dialog for selecting assets to associate with acts.

### Services

#### DummyDataService
**Description**: Provides sample data for the app.
**Methods**:
- `seedData()`: Populates the database with sample events, acts, contacts, and assets

#### AssetService
**Description**: Handles asset file operations.

### Adapters

#### DurationAdapter
**Description**: Hive adapter for storing Duration objects.
**Methods**:
- `read(BinaryReader)`: Reads Duration from Hive storage
- `write(BinaryWriter, Duration)`: Writes Duration to Hive storage

## Application Flow

1. The app initializes Hive for local storage and registers all required adapters
2. Sample data is loaded through DummyDataService
3. The main screen displays a list of events that can be filtered and searched
4. Users can create, edit, or delete events
5. For each event, users can manage acts, contacts, and view a timeline
6. Acts can have assets (audio, images, etc.) associated with them
7. The app provides a comprehensive planning tool for event organizers

## Technology Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Local Storage**: Hive
- **UI Design**: Material Design 3 