# Agentforce Hackathon Team CodePanda

An AI-powered automotive dealership platform featuring an intelligent Agentforce Service Agent that streamlines customer interactions, test drive bookings, and dealership management.

## Project Overview

This Salesforce-based solution leverages **Agentforce** to deliver an intelligent, conversational experience for automotive customers. The platform enables customers to easily discover vehicles, locate nearby dealerships, check appointment availability, and book test drives through a natural language interface.

## Key Features & Functionality

### 🤖 Agentforce Service Agent
- **Intelligent Conversational Interface**: Natural language processing for customer queries
- **Context-Aware Responses**: Understands customer intent and provides relevant information
- **Seamless Integration**: Connects to flows and actions for real-time data retrieval
- **Multi-turn Conversations**: Maintains context across multiple interactions

### 🚗 Test Drive Booking System
- **Smart Appointment Scheduling**: Real-time availability checking across dealerships
- **Dealership Assignment**: Automatically assigns customers to the best dealer based on location and capacity
- **Confirmation Management**: Sends booking confirmations to customers
- **Appointment Slot Management**: Manages time slots with dealership capacity constraints
- **Flexible Scheduling**: Supports preferred date/time selection with availability verification

### 📍 Dealership Locator
- **Zip Code Matching**: Find dealers in customer's area instantly
- **Nearest Dealership Search**: Locate the closest dealership to customer location
- **Dealer Information**: Access dealership details including name, address, and contact info
- **Geo-based Routing**: Optimize customer-to-dealership assignments

### 🚙 Vehicle Inventory Management
- **Model Catalog**: Browse available vehicle models and specifications
- **Inventory Tracking**: Real-time vehicle availability and details
- **Model Search**: Filter and find specific vehicles by features and preferences

### 📋 Lead Management
- **Automated Lead Creation**: Generate leads from customer inquiries and bookings
- **Lead Qualification**: Track lead status and conversion metrics
- **Zip Code Tracking**: Store customer location data for dealership assignment
- **Discovery Assessment**: Evaluate customer needs and interests

### 📞 Omnichannel Routing
- **Work Queue Management**: Efficiently route customer requests to available staff
- **Multi-Channel Support**: Routes from web, email, and other channels
- **Assignment Rules**: Automatic distribution based on resource availability
- **Case Management**: Handle customer inquiries and support requests

### 🔄 Workflow Automation
- **Get Best Dealer Flow**: Intelligent dealer selection algorithm
- **Lead Assignment**: Automatic routing to appropriate teams
- **Conversion Rate Tracking**: Monitor and update dealer performance metrics
- **Booking Confirmation**: Sends automated confirmations and reminders

## Technical Stack

- **Platform**: Salesforce DX (API v66.0)
- **Backend**: Apex (30+ custom classes)
- **Frontend**: Lightning Web Components (LWC)
- **Automation**: Flows, Invocable Methods, and Triggers
- **Database**: Salesforce Standard and Custom Objects
- **Integration**: REST APIs and Webhooks

## Project Structure

```
force-app/main/default/
├── classes/                 # Apex classes for business logic
├── flows/                   # Automated workflows
├── bots/                    # Agentforce Service Agent configuration
├── lwc/                     # Lightning Web Components
├── objects/                 # Custom objects (Lead extensions)
├── layouts/                 # Page layouts
├── permissionsets/          # Permission configurations
├── skills/                  # Agentforce skills
└── ...                      # Other Salesforce metadata
```

## Getting Started

### Prerequisites
- Salesforce Org with Agentforce capabilities
- Salesforce CLI installed
- Node.js and npm

### Installation
1. Clone the repository
2. Authorize your Salesforce org: `sfdx auth:web:login`
3. Deploy the metadata: `sfdx deploy:metadata`
4. Configure appointment scheduling policies and assignment rules
5. Set up dealership records with zip codes and availability

### Development

**Linting and Code Quality**
```bash
npm run lint                # Lint LWC components
npm run prettier            # Format code
npm run prettier:verify     # Verify formatting
```

**Testing**
```bash
npm run test                # Run all tests
npm run test:unit:watch     # Watch mode
npm run test:unit:coverage  # Coverage report
```

## Core Components

### Apex Classes
- `BookTestDriveAction`: Orchestrates the test drive booking process
- `CheckAvailableSlotsAction`: Retrieves available appointment slots
- `FindNearestDealership`: Locates nearest dealer by zip code
- `GetVehicleModels`: Retrieves available vehicle inventory
- `CreateTestDriveRecord`: Creates appointment records
- `SendBookingConfirmation`: Sends notifications to customers
- Community controllers for authentication and registration

### Flows
- `Book_Test_Drive`: Main booking workflow
- `Get_Best_Dealer`: Dealer assignment logic
- `Lead_Set_Zipcode`: Updates customer location data
- `Omni_Channel_Route_Work`: Work queue management
- `discovery_call_assessment`: Lead qualification process

### Agentforce Skills
- Vehicle information queries
- Dealership availability checking
- Test drive booking
- Account management
- Case creation and routing

## Usage Examples

### For Customers
1. **Ask about vehicles**: "What models do you have available?"
2. **Find dealerships**: "Where's your nearest dealership?"
3. **Check availability**: "What times are available for a test drive this weekend?"
4. **Book a test drive**: "I'd like to book a test drive for Saturday at 2 PM"

## Login URL:
URL: https://login.salesforce.com

## Access Customer Portal:
URL: https://electracars.my.site.com/homepage 

## Access as a dealer:
Login as Lakshmi Venkat to get the leads via Omni intelligent routing