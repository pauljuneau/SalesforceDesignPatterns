public class AccountAfterUpdateTriggerHandler extends TriggerHandlerBase {
	public override void mainEntry(TriggerParameters tp) {
		process((List<Account>)tp.newList);
		this.continuedUpdates((List<Account>)tp.newList);
	}
	
	private static void process(List<Account> listNewAccounts) {
		List<Account> acctsToBeUpdated = new List<Account>();
		for(Account acct : listNewAccounts) {
			Account newAccount = new Account();
			newAccount.Id = acct.Id;
			newAccount.Name = acct.Name + ' updated.';
			acctsToBeUpdated.add(newAccount);
			/*If method was not static, you could have used TriggerHandlerBase to perform bulk update after trigger event finishes: 
			 * this.sObjectsToUpdate.put(newAccount.Id, newAccount);
			 */
		}
		update acctsToBeUpdated; //get rid of this dml op if method is not static and using TriggerHandlerBase to perform update
	}

	private void continuedUpdates(List<Account> listNewAccounts) {
		for( Account acct : listNewAccounts) {
			Account newAccount = (Account)this.sObjectsToUpdate.get(acct.Id);
			if(newAccount == null){
				newAccount = new Account();
			}
			newAccount.Id = acct.Id;
			newAccount.Name = acct.Name + ' continuedUpdates.';
			this.sObjectsToUpdate.put(acct.Id,newAccount);
		}
	}
	
	public override void inProgressEntry(TriggerParameters tp) {
		System.debug('This is an example for reentrant code...');
	}
}