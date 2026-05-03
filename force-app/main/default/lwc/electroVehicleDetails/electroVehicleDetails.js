import { LightningElement, api, wire } from 'lwc';
import getVehicleById from '@salesforce/apex/VehicleController.getVehicleById';

const BODY_TYPE_CONFIG = {
  'Sedan':     { emoji: '🚗', color: '#00d4ff' },
  'SUV':       { emoji: '🚙', color: '#0084d4' },
  'Coupe':     { emoji: '🏎️', color: '#00c8ff' },
  'Truck':     { emoji: '🚛', color: '#0095d4' },
  'Hatchback': { emoji: '🚘', color: '#00b4e8' },
  'Van':       { emoji: '🚐', color: '#0070c0' },
  'Default':   { emoji: '⚡', color: '#0088d4' }
};

function fmt(value, unit) {
  return value != null ? value + (unit ? ' ' + unit : '') : 'N/A';
}

export default class ElectroVehicleDetails extends LightningElement {
  @api vehicleId;

  vehicle;
  isLoading = true;
  error;

  @wire(getVehicleById, { vehicleId: '$vehicleId' })
  wiredVehicle({ error, data }) {
    if (data) {
      const cfg = BODY_TYPE_CONFIG[data.BodyType] || BODY_TYPE_CONFIG['Default'];
      this.vehicle = {
        id:            data.Id,
        name:          data.Name,
        variantName:   data.VariantName || '',
        type:          data.BodyType || data.FuelType || 'Electric Vehicle',
        fuelType:      data.FuelType || 'Electric',
        vehicleClass:  data.VehicleClass || '',
        modelCode:     data.ModelCode || '',
        engine:        data.EngineName || 'Electric Motor',
        drivetrain:    data.DrivetrainType || 'N/A',
        transmission:  data.TransmissionType || 'N/A',
        emission:      data.EmissionStandard || 'N/A',
        // Performance
        range:         fmt(data.MaximumBatteryRange, 'mi'),
        minRange:      data.MinimumBatteryRange ? fmt(data.MinimumBatteryRange, 'mi') : null,
        acceleration:  fmt(data.AccelerationTime, 's'),
        topSpeed:      fmt(data.TopSpeed, 'mph'),
        batteryCapacity: fmt(data.BatteryCapacity, 'kWh'),
        totalPower:    fmt(data.TotalPower, 'hp'),
        maxTorque:     fmt(data.MaximumTorque, 'Nm'),
        // Dimensions
        height:        fmt(data.Height, 'mm'),
        width:         fmt(data.Width, 'mm'),
        length:        fmt(data.Length, 'mm'),
        wheelbase:     fmt(data.Wheelbase, 'mm'),
        curbWeight:    fmt(data.CurbWeight, 'kg'),
        maxGrossWeight: fmt(data.MaximumGrossWeight, 'kg'),
        doorCount:     data.DoorCount || 'N/A',
        // Visual
        emoji: cfg.emoji,
        color: cfg.color
      };
      this.error = undefined;
      this.isLoading = false;
    } else if (error) {
      this.error = error;
      this.isLoading = false;
    }
  }

  get errorMessage() {
    if (!this.error) return '';
    return this.error.body ? this.error.body.message : JSON.stringify(this.error);
  }

  handleBack() {
    this.dispatchEvent(new CustomEvent('back'));
  }
}