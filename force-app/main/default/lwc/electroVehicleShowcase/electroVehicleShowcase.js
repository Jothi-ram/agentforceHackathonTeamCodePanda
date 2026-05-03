import { LightningElement, wire } from 'lwc';
import getVehicles from '@salesforce/apex/VehicleController.getVehicles';

// Maps BodyType to a display emoji and accent colour
const BODY_TYPE_CONFIG = {
  'Sedan':     { emoji: '🚗', color: '#00d4ff' },
  'SUV':       { emoji: '🚙', color: '#0084d4' },
  'Coupe':     { emoji: '🏎️', color: '#00c8ff' },
  'Truck':     { emoji: '🚛', color: '#0095d4' },
  'Hatchback': { emoji: '🚘', color: '#00b4e8' },
  'Van':       { emoji: '🚐', color: '#0070c0' },
  'Default':   { emoji: '⚡', color: '#0088d4' }
};

export default class ElectroVehicleShowcase extends LightningElement {
  vehicles = [];
  isLoading = true;
  error;

  @wire(getVehicles)
  wiredVehicles({ error, data }) {
    if (data) {
      this.vehicles = data.map((v) => {
        const cfg = BODY_TYPE_CONFIG[v.BodyType] || BODY_TYPE_CONFIG['Default'];
        return {
          id:           v.Id,
          name:         v.Name,
          variantName:  v.VariantName || '',
          type:         v.BodyType || v.FuelType || 'Electric Vehicle',
          fuelType:     v.FuelType || 'Electric',
          vehicleClass: v.VehicleClass || '',
          range:        v.MaximumBatteryRange ? v.MaximumBatteryRange + ' mi' : 'N/A',
          acceleration: v.AccelerationTime   ? v.AccelerationTime + 's'  : 'N/A',
          topSpeed:     v.TopSpeed           ? v.TopSpeed + ' mph'        : 'N/A',
          emoji:        cfg.emoji,
          color:        cfg.color
        };
      });
      this.error = undefined;
      this.isLoading = false;
    } else if (error) {
      this.error = error;
      this.isLoading = false;
    }
  }

  get hasVehicles() {
    return this.vehicles && this.vehicles.length > 0;
  }

  get errorMessage() {
    if (!this.error) return '';
    return this.error.body ? this.error.body.message : JSON.stringify(this.error);
  }

  handleVehicleSelect(event) {
    const vehicleId = event.currentTarget.dataset.vehicleId;
    this.dispatchEvent(new CustomEvent('vehicleselected', {
      detail: { vehicleId }
    }));
  }
}