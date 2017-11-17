@isTest
public class NewRaceController_Test {
    //NOTE: In a real-world implementation, you shoud have more tests to cover 
    //for bulk processing and negative results and even permissions
    
	@isTest
    static void createNewRace() {
        
        Race__c raceIn = RaceTesting_Util.newRace(1)[0];
        
        Test.startTest();
        Race__c raceOut = NewRaceController.newRaceDB(raceIn);
        Test.stopTest();
        
        System.assertEquals(raceIn.Name, raceOut.Name);
    }
    
    @isTest
    static void updateRace() {
        
        Race__c raceIn = RaceTesting_Util.newRace(1)[0];
        insert raceIn;
        raceIn.Attended__c = true;
        
        Test.startTest();
        Race__c raceOut = RaceController.updateRaceDB(raceIn);
        Test.stopTest();
        
        System.assertEquals(true, raceOut.Attended__c);
    }    
    
}