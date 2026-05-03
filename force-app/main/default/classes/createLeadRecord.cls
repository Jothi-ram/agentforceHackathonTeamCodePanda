public class createLeadRecord {
    
    @InvocableMethod(label='Create Lead Record' 
                     description='Creates new Lead for test drive booking'
                     category='Test Drive Booking')
    public static List<LeadCreationResult> createLeadRecord(List<LeadCreationRequest> requests) {
        List<LeadCreationResult> results = new List<LeadCreationResult>();
        
        for (LeadCreationRequest request : requests) {
            LeadCreationResult result = new LeadCreationResult();
            
            try {
                if (String.isBlank(request.firstName) || 
                    String.isBlank(request.lastName) || 
                    String.isBlank(request.email)) {
                    throw new TestDriveException('First name, last name, and email are required.');
                }
                
                List<Lead> existingLeads = [
                    SELECT Id, Email, Status
                    FROM Lead
                    WHERE Email = :request.email
                    AND IsConverted = false
                    LIMIT 1
                ];
                
                if (!existingLeads.isEmpty()) {
                    result.leadId = existingLeads[0].Id;
                    result.isNewLead = false;
                    result.message = 'We found your previous inquiry. Updating your information.';
                    
                    Lead existingLead = existingLeads[0];
                    existingLead.Status = 'Test Drive Requested';
                    existingLead.Phone = request.phone;
                    existingLead.PostalCode = request.zipCode;
                    existingLead.Product_Interest__c = request.productId;
                    existingLead.LeadSource = request.bookingChannel;
                    update existingLead;
                    
                } else {
                    Lead newLead = new Lead();
                    newLead.FirstName = request.firstName;
                    newLead.LastName = request.lastName;
                    newLead.Email = request.email;
                    newLead.Phone = request.phone;
                    newLead.PostalCode = request.zipCode;
                    newLead.Company = request.firstName + ' ' + request.lastName;
                    newLead.Status = 'Test Drive Requested';
                    newLead.LeadSource = String.isNotBlank(request.bookingChannel) 
                                         ? request.bookingChannel 
                                         : 'Website - Agentforce';
                    newLead.Product_Interest__c = request.productId;
                    
                    insert newLead;
                    
                    result.leadId = newLead.Id;
                    result.isNewLead = true;
                    result.message = 'Welcome! We\'re excited to help you with your test drive.';
                }
                
                result.success = true;
                result.customerName = request.firstName + ' ' + request.lastName;
                result.customerEmail = request.email;
                result.customerPhone = request.phone;
                result.customerZipCode = request.zipCode;
                
            } catch (Exception e) {
                result.success = false;
                result.errorMessage = 'Unable to create profile: ' + e.getMessage();
                System.debug('Error in createLeadRecord: ' + e.getMessage());
            }
            
            results.add(result);
        }
        
        return results;
    }
    
    public class LeadCreationRequest {
        @InvocableVariable(required=true label='First Name')
        public String firstName;
        
        @InvocableVariable(required=true label='Last Name')
        public String lastName;
        
        @InvocableVariable(required=true label='Email Address')
        public String email;
        
        @InvocableVariable(required=true label='Phone Number')
        public String phone;
        
        @InvocableVariable(required=true label='Zip Code')
        public String zipCode;
        
        @InvocableVariable(required=true label='Product ID')
        public String productId;
        
        @InvocableVariable(label='Booking Channel')
        public String bookingChannel;
    }
    
    public class LeadCreationResult {
        @InvocableVariable(label='Success')
        public Boolean success;
        
        @InvocableVariable(label='Lead ID')
        public String leadId;
        
        @InvocableVariable(label='Is New Lead')
        public Boolean isNewLead;
        
        @InvocableVariable(label='Customer Name')
        public String customerName;
        
        @InvocableVariable(label='Customer Email')
        public String customerEmail;
        
        @InvocableVariable(label='Customer Phone')
        public String customerPhone;
        
        @InvocableVariable(label='Customer Zip Code')
        public String customerZipCode;
        
        @InvocableVariable(label='Message')
        public String message;
        
        @InvocableVariable(label='Error Message')
        public String errorMessage;
    }
    
    public class TestDriveException extends Exception {}
}