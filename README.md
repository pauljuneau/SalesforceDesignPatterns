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
  * **_Centralized Asynchronous Framework_** (Chaining Queueable Apex plus incorporating Scheduled Apex)
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
  * **_Diagnostic Instrumentation and Centralized Exception Handling_** 
  	#### Description:
  	This framework allows us to capture stack trace info even in a managed package along with logging exceptions in a custom object.
  	It captures and stores large amounts of data compared to standard debug logs. 
  	All users are monitored compared to just one with debug logs.
  	Diagnostic Instrumentation and Centralized Exception Handling example was done for 2 [Opportunity After Update Trigger Events]( src/triggers/OnOpportunity3.trigger). 
  	#### Package contents:
  	* Objects:
		* [DebugInfo__c]( src/objects/DebugInfo__c.object)
	* Custom Setting:
		* [AppConfig]( src/objects/AppConfig__c.object)
	* Triggers: 
		* [OnOpportunity3]( src/triggers/OnOpportunity3.trigger)
	* Classes:
		* [DiagnosticsMain]( src/classes/DiagnosticsMain.cls)
		* [DiagnosticsInstrumentation]( src/classes/DiagnosticsInstrumentation.cls)
		* [AppConfigSupport]( src/classes/AppConfigSupport.cls)
		* [DiagnosticsTriggers1]( src/classes/DiagnosticsTriggers1.cls)
		* [DiagnosticsTriggers2]( src/classes/DiagnosticsTriggers2.cls)
		* [TestDiagnostics1]( src/classes/TestDiagnostics1.cls)
		* [TestDiagnostics2]( src/classes/TestDiagnostics2.cls)