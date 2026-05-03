import { LightningElement, track } from 'lwc';
import getDealerships from '@salesforce/apex/VehicleController.getDealerships';

export default class ElectroDealershipFinder extends LightningElement {
  @track dealerships = [];
  @track isLoading = true;
  @track error;
  searchQuery = '';

  connectedCallback() {
    this.loadDealerships('');
  }

  loadDealerships(searchTerm) {
    this.isLoading = true;
    this.error = undefined;
    getDealerships({ searchTerm })
      .then((data) => {
        this.dealerships = data.map((d) => {
          const parts = [
            d.BillingStreet,
            d.BillingCity,
            d.BillingState,
            d.BillingPostalCode,
            d.BillingCountry
          ].filter(Boolean);
          return {
            id:          d.Id,
            name:        d.Name,
            phone:       d.Phone    || '—',
            website:     d.Website  || '',
            description: d.Description || '',
            address:     parts.length ? parts.join(', ') : 'Address not available',
            type:        d.Type     || '',
            rating:      d.Rating   || ''
          };
        });
        this.isLoading = false;
      })
      .catch((err) => {
        this.error = err.body ? err.body.message : JSON.stringify(err);
        this.isLoading = false;
      });
  }

  get hasDealerships() {
    return this.dealerships && this.dealerships.length > 0;
  }

  handleSearchChange(event) {
    this.searchQuery = event.target.value;
  }

  handleSearch() {
    this.loadDealerships(this.searchQuery);
  }

  handleKeyDown(event) {
    if (event.key === 'Enter') {
      this.loadDealerships(this.searchQuery);
    }
  }
}