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
  * [Defensive Programming to Workflow Rule Field Updates]( src/classes/TriggerExample.cls)
