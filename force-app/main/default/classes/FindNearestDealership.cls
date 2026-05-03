/**
 * Invocable Apex Action: Find Nearest Dealership
 * Uses the customer's zip code to find the closest Electra dealership.
 */
public with sharing class FindNearestDealership {

    public class DealerInput {
        @InvocableVariable(label='Zip Code' description='Customer zip code' required=true)
        public String zipCode;
    }

    public class DealerOutput {
        @InvocableVariable(label='Dealership Found' description='Whether a dealership was found')
        public Boolean dealershipFound;

        @InvocableVariable(label='Dealership Name' description='Name of the nearest dealership')
        public String dealershipName;

        @InvocableVariable(label='Dealership Id' description='Salesforce ID of the dealership')
        public String dealershipId;

        @InvocableVariable(label='Dealership Address' description='Full address of the dealership')
        public String dealershipAddress;

        @InvocableVariable(label='Message' description='Message to display to customer')
        public String message;
    }

    @InvocableMethod(
        label='Find Nearest Dealership'
        description='Finds the nearest Electra dealership based on customer zip code'
        category='Test Drive'
    )
    public static List<DealerOutput> findDealership(List<DealerInput> inputs) {
        String zipCode = inputs[0].zipCode;
        String zipPrefix = zipCode.length() >= 3 ? zipCode.substring(0, 3) : zipCode;


        DealerOutput output = new DealerOutput();

        
            // Fallback: find nearest dealership by zip prefix match
            List<Account> dealers = [
                SELECT Id, Name, BillingStreet, BillingCity, BillingState, BillingPostalCode
                FROM Account
                WHERE BillingPostalCode LIKE :(zipPrefix + '%')
                  AND RecordType.DeveloperName = 'Dealer'
                LIMIT 1
            ];

            if (!dealers.isEmpty()) {
                Account dealer = dealers[0];
                output.dealershipFound = true;
                output.dealershipId = dealer.Id;
                output.dealershipName = dealer.Name;
                output.dealershipAddress = formatAddress(dealer);
                output.message = dealer.Name + ' is your nearest dealership, located at '
                               + output.dealershipAddress + '.';
            } else {
                output.dealershipFound = false;
                output.message = 'I could not find a dealership near zip code ' + zipCode
                               + '. I will capture your details and have someone reach out to you.';
            }
        

        return new List<DealerOutput>{ output };
    }

    private static String formatAddress(Account dealer) {
        List<String> parts = new List<String>();
        if (String.isNotBlank(dealer.BillingStreet))     parts.add(dealer.BillingStreet);
        if (String.isNotBlank(dealer.BillingCity))        parts.add(dealer.BillingCity);
        if (String.isNotBlank(dealer.BillingState))       parts.add(dealer.BillingState);
        if (String.isNotBlank(dealer.BillingPostalCode))  parts.add(dealer.BillingPostalCode);
        return String.join(parts, ', ');
    }

   
}