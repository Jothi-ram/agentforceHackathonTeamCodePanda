public class CheckAvailableSlotsAction {
    
    @InvocableMethod(label='Check Available Test Drive Slots' 
                     description='Returns available time slots for test drives')
    public static List<SlotsResult> checkAvailableSlots(List<SlotsRequest> requests) {
        List<SlotsResult> results = new List<SlotsResult>();
        
        for (SlotsRequest request : requests) {
            SlotsResult result = new SlotsResult();
            result.availableSlots = new List<String>();
            result.availableSlotTimes = new List<DateTime>();
            
            try {
                // STEP 1: Find dealers in customer's zip code
                List<Account> dealers = [
                    SELECT Id, Name, BillingPostalCode, Capacity_Per_Slot__c
                    FROM Account
                    WHERE BillingPostalCode = :request.zipCode
                    AND Capacity_Per_Slot__c != NULL
                ];
                
                if (dealers.isEmpty()) {
                    result.success = false;
                    result.message = 'Sorry, we don\'t have dealerships in zip code ' + 
                                   request.zipCode + '. Would you like to try a nearby area?';
                    results.add(result);
                    continue;
                }
                
                // STEP 2: Generate time slots to check
                List<DateTime> slotsToCheck = generateTimeSlots(
                    request.preferredDate, 
                    request.timeOfDay
                );
                
                // STEP 3: Check each slot for availability
                for (DateTime slotTime : slotsToCheck) {
                    Boolean hasCapacity = false;
                    
                    // Check if ANY dealer has capacity at this time
                    for (Account dealer : dealers) {
                        Integer bookedCount = [
                            SELECT COUNT()
                            FROM Test_Drive__c
                            WHERE Dealer__c = :dealer.Id
                            AND Test_Drive_Date_Time__c = :slotTime
                            AND Status__c = 'Scheduled'
                        ];
                        
                        if (bookedCount < dealer.Capacity_Per_Slot__c) {
                            hasCapacity = true;
                            break;
                        }
                    }
                    
                    // If slot is available, add to results
                    if (hasCapacity) {
                        result.availableSlotTimes.add(slotTime);
                        result.availableSlots.add(formatSlotTime(slotTime));
                    }
                }
                
                // STEP 4: Build response
                if (result.availableSlots.isEmpty()) {
                    result.success = false;
                    result.message = 'Sorry, all slots are booked for ' + 
                                   request.preferredDate.format() + '. ' +
                                   'Would you like to try a different day?';
                } else {
                    result.success = true;
                    result.message = buildAvailabilityMessage(
                        result.availableSlots, 
                        request.preferredDate
                    );
                }
                
            } catch (Exception e) {
                result.success = false;
                result.message = 'Error checking availability. Please try again.';
                System.debug('CheckAvailableSlots Error: ' + e.getMessage());
            }
            
            results.add(result);
        }
        
        return results;
    }
    
    // Generate hourly slots based on time preference
    private static List<DateTime> generateTimeSlots(Date preferredDate, String timeOfDay) {
        List<DateTime> slots = new List<DateTime>();
        Integer startHour;
        Integer endHour;
        
        // Determine time range
        String timeOfDayLower = timeOfDay.toLowerCase();
        if (timeOfDayLower.contains('morning')) {
            startHour = 9;
            endHour = 12;
        } else if (timeOfDayLower.contains('afternoon')) {
            startHour = 12;
            endHour = 17;
        } else if (timeOfDayLower.contains('evening')) {
            startHour = 17;
            endHour = 19;
        } else {
            // All day
            startHour = 9;
            endHour = 18;
        }
        
        // Create hourly slots
        for (Integer hour = startHour; hour < endHour; hour++) {
            DateTime slotTime = DateTime.newInstance(
                preferredDate.year(),
                preferredDate.month(),
                preferredDate.day(),
                hour,
                0,
                0
            );
            slots.add(slotTime);
        }
        
        return slots;
    }
    
    // Format slot for display (e.g., "2:00 PM")
    private static String formatSlotTime(DateTime slotTime) {
        return slotTime.format('h:mm a');
    }
    
    // Build nice availability message
    private static String buildAvailabilityMessage(List<String> slots, Date forDate) {
        String dateFormatted = forDate.format();
        String message = 'Great! I found these available times on ' + dateFormatted + ':\n\n';
        
        for (String slot : slots) {
            message += '• ' + slot + '\n';
        }
        
        message += '\nWhich time works best for you?';
        return message;
    }
    
    // Input/Output wrapper classes
    public class SlotsRequest {
        @InvocableVariable(required=true label='Zip Code')
        public String zipCode;
        
        @InvocableVariable(required=true label='Preferred Date')
        public Date preferredDate;
        
        @InvocableVariable(required=false label='Time of Day' 
            description='morning, afternoon, evening, or all')
        public String timeOfDay;
    }
    
    public class SlotsResult {
        @InvocableVariable(label='Success')
        public Boolean success;
        
        @InvocableVariable(label='Message')
        public String message;
        
        @InvocableVariable(label='Available Slots (Display)')
        public List<String> availableSlots;
        
        @InvocableVariable(label='Available Slot Times (DateTime)')
        public List<DateTime> availableSlotTimes;
    }
}