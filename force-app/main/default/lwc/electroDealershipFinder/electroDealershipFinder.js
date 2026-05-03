import { LightningElement } from 'lwc';

export default class ElectroDealershipFinder extends LightningElement {
  searchQuery = '';

  dealerships = [
    {
      id: '1',
      name: 'Electra Motors Downtown',
      address: '123 Main Street, New York, NY 10001',
      phone: '+1 (212) 555-0100',
      hours: 'Mon-Fri: 9AM-8PM, Sat: 10AM-6PM',
      distance: '0.5',
      rating: '4.8'
    },
    {
      id: '2',
      name: 'Electra Motors Midtown',
      address: '456 Park Avenue, New York, NY 10022',
      phone: '+1 (212) 555-0101',
      hours: 'Mon-Fri: 9AM-8PM, Sat: 10AM-6PM',
      distance: '2.3',
      rating: '4.7'
    },
    {
      id: '3',
      name: 'Electra Motors Brooklyn',
      address: '789 Columbia Heights, Brooklyn, NY 11231',
      phone: '+1 (718) 555-0102',
      hours: 'Mon-Fri: 10AM-7PM, Sat: 11AM-5PM',
      distance: '4.8',
      rating: '4.9'
    },
    {
      id: '4',
      name: 'Electra Motors Queens',
      address: '321 Queens Boulevard, Queens, NY 11375',
      phone: '+1 (718) 555-0103',
      hours: 'Mon-Fri: 9AM-8PM, Sat: 10AM-6PM',
      distance: '8.2',
      rating: '4.6'
    },
    {
      id: '5',
      name: 'Electra Motors Westchester',
      address: '654 Central Avenue, Yonkers, NY 10701',
      phone: '+1 (914) 555-0104',
      hours: 'Mon-Fri: 9AM-8PM, Sat: 10AM-6PM',
      distance: '15.3',
      rating: '4.7'
    },
    {
      id: '6',
      name: 'Electra Motors New Jersey',
      address: '987 Route 3, Jersey City, NJ 07310',
      phone: '+1 (201) 555-0105',
      hours: 'Mon-Fri: 9AM-8PM, Sat: 10AM-6PM',
      distance: '5.6',
      rating: '4.8'
    }
  ];

  handleSearchChange(event) {
    this.searchQuery = event.target.value;
  }

  handleSearch() {
    if (!this.searchQuery) {
      alert('Please enter a city or ZIP code');
      return;
    }
    // In a real scenario, you would filter dealerships by location
    alert(`Searching for dealerships near: ${this.searchQuery}`);
  }

  handleContactDealer(event) {
    const dealerId = event.currentTarget.dataset.dealerId;
    const dealer = this.dealerships.find(d => d.id === dealerId);
    alert(`Contacting ${dealer.name}. Form or contact details would be displayed here.`);
  }
}