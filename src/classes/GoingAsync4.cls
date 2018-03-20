public without sharing class GoingAsync4
	implements queueable, Database.AllowsCallouts {

	// Version of execute at the end of chapter 7
	/*
 	public void execute(QueueableContext context)
    {
    	if(!AppConfigSupport.appEnabled) return; // On/off switch
    	List<AsyncRequest__c> requests;
    	try
    	{
	    	requests = [Select ID, AsyncType__c, Params__c 
	    		from AsyncRequest__c 
	    		where Error__c = false And
	    		CreatedById = :UserInfo.getUserId() 
	    		Limit 1 for update];
    	}
    	catch(Exception ex) { return; }
    	if(requests.size()==0 ) return;
    	
    	AsyncRequest__c currentRequest = requests[0];
    	
    	try
    	{
    		if(currentRequest.AsyncType__c=='Translate Solution') 
    			translate(currentRequest);
    		
    		// Add more here
    		
    		delete currentRequest;
    		// Optional
    		database.emptyRecycleBin(new List<ID>{currentRequest.id}); 
    		
    	}
    	catch(Exception ex)
    	{
    		currentRequest.Error__c = true;
    		currentRequest.Error_Message__c = ex.getMessage();
    		update currentRequest;
    	}

    	List<AsyncRequest__c> moreRequests = [Select ID, AsyncType__c, Params__c 
    		from AsyncRequest__c 
    		where Error__c = false 
    		and ID <> :currentRequest.id 
    		and	CreatedById = :UserInfo.getUserId() 
    		Limit 1 ];
    	
    	if(moreRequests.size()==0) return;
    	
		try
		{
			enqueGoingAsync4(context.getJobId());
		}
		catch(Exception ex)
		{
			tryToQueue();
		}
		
    }
    */

	// Version of execute at the end of chapter 8
 	public void execute(QueueableContext context)
    {
    	if(!AppConfigSupport.appEnabled) return; // On/off switch
    	List<AsyncRequest__c> requests;
    	try
    	{
	    	/**
            * Filters out async requests that have resulted in errors
            * Filters by CreatedById to enforce 'with sharing' in class to enforce sharing rules of whoever requested async action.
            * 'for update' qualifier makes sure no other instance of this class can access the record while processing it. Concurrency Protection... Pessimistic Record Locking, Not Optimistic Record Locking
            *
            * Optimization Idea:
            *   Add StartTime__c field to AsyncRequest__c object and modify filter so it returned only AsyncRequest__c objects whose start time has been met.
            *   Use Scheduler Apex to make sure job is queued. Refer to SchedulerDispatcher2.cls
            **/
            requests = [Select ID, AsyncType__c, Params__c,
	    		NewAmount__c, OriginalAmount__c, TargetOpportunity__c 
	    		from AsyncRequest__c 
	    		where Error__c = false And
	    		CreatedById = :UserInfo.getUserId() 
	    		Limit 1 for update];
    	}
    	catch(Exception ex) { return; }
    	if(requests.size()==0 ) return;
    	
    	AsyncRequest__c currentRequest = requests[0];
    	
    	try
    	{
    		/** 
            * WARNING!!!!
            * UNABLE TO CATCH LIMIT EXCEPTIONS! 
            *  If an Asynchronous request for a particular AsyncRequest__c object causes a limit exception, 
            *  the entire framework can get stuck as it tries over and over to process that request.
            *  WORKAROUND 1: Use limit functions to check usage during each supporting function then process requests. 
            *                If approaching limit, throw an exception to abort operation and let the framework flag AsyncRequest__c object as an error. 
            *  WORKAROUND 2: Create initial check method here to first query the AsyncApexJob object for classes that have a JobType of Queuable and that failed for the current user.
            *                If most recent job was a failure, especially if you see more than one failed job of this type, then it's most likely the current record that is consistently failing.
            *                Mark AsyncRequest__c object as an error.
            **/
            if(currentRequest.AsyncType__c=='Translate Solution') 
    			translate(currentRequest);
    		
    		if(currentRequest.AsyncType__c=='Amount Update') 
    			updateAmounts(currentRequest);

    		// Add more here
    		
    		delete currentRequest;
    		// Optional
    		database.emptyRecycleBin(new List<ID>{currentRequest.id}); 
    		
    	}
    	catch(Exception ex)
    	{
    		currentRequest.Error__c = true;
    		currentRequest.Error_Message__c = ex.getMessage();
    		update currentRequest;
    	}

        /**
        * Query excludes current request and does not use 'for update' to lock record since 
        * the only concern is to detect if there is another record pending.
        **/
    	List<AsyncRequest__c> moreRequests = [Select ID, AsyncType__c, Params__c 
    		from AsyncRequest__c 
    		where Error__c = false 
    		and ID <> :currentRequest.id 
    		and	CreatedById = :UserInfo.getUserId() 
    		Limit 1 ];
    	
    	if(moreRequests.size()==0) return;
    	
		try
		{
			/*
            * Typically fails to enqueue the class again due to chaining limit exception or because you've performed a callout in the current context.
            */
            enqueueGoingAsync4(context.getJobId());
		}
		catch(Exception ex)
		{
            /**
            * Back up mechanism for enqueueing this class.
            * In Queable Apex, you can make a future, batch, or scheduled apex calls
            **/
			tryToQueue();
		}
		
    }

	public static void enqueueGoingAsync4(ID currentJobId)
	{
        /**
        * Optimization idea - for case where update trigger on AsyncRequest__c has been created to detect clearing of error field, then
        * modify query to accept LastModifiedById so that it runs with more privileges 
        * i.e. => and (CreatedById = :userinfo.getUserID() OR LastModifiedById = :userinfo.getUserID())
        **/
		List<AsyncApexJob> jobs = [Select ID, Status, ExtendedStatus from AsyncApexJob 
					where JobType = 'Queueable' And (status='Queued'  Or Status='Holding') 
					and CreatedById = :userinfo.getUserID() and 
					ApexClass.Name='GoingAsync4' and ID!= :currentJobId Limit 1 ];
		if(jobs.size()==1) return;	// Already have one queued that isn't this one.
		
		system.enqueueJob(new GoingAsync4());
	}

    
    @future
    private static void tryToQueue()
    {
    	if(!AppConfigSupport.appEnabled) return; // On/off switch
    	try
    	{
			if(Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0)
				enqueueGoingAsync4(null);
    	}
    	catch(Exception ex)
    	{
    		// Wait for someone else to make a request...
    		// Or maybe use scheduled Apex? Refer to ScheduledDispatcher2.cls
    	}
    }
    
    public void translate(AsyncRequest__c request)
    {
    	Integer allowedCallouts = 
    	Limits.getLimitCallouts() - Limits.getCallouts();
		if(allowedCallouts<=0) return;
		
		List<ID> idsAfterSplit = request.Params__c.split(',');
		
		List<Solution> solutionsToUpdate = 
			[SELECT ID, SolutionNote, SolutionSpanish__c 
			from Solution 
			where ID in :idsAfterSplit 
			LIMIT :allowedCallouts];
		for(Solution sl: solutionsToUpdate)
		{
			sl.SolutionSpanish__c = 
				SimulatedTranslator.translate(sl.SolutionNote);
			sl.TranslationPending__c = false;
		}
		update solutionsToUpdate;
    }

	public void updateAmounts(AsyncRequest__c request)
	{
        //Not bulkified on purpose for readability.  
        //Can bulkify by creating a separate list of opp Ids to query, do the query, process one at a time, and doing a final update.
		List<Opportunity> ops = 
			[Select ID, Amount from Opportunity 
			 where ID = :request.TargetOpportunity__c for update];
		if(ops.size()==0) return; // The op may have been deleted 
		Opportunity op = ops[0];
		
		// Implement update scneario here

		// Option #1
		//op.Amount = request.NewAmount__c;

		// Option #2
		op.Amount += (request.NewAmount__c - 
						request.OriginalAmount__c);

		// Option #3
		if(op.Amount!= request.OriginalAmount__c)
		{
			// Concurrency error - throw an exception here
			throw new AsyncUpdateException(
				'Amount on opportunity update has changed');
		}

		try
		{
			update op;
		}
		catch(DmlException dex)
		{
			if(dex.getDmlType(0) == StatusCode.UNABLE_TO_LOCK_ROW)
			{
				insert request.clone();
				return;
			}
			throw dex;
		}
		// Any other exception will not be caught

	}

	public class AsyncUpdateException extends Exception {}

}