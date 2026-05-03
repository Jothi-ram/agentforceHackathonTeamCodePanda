/**
 * Invocable Apex Action: Create Test Drive Record
 * Creates a Test_Drive__c record and an associated Lead in one transaction.
 */
public with sharing class CreateTestDriveRecord {

    public class BookingInput {
        @InvocableVariable(label='Customer Name' description='Full name of the customer' required=true)
        public String customerName;

        @InvocableVariable(label='Email' description='Customer email address' required=true)
        public String email;

        @InvocableVariable(label='Phone' description='Customer phone number' required=true)
        public String phone;

        @InvocableVariable(label='Vehicle Model Name' description='Name of the selected vehicle model' required=true)
        public String vehicleModelName;

        @InvocableVariable(label='Dealership Id' description='Salesforce ID of the assigned dealership' required=true)
        public String dealershipId;

        @InvocableVariable(label='Preferred Date' description='Preferred test drive date' required=true)
        public Date preferredDate;

        @InvocableVariable(label='Time Slot' description='Morning, Afternoon, or Evening' required=true)
        public String timeSlot;

        @InvocableVariable(label='Zip Code' description='Customer zip code' required=true)
        public String zipCode;

        @InvocableVariable(label='Channel' description='Booking channel: Web, WhatsApp, SMS')
        public String channel;
    }

    public class BookingOutput {
        @InvocableVariable(label='Success' description='Whether the booking was created successfully')
        public Boolean success;

        @InvocableVariable(label='Booking Reference' description='Test drive booking reference number')
        public String bookingReference;

        @InvocableVariable(label='Test Drive Id' description='Salesforce ID of the created Test Drive record')
        public String testDriveId;

        @InvocableVariable(label='Message' description='Confirmation or error message')
        public String message;
    }

    @InvocableMethod(
        label='Create Test Drive Record'
        description='Creates a test drive booking and associated lead record'
        category='Test Drive'
    )
    public static List<BookingOutput> createBooking(List<BookingInput> inputs) {
        BookingInput input = inputs[0];
        BookingOutput output = new BookingOutput();

        Savepoint sp = Database.setSavepoint();

        try {
            // 1. Find or create Lead
            Lead lead = findOrCreateLead(input);

            // 2. Find vehicle model
            List<Product2> vehicles = [
                SELECT Id, Name
                FROM Product2
                WHERE Name = :input.vehicleModelName
                  AND IsActive = true
                LIMIT 1
            ];

            if (vehicles.isEmpty()) {
                output.success = false;
                output.message = 'Vehicle model "' + input.vehicleModelName + '" not found. Please select a valid model.';
                return new List<BookingOutput>{ output };
            }

            // 3. Create Test Drive record
            Test_Drive__c testDrive = new Test_Drive__c(
                /*Lead__c             = lead.Id,
                Vehicle_Model__c    = vehicles[0].Id,
                Dealership__c       = input.dealershipId,
                Preferred_Date__c   = input.preferredDate,
                Preferred_Time__c   = input.timeSlot,
                Zip_Code__c         = input.zipCode,
                Status__c           = 'Requested',
                Channel__c          = String.isNotBlank(input.channel) ? input.channel : 'Web',
                Customer_Name__c    = input.customerName,
                Customer_Email__c   = input.email,
                Customer_Phone__c   = input.phone,
                Booking_Source__c   = 'Agentforce'*/
            );

            insert testDrive;

            // Re-query to get auto-number Name field
            testDrive = [SELECT Id, Name FROM Test_Drive__c WHERE Id = :testDrive.Id LIMIT 1];

            output.success = true;
            output.testDriveId = testDrive.Id;
            output.bookingReference = testDrive.Name;
            output.message = 'Test drive booked successfully! Your booking reference is ' + testDrive.Name + '.';

        } catch (Exception e) {
            Database.rollback(sp);
            output.success = false;
            output.message = 'Sorry, there was an error creating your booking. Please try again.';
            // Log the error for debugging
            System.debug(LoggingLevel.ERROR, 'CreateTestDriveRecord error: ' + e.getMessage()
                         + ' | Stack: ' + e.getStackTraceString());
        }

        return new List<BookingOutput>{ output };
    }

    private static Lead findOrCreateLead(BookingInput input) {
        // Parse name
        String firstName = '';
        String lastName = input.customerName;
        if (input.customerName.contains(' ')) {
            Integer spaceIdx = input.customerName.indexOf(' ');
            firstName = input.customerName.substring(0, spaceIdx);
            lastName = input.customerName.substring(spaceIdx + 1);
        }

        // Check for existing lead by email
        List<Lead> existingLeads = [
            SELECT Id, FirstName, LastName, Email
            FROM Lead
            WHERE Email = :input.email
              AND IsConverted = false
            LIMIT 1
        ];

        if (!existingLeads.isEmpty()) {
            return existingLeads[0];
        }

        // Create new lead
        Lead newLead = new Lead(
            FirstName   = firstName,
            LastName    = lastName,
            Email       = input.email,
            Phone       = input.phone,
            PostalCode  = input.zipCode,
            LeadSource  = 'Web',
            Company     = 'Individual - ' + input.customerName,
            Status      = 'New'
        );

        insert newLead;
        return newLead;
    }
}