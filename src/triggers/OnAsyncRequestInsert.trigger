trigger OnAsyncRequestInsert on AsyncRequest__c (after insert) {
	if(Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0)
		try
		{
			GoingAsync4.enqueueGoingAsync4(null);
		} catch(Exception ex)
		{
			// Ignore for now	
		}
	/**
	* Optimization idea: 
	* Create update trigger on AsyncRequest__c for resetting Error__c field and queue up Apex class at that time.
	**/
}