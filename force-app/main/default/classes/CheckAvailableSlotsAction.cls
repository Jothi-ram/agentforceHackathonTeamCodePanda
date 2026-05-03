public class CheckAvailableSlotsAction {
    
    @InvocableMethod(label='Check Available Test Drive Slots')
    public static List<SlotsResult> checkAvailableSlots(List<SlotsRequest> requests) {
        List<SlotsResult> results = new List<SlotsResult>();
        
        for (SlotsRequest request : requests) {
            SlotsResult result = new SlotsResult();
            result.availableSlots = new List<String>();
            result.availableSlotTimes = new List<DateTime>();
            
            try {
                List<Account> dealers = [
                    SELECT Id, Name, Capacity_Per_Slot__c
                    FROM Account
                    WHERE BillingPostalCode = :request.zipCode
                    AND Capacity_Per_Slot__c != NULL
                ];
                
                if (dealers.isEmpty()) {
                    result.success = false;
                    result.message = 'No dealerships in zip code ' + request.zipCode;
                    results.add(result);
                    continue;
                }
                
                List<DateTime> slotsToCheck = generateTimeSlots(request.preferredDate, request.timeOfDay);
                system.debug('slotsToCheck'+slotsToCheck);
                for (DateTime slotTime : slotsToCheck) {
                    String slotKey = makeSlotKey(slotTime);
                    system.debug('slotTime'+slotTime);
                    system.debug('slotKey'+slotKey);
                    Integer totalCapacity = 0;
                    Integer totalBooked = 0;
                    
                    for (Account dealer : dealers) {
                        // Add this dealer's capacity
                        totalCapacity += Integer.valueOf(dealer.Capacity_Per_Slot__c);
                        
                        // Count how many are booked with this dealer
                        Integer bookedCount = [
                            SELECT COUNT()
                            FROM Test_Drive__c
                            WHERE Dealer__c = :dealer.Id
                            AND Slot_Key__c = :slotKey
                            AND Status__c = 'Scheduled'
                        ];
                        
                        totalBooked += bookedCount;
                    }
                    
                 
                    if (totalBooked < totalCapacity) {
                        result.availableSlotTimes.add(slotTime);
                        result.availableSlots.add(slotTime.format('h:mm a'));
                    }
                }
                
                if (result.availableSlots.isEmpty()) {
                    result.success = false;
                    result.message = 'All slots fully booked for ' + request.preferredDate.format() + '. Please try another date.';
                } else {
                    result.success = true;
                    result.message = 'Available times on ' + request.preferredDate.format() + ':\n\n';
                    for (String slot : result.availableSlots) {
                        result.message += '• ' + slot + '\n';
                    }
                    result.message += '\nWhich time works best?';
                }
                
            } catch (Exception e) {
                result.success = false;
                result.message = 'Error checking availability';
                System.debug('Error: ' + e.getMessage());
            }
            
            results.add(result);
        }
        return results;
    }
    
    private static String makeSlotKey(DateTime dt) {
        return dt.year() + '-' + dt.month() + '-' + dt.day() + '-' + dt.hour();
    }
    
    private static List<DateTime> generateTimeSlots(Date preferredDate, String timeOfDay) {
        List<DateTime> slots = new List<DateTime>();
        Integer startHour = 9;
        Integer endHour = 18;
        
        if (timeOfDay != null) {
            String lower = timeOfDay.toLowerCase();
            if (lower.contains('morning')) {
                startHour = 9; endHour = 12;
            } else if (lower.contains('afternoon')) {
                startHour = 12; endHour = 17;
            } else if (lower.contains('evening')) {
                startHour = 17; endHour = 19;
            }
        }
        
        for (Integer hour = startHour; hour < endHour; hour++) {
            slots.add(DateTime.newInstance(preferredDate, Time.newInstance(hour, 0, 0, 0)));
        }
        return slots;
    }
    
    public class SlotsRequest {
        @InvocableVariable(required=true) public String zipCode;
        @InvocableVariable(required=true) public Date preferredDate;
        @InvocableVariable(required=false) public String timeOfDay;
    }
    
    public class SlotsResult {
        @InvocableVariable public Boolean success;
        @InvocableVariable public String message;
        @InvocableVariable public List<String> availableSlots;
        @InvocableVariable public List<DateTime> availableSlotTimes;
    }
}