import { LightningElement } from 'lwc';

export default class ElectroAgentforceChat extends LightningElement {
  customerName = '';
  customerEmail = '';
  customerPhone = '';
  preferredDate = '';
  preferredTime = '';
  formSubmitted = false;
  bookingComplete = false;
  showForm = true;

  get showInputForm() {
    return !this.bookingComplete;
  }

  get showFormFields() {
    return !this.formSubmitted;
  }

  handleNameChange(event) {
    this.customerName = event.target.value;
  }

  handleEmailChange(event) {
    this.customerEmail = event.target.value;
  }

  handlePhoneChange(event) {
    this.customerPhone = event.target.value;
  }

  handleDateChange(event) {
    this.preferredDate = event.target.value;
  }

  handleTimeChange(event) {
    this.preferredTime = event.target.value;
  }

  handleSubmit() {
    // Basic validation
    if (!this.customerName || !this.customerEmail || !this.customerPhone || !this.preferredDate || !this.preferredTime) {
      alert('Please fill in all required fields');
      return;
    }

    // Email validation
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(this.customerEmail)) {
      alert('Please enter a valid email address');
      return;
    }

    // Mark form as submitted
    this.formSubmitted = true;
    this.bookingComplete = true;

    // In a real scenario, here you would call an Apex method to create a TestDriveRecord
    console.log('Test Drive Booking:', {
      name: this.customerName,
      email: this.customerEmail,
      phone: this.customerPhone,
      date: this.preferredDate,
      time: this.preferredTime
    });

    // Auto-close after 3 seconds
    setTimeout(() => {
      this.handleClose();
    }, 3000);
  }

  handleClose() {
    this.dispatchEvent(new CustomEvent('close'));
  }
}