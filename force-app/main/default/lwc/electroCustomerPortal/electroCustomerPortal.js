import { LightningElement } from 'lwc';

export default class ElectroCustomerPortal extends LightningElement {
  activeTab = 'appointments';

  get isAppointmentsTab() {
    return this.activeTab === 'appointments';
  }

  get isFavoritesTab() {
    return this.activeTab === 'favorites';
  }

  get isRecommendationsTab() {
    return this.activeTab === 'recommendations';
  }

  get isSettingsTab() {
    return this.activeTab === 'settings';
  }

  handleTabClick(event) {
    const tabName = event.currentTarget.dataset.tab;
    this.activeTab = tabName;
    
    // Update active button styling
    const buttons = this.template.querySelectorAll('.tab-btn');
    buttons.forEach(btn => {
      if (btn.dataset.tab === tabName) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });
  }
}