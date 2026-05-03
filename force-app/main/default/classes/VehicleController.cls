/**
 * VehicleController
 * Provides AuraEnabled methods to query VehicleDefinition and Vehicle
 * Salesforce objects for the Electra Cars LWC components.
 */
public without sharing class VehicleController {

    @AuraEnabled(cacheable=true)
    public static List<VehicleDefinition> getVehicles() {
        return [
            SELECT Id,
                   Name,
                   VariantName,
                   BodyType,
                   FuelType,
                   VehicleClass,
                   MaximumBatteryRange,
                   AccelerationTime,
                   TopSpeed,
                   BatteryCapacity,
                   TotalPower,
                   DrivetrainType,
                   TransmissionType,
                   ModelCode
            FROM   VehicleDefinition
            ORDER  BY Name
            LIMIT  50
        ];
    }

    @AuraEnabled(cacheable=true)
    public static VehicleDefinition getVehicleById(Id vehicleId) {
        if (vehicleId == null) {
            return null;
        }
        List<VehicleDefinition> results = [
            SELECT Id,
                   Name,
                   VariantName,
                   BodyType,
                   FuelType,
                   VehicleClass,
                   MaximumBatteryRange,
                   MinimumBatteryRange,
                   AccelerationTime,
                   TopSpeed,
                   BatteryCapacity,
                   TotalPower,
                   DrivetrainType,
                   TransmissionType,
                   EngineName,
                   ModelCode,
                   DoorCount,
                   Height,
                   Width,
                   Length,
                   Wheelbase,
                   CurbWeight,
                   MaximumTorque,
                   MaximumGrossWeight,
                   EmissionStandard
            FROM   VehicleDefinition
            WHERE  Id = :vehicleId
            LIMIT  1
        ];
        return results.isEmpty() ? null : results[0];
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getDealerships(String searchTerm) {
        String likeQuery = String.isBlank(searchTerm)
            ? '%'
            : '%' + String.escapeSingleQuotes(searchTerm.trim()) + '%';
        return [
            SELECT Id,
                   Name,
                   Phone,
                   Fax,
                   Website,
                   Description,
                   BillingStreet,
                   BillingCity,
                   BillingState,
                   BillingPostalCode,
                   BillingCountry,
                   Type,
                   Rating
            FROM   Account
            WHERE  (Name LIKE :likeQuery
                    OR BillingCity LIKE :likeQuery
                    OR BillingState LIKE :likeQuery)
            AND    (Type = 'Partner'
                    OR Name LIKE '%Electra%'
                    OR Name LIKE '%Dealer%'
                    OR Name LIKE '%Showroom%')
            ORDER  BY Name
            LIMIT  50
        ];
    }
}