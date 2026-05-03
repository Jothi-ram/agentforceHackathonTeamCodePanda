import { LightningElement } from 'lwc';

export default class ElectroHomeApp extends LightningElement {
  currentPage = 'home';
  selectedVehicleId = null;
  showChatbot = false;

  get isHomePage() {
    return this.currentPage === 'home';
  }

  get isShowcasePage() {
    return this.currentPage === 'showcase';
  }

  get isDetailsPage() {
    return this.currentPage === 'details';
  }

  get isDealershipPage() {
    return this.currentPage === 'dealership';
  }

  get isPortalPage() {
    return this.currentPage === 'portal';
  }

  handleNavigate(event) {
    this.currentPage = event.detail.page;
    window.scrollTo(0, 0);
  }

  handleExploreVehicles() {
    this.currentPage = 'showcase';
    window.scrollTo(0, 0);
  }

  handleTestDrive() {
    this.showChatbot = true;
  }

  handleChatClose() {
    this.showChatbot = false;
  }

  handleVehicleSelected(event) {
    this.selectedVehicleId = event.detail.vehicleId;
    this.currentPage = 'details';
    window.scrollTo(0, 0);
  }

  handleBackToShowcase() {
    this.currentPage = 'showcase';
    this.selectedVehicleId = null;
    window.scrollTo(0, 0);
  }
}