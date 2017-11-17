@isTest
public class RaceTesting_Util {
    public static List<Race__c> newRace(Integer num) {
        
        DateTime dt = datetime.newInstance(2016, 04, 22);
        List<Race__c> races = new List<Race__c>();
        
        for (Integer i=0; i < num; i++) {
            Race__c race = new Race__c(name='New Race' + i, Type__c='5K', 
                                   Location__c='Test Location', 
                                   attended__c=false,
								    DateTime__c=dt);
            races.add(race);
        }
        
        return races;
 
    }
}