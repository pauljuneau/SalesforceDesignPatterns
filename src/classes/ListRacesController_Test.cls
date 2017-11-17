@isTest
public class ListRacesController_Test {
	//NOTE: In a real-world implementation, you shoud have more tests to cover 
    //for bulk processing and negative results and even permissions
    
    @isTest
    static void getAllRaces() {
        Race__c raceIn = RaceTesting_Util.newRace(1)[0];
        insert raceIn;
        
        Test.startTest();
        List<Race__c> races = ListRacesController.getRacesDB();
        Test.stopTest();
        
        System.assertEquals(1, races.size());
    }
}