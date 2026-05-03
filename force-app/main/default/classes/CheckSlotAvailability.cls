/**
 * Invocable Apex Action: Check Slot Availability
 * Checks if a specific date/time slot is available at a dealership.
 */
public with sharing class CheckSlotAvailability {

    private static final Integer MAX_SLOTS_PER_PERIOD = 4; // max test drives per time slot

    public class AvailabilityInput {
        @InvocableVariable(label='Dealership Id' description='ID of the dealership' required=true)
        public String dealershipId;

        @InvocableVariable(label='Preferred Date' description='Preferred test drive date (YYYY-MM-DD)' required=true)
        public Date preferredDate;

        @InvocableVariable(label='Time Slot' description='Morning, Afternoon, or Evening' required=true)
        public String timeSlot;
    }

    public class AvailabilityOutput {
        @InvocableVariable(label='Is Available' description='Whether the requested slot is available')
        public Boolean isAvailable;

        @InvocableVariable(label='Message' description='Availability message for the customer')
        public String message;

        @InvocableVariable(label='Alternative Slots' description='Suggested alternative slots if unavailable')
        public String alternativeSlots;
    }

    @InvocableMethod(
        label='Check Slot Availability'
        description='Checks if a test drive time slot is available at a dealership'
        category='Test Drive'
    )
    public static List<AvailabilityOutput> checkAvailability(List<AvailabilityInput> inputs) {
        AvailabilityInput input = inputs[0];
        AvailabilityOutput output = new AvailabilityOutput();

        // Validate date is in the future
        if (input.preferredDate < Date.today()) {
            output.isAvailable = false;
            output.message = 'The selected date is in the past. Please choose a future date.';
            return new List<AvailabilityOutput>{ output };
        }

        // Validate date is within 30 days
        if (input.preferredDate > Date.today().addDays(30)) {
            output.isAvailable = false;
            output.message = 'We can only book test drives up to 30 days in advance. Please choose an earlier date.';
            return new List<AvailabilityOutput>{ output };
        }

        // Count existing bookings for this slot
        Integer existingBookings = [
            SELECT COUNT()
            FROM Test_Drive__c
           /* WHERE Dealership__c = :input.dealershipId
              AND Preferred_Date__c = :input.preferredDate
              AND Preferred_Time__c = :input.timeSlot
              AND Status__c NOT IN ('Cancelled', 'No-Show')*/
        ];

        if (existingBookings < MAX_SLOTS_PER_PERIOD) {
            output.isAvailable = true;
            output.message = 'The ' + input.timeSlot + ' slot on '
                           + input.preferredDate.format() + ' is available!';
        } else {
            output.isAvailable = false;
            output.message = 'Sorry, the ' + input.timeSlot + ' slot on '
                           + input.preferredDate.format() + ' is fully booked.';

            // Find alternative slots
            List<String> allSlots = new List<String>{ 'Morning', 'Afternoon', 'Evening' };
            List<String> alternatives = new List<String>();

            for (String slot : allSlots) {
                if (slot == input.timeSlot) continue;
                Integer count = [
                    SELECT COUNT()
                    FROM Test_Drive__c
                   /* WHERE Dealership__c = :input.dealershipId
                      AND Preferred_Date__c = :input.preferredDate
                      AND Preferred_Time__c = :slot
                      AND Status__c NOT IN ('Cancelled', 'No-Show')*/
                ];
                if (count < MAX_SLOTS_PER_PERIOD) {
                    alternatives.add(slot);
                }
            }

            if (!alternatives.isEmpty()) {
                output.alternativeSlots = String.join(alternatives, ', ');
                output.message += ' Available alternatives: ' + output.alternativeSlots + '.';
            } else {
                // Try next day
                output.message += ' Would you like to try a different date?';
            }
        }

        return new List<AvailabilityOutput>{ output };
    }
}