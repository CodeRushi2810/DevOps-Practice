public class GetAppointmentsDataController {
	@AuraEnabled(cacheable=true)
    public static List<Doctor__c> getDoctors(){
        return [SELECT Id, Name FROM Doctor__c];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Slot__c> getSlots(Id doctorId){
        return [SELECT Id, Start_Time__c FROM Slot__c WHERE Doctor__c =: doctorId AND Status__c = 'Available'];
    }
}