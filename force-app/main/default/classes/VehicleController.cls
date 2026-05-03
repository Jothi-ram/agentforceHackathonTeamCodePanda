/**
 * VehicleController
 * Provides AuraEnabled methods to query VehicleDefinition and Vehicle
 * Salesforce objects for the Electra Cars LWC components.
 */
public with sharing class VehicleController {

    /**
     * Returns the list of VehicleDefinition records for the vehicle showcase grid.
     * Uses WITH SECURITY_ENFORCED to respect FLS/CRUD permissions.
     */
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
            WITH   SECURITY_ENFORCED
            ORDER  BY Name
            LIMIT  50
        ];
    }

    /**
     * Returns detailed fields for a single VehicleDefinition record.
     * @param vehicleId  The Salesforce record Id of the VehicleDefinition.
     */
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
            WITH   SECURITY_ENFORCED
            LIMIT  1
        ];
        return results.isEmpty() ? null : results[0];
    }
}