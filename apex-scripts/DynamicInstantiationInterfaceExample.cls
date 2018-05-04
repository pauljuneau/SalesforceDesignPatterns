//Create the following in org.
//public class Car implements IVehicle {
//    public Long getMaxSpeed() { return 100; }    
//    public String getType() { return 'Sedan'; }
//}


public class CustomerImplInvocationClass {

    public void invokeCustomImpl() {
        
        // Get the Type corresponding to the class name
        Type obType = Type.forName('Car');
        
        // Instantiate the type.
        // The type of the instantiated object 
        //   is the interface.
        IVehicle honda = (obType == null) ? null : (IVehicle)obType.newInstance();
        
        // Call the methods that have a custom implementation
        System.debug('Max speed: ' + honda.getMaxSpeed());
        System.debug('Vehicle type: ' + honda.getType());      
    }
}


CustomerImplInvocationClass dynamicTest = new CustomerImplInvocationClass();
dynamicTest.invokeCustomImpl();