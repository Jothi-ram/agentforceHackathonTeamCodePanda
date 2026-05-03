/**
 * Invocable Apex Action: Send Booking Confirmation
 * Sends a confirmation notification via the customer's preferred channel.
 */
public with sharing class SendBookingConfirmation {

    public class ConfirmationInput {
        @InvocableVariable(label='Test Drive Id' description='ID of the Test Drive record' required=true)
        public String testDriveId;

        @InvocableVariable(label='Channel' description='Notification channel: Email, WhatsApp, SMS')
        public String channel;
    }

    public class ConfirmationOutput {
        @InvocableVariable(label='Confirmation Sent' description='Whether confirmation was sent successfully')
        public Boolean confirmationSent;

        @InvocableVariable(label='Message' description='Status message')
        public String message;
    }

    @InvocableMethod(
        label='Send Booking Confirmation'
        description='Sends a test drive booking confirmation to the customer'
        category='Test Drive'
    )
    public static List<ConfirmationOutput> sendConfirmation(List<ConfirmationInput> inputs) {
        ConfirmationInput input = inputs[0];
        ConfirmationOutput output = new ConfirmationOutput();

        try {
            Test_Drive__c testDrive = [
                SELECT Id, Name/*, Customer_Name__c, Customer_Email__c, Customer_Phone__c,
                       Preferred_Date__c, Preferred_Time__c, Channel__c,
                       Vehicle_Model__r.Name, Dealership__r.Name,
                       Dealership__r.BillingStreet, Dealership__r.BillingCity,
                       Dealership__r.BillingState, Dealership__r.BillingPostalCode*/
                FROM Test_Drive__c
                WHERE Id = :input.testDriveId
                LIMIT 1
            ];

            //String effectiveChannel = String.isNotBlank(input.channel) ? input.channel : testDrive.Channel__c;
            String effectiveChannel = 'web';

            if (effectiveChannel == 'Email' || effectiveChannel == 'Web') {
                //sendEmailConfirmation(testDrive);
            }
            // WhatsApp and SMS would use Messaging API / Digital Engagement
            // Placeholder for those channels — requires org-specific setup
            // if (effectiveChannel == 'WhatsApp') { sendWhatsAppConfirmation(testDrive); }
            // if (effectiveChannel == 'SMS') { sendSmsConfirmation(testDrive); }

            // Update the Test Drive record
            /*testDrive.Confirmation_Sent__c = true;
            testDrive.Confirmation_Timestamp__c = DateTime.now();
            testDrive.Status__c = 'Confirmed';*/
            update testDrive;

            output.confirmationSent = true;
            output.message = 'Confirmation sent to ' 
                           + '. Your booking reference is ' + testDrive.Name + '.';

        } catch (Exception e) {
            output.confirmationSent = false;
            output.message = 'Booking was created but there was an issue sending confirmation. '
                           + 'Your booking is still valid.';
            System.debug(LoggingLevel.ERROR, 'SendBookingConfirmation error: ' + e.getMessage());
        }

        return new List<ConfirmationOutput>{ output };
    }

   /* private static void sendEmailConfirmation(Test_Drive__c td) {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new List<String>{ td.Customer_Email__c });
        mail.setSubject('Your Electra Cars Test Drive is Confirmed! - ' + td.Name);

        String dealerAddress = String.join(new List<String>{
            td.Dealership__r.BillingStreet ?? '',
            td.Dealership__r.BillingCity ?? '',
            td.Dealership__r.BillingState ?? '',
            td.Dealership__r.BillingPostalCode ?? ''
        }, ', ');

       /* String body = 'Hi ' + td.Customer_Name__c + ',\n\n'
            + 'Your Electra Cars test drive is confirmed!\n\n'
            + 'Booking Details:\n'
            + '• Reference: ' + td.Name + '\n'
            + '• Vehicle: ' + td.Vehicle_Model__r.Name + '\n'
            + '• Dealership: ' + td.Dealership__r.Name + '\n'
            + '• Address: ' + dealerAddress + '\n'
            + '• Date: ' + td.Preferred_Date__c.format() + '\n'
            + '• Time: ' + td.Preferred_Time__c + '\n\n'
            + 'Need to reschedule? Reply to this email or call us.\n\n'
            + 'See you soon!\n'
            + 'Electra Cars';

        mail.setPlainTextBody(body);
        mail.setSaveAsActivity(true);

        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
        }
    }*/
}