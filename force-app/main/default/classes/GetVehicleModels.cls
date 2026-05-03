/**
 * Invocable Apex Action: Get Vehicle Models
 * Used by Agentforce to retrieve active Electra Cars vehicle models for test drive selection.
 * Queries Product2 records and returns a formatted list including Family and Description.
 */
public with sharing class GetVehicleModels {

    public class VehicleModelOutput {
        @InvocableVariable(label='Vehicle Models' description='Formatted list of available vehicle models with descriptions')
        public String vehicleModels;

        @InvocableVariable(label='Model Count' description='Number of models available')
        public Integer modelCount;
    }
    
    public Class Request{
        @InvocableVariable(required=true)
        public String inputQuery;
 }  
 

    @InvocableMethod(
        label='Get Vehicle Models'
        description='Retrieves all active Electra Cars vehicle models available for test drives'
        category='Test Drive'
    )
    public static List<VehicleModelOutput> getModels(List<Request> requests) {
        
        List<Product2> models = [
            SELECT Id, Name, Family, Description
            FROM Product2
            WHERE IsActive = true
            ORDER BY Family ASC, Name ASC
            LIMIT 20
        ];

        VehicleModelOutput output = new VehicleModelOutput();

        if (models.isEmpty()) {
            output.vehicleModels = 'No vehicle models are currently available for test drives.';
            output.modelCount = 0;
            return new List<VehicleModelOutput>{ output };
        }

        String result = '';
        for (Product2 model : models) {
            result += '• ' + model.Name;
            if (String.isNotBlank(model.Family)) {
                result += ' (' + model.Family + ')';
            }
            if (String.isNotBlank(model.Description)) {
                result += ' — ' + model.Description;
            }
            result+= '----for internal productId:'+ model.Id;
            result += '\n';
        }

        output.vehicleModels = result;
        output.modelCount = models.size();

        return new List<VehicleModelOutput>{ output };
    }
}