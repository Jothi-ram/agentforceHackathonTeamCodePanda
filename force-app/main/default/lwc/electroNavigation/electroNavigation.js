import { LightningElement, api } from 'lwc';

export default class ElectroNavigation extends LightningElement {
  @api currentPage = 'home';
  
  showMobileMenu = false;
  isMobile = false;

  connectedCallback() {
    this.checkMobileSize();
    window.addEventListener('resize', this.handleResize.bind(this));
  }

  disconnectedCallback() {
    window.removeEventListener('resize', this.handleResize.bind(this));
  }

  handleResize() {
    this.checkMobileSize();
  }

  checkMobileSize() {
    this.isMobile = window.innerWidth < 768;
  }

  get activeClass() {
    return this.currentPage === 'home' ? 'active' : '';
  }

  get showDesktopMenu() {
    return !this.isMobile;
  }

  get showMobileToggle() {
    return this.isMobile;
  }

  get showMobileMenuPanel() {
    return this.showMobileMenu && this.isMobile;
  }

  handleNavClick(event) {
    const page = event.currentTarget.dataset.page;
    this.currentPage = page;
    this.showMobileMenu = false;

    this.dispatchEvent(new CustomEvent('navigate', {
      detail: { page }
    }));
  }

  toggleMobileMenu() {
    this.showMobileMenu = !this.showMobileMenu;
  }
}