({
	getRaces : function(component) {
		var action = component.get('c.getRacesDB');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                component.set("v.races", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);

	},
    addToRaces: function(component, event) {
        var race = event.getParam('race');
        var races =component.get("v.races");
        races.unshift(race);
        component.set("v.races", races);
        
        
    },
    
    
})