# SalesforceDesignPatterns


## Table of Contents:

### Lightning Design System:
* Example: Installed unmanaged package - Race Tracker App by https://github.com/saramorgan
  * To see what is included in package: Setup > search "Installed Packages" > Click RaceTrackerApp link> Click View Components button
  * My Domain had to be deployed to allow lightning app usage.
  
### Trigger architecture:
* Installed managed package provided by Hari Krishnan: https://krishhari.wordpress.com/2013/07/22/an-architecture-framework-to-handle-triggers-in-the-force-com-platform/
  * Managed Package install link: https://domain.force.com/packagingSetupUI/ipLanding.app?apvId=04tU00000005VdB
  * Includes dummy implementation for handling trigger events on the Account object
  * See entry to trigger framework on [AccountTrigger.trigger]( src/triggers/AccountTrigger.trigger)
  
### Dan Appleman's, "Advanced Apex Programming", 3rd Edition:
* Deployed 3rd edition [metadata package of Dan Appleman's code](http://advancedapex.com/samplecode/) via Force.com ANT migration tool
  * [Defensive Programming to Workflow Rule Field Updates]( src/classes/TriggersExample.cls)
  * Centralized Asynchronous Framework (Chaining Queueable Apex plus incorporating Scheduled Apex)
	#### Description: 
	Centralized Asynchronous Framework includes 2 examples.
	1. Callout example to translate SoluntionNote field into Spanish on the standard Solution object
		* Example entry point: SolutionTrigger1
	2. Concurrency example to reproduce DML Lock error, "UNABLE_TO_LOCK_ROW", and recover from it by using async framework
		* Example entry point: Concurrency1
	#### Package contents: 
	* Objects:
		* [Solution]( src/objects/Solution.object)
		* [AsyncRequest__c]( src/objects/AsyncRequest__c.object)
	* Custom Setting:
		* [AppConfig]( src/objects/AppConfig__c.object)
	* Triggers: 
		* [SolutionTrigger1]( src/triggers/SolutionTrigger1.trigger)
		* [OnAsyncRequestInsert]( src/triggers/OnAsyncRequestInsert.trigger)
	* Classes:
		* [GoingAsync1]( src/classes/GoingAsync1.cls)
		* [GoingAsync4]( src/classes/GoingAsync4.cls)
		* [AppConfigSupport]( src/classes/AppConfigSupport.cls)
		* [ScheduledDispatcher2]( src/classes/ScheduledDispatcher2.cls)
		* [GoingAsync5]( src/classes/GoingAsync5.cls)
		* [Concurrency1]( src/classes/Concurrency1.cls)
