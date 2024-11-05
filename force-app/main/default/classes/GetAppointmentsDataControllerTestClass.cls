@isTest
public class GetAppointmentsDataControllerTestClass {
    @testSetup
    static void setupTestData() {
        // Create test doctors
        List<Doctor__c> doctors = new List<Doctor__c>();
        for (Integer i = 0; i < 3; i++) {
            doctors.add(new Doctor__c(Name = 'Test Doctor ' + i));
        }
        insert doctors;

        // Create test slots
        List<Slot__c> slots = new List<Slot__c>();
        for (Doctor__c doctor : doctors) {
            slots.add(new Slot__c(Start_Time__c = DateTime.now().addDays(1), Doctor__c = doctor.Id, Status__c = 'Available'));
            slots.add(new Slot__c(Start_Time__c = DateTime.now().addDays(2), Doctor__c = doctor.Id, Status__c = 'Booked'));
        }
        insert slots;
    }

    @isTest
    static void testGetDoctors() {
        // Call the getDoctors method
        Test.startTest();
        List<Doctor__c> doctors = GetAppointmentsDataController.getDoctors();
        Test.stopTest();
        
        // Assert the results
        System.assertNotEquals(null, doctors, 'Doctors list should not be null');
        System.assertEquals(3, doctors.size(), 'There should be 3 doctors');
    }

    @isTest
    static void testGetSlots() {
        // Get an existing doctor Id
        Id doctorId = [SELECT Id FROM Doctor__c LIMIT 1].Id;

        // Call the getSlots method
        Test.startTest();
        List<Slot__c> slots = GetAppointmentsDataController.getSlots(doctorId);
        Test.stopTest();
        
        // Assert the results
        System.assertNotEquals(null, slots, 'Slots list should not be null');
        System.assertEquals(1, slots.size(), 'There should be 1 available slot for the doctor');
        System.assertEquals('Available', slots[0].Status__c, 'Slot status should be Available');
        System.assertEquals(doctorId, slots[0].Doctor__c, 'Slot should be for the correct doctor');
    }
}