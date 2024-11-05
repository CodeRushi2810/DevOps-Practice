public class CreateAppointmentController {
	@AuraEnabled(cacheable=false)
    public static boolean createBooking(Id slotId, Id doctorId){
        
        String userId = UserInfo.getUserId();
        String patientId = '';
        
        Appointment__c appointment = new Appointment__c();
        appointment.Doctor__c = doctorId;
        appointment.Slot__c = slotId;
        if([SELECT Id, Name FROM Patient__c WHERE User__c =: userId].size() > 0){
            patientId = [SELECT Id FROM Patient__c WHERE User__c =: userId].Id;
            appointment.Patient__c = patientId;
        }else{
            Patient__c patient = new Patient__c();
            patient.Name = [SELECT Name FROM User WHERE Id =: userId].Name;
            patient.User__c = userId;
            patient.Email__c = [SELECT Email FROM User WHERE Id =: userId].Email;
            insert patient;
            appointment.Patient__c = [SELECT Id FROM Patient__c WHERE User__c =: userId].Id;
        }
        try {
            Database.SaveResult result = Database.insert(appointment);
            if (result.isSuccess()) {
                Slot__c slot = [SELECT Id, Status__c FROM Slot__c WHERE Id =: slotId];
                slot.Status__c = 'Booked';
                update slot;
                return true;
            } else {
                for (Database.Error error : result.getErrors()) {
                    System.debug('Error message: ' + error.getMessage());
                }
                return false;
            }
        } catch (Exception e) {
            System.debug('An error occurred: ' + e.getMessage());
            return false;
        }
    }
}