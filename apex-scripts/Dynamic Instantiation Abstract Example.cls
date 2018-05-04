//Create the following interface and class in org.
//public abstract class Car {
//    public abstract Long getMaxSpeed();
//    public virtual String getType() {
//        return 'Sedan';
//    }
//}

//public class Honda extends Car{
//    public override Long getMaxSpeed(){
//        return 100; 
//    }

//    public override String getType(){
//        return 'suv';
//    }
//}


public class CustomerImplInvocationClass {

    public void invokeCustomImpl() {
        
        // Get the Type corresponding to the class name
        Type obType = Type.forName('Honda');
        
        // Instantiate the type.
        // The type of the instantiated object 
        //   is the interface.
        Car hondaCRV = (obType == null) ? null : (Car)obType.newInstance();
        
        // Call the methods that have a custom implementation
        System.debug('Max speed: ' + hondaCRV.getMaxSpeed());
        System.debug('Vehicle type: ' + hondaCRV.getType());      
    }
}


CustomerImplInvocationClass dynamicTest = new CustomerImplInvocationClass();
dynamicTest.invokeCustomImpl();



