import { LightningElement, wire, track } from 'lwc';
import getDoctors from '@salesforce/apex/GetAppointmentsDataController.getDoctors';
import getSlots from '@salesforce/apex/GetAppointmentsDataController.getSlots';
import bookAppointment from '@salesforce/apex/CreateAppointmentController.createBooking';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class healthcareAppointmentHomePage extends LightningElement {
    @track doctors = [];
    @track timeSlots = [];
    @track selectedDoctor;
    @track selectedTimeSlot;

    sendToast(variant, message) {
        const event = new ShowToastEvent({
            message,
            variant
        });
        this.dispatchEvent(event);
    }

    @wire(getDoctors)
    wiredDoctors({ error, data }) {
        if (data) {
            this.doctors = data.map(doctor => {
                return { label: doctor.Name, value: doctor.Id };
            });
        } else if (error) {
            console.error(error);
        }
    }

    get showTimeSlots(){
        return this.timeSlots.length > 0 ? true : false;
    }

    formatDateTime(dateTimeString) {
    const date = new Date(dateTimeString);
    const options = {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: true
    };
    return new Intl.DateTimeFormat('en-US', options).format(date);
}

    handleDoctorChange(event) {
        this.selectedDoctor = event.target.value;
        getSlots({doctorId: this.selectedDoctor})
        .then(result => {
            this.timeSlots = result.map(slot => {
                return { label: this.formatDateTime(slot.Start_Time__c), value: slot.Id };
            });
        })
        .catch(error => {
            console.log('Error : ',error);
        })
    }

    handleTimeSlotChange(event) {
        this.selectedTimeSlot = event.target.value;
        console.log('Doctor Id : ', this.selectedDoctor, ' | Slot Id : ', this.selectedTimeSlot);
    }

    handleSubmit() {
        bookAppointment({ slotId: this.selectedTimeSlot, doctorId: this.selectedDoctor })
        .then(result => {
            this.sendToast(result === true ? 'success' : 'error', result === true ? 'Appointment booked successfully' : 'Appointment booking failed');
            setTimeout(() => {
                document.location.reload(true)
            }, 3000)
        })
        .catch(error => {
            this.sendToast('error', 'Appointment booking failed');
        });
    }
}