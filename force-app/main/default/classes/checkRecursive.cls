public with sharing class checkRecursive {

    // https://developer.salesforce.com/forums/?id=906F0000000Qtw4IAC
    
    // public checkRecursive() {

    // }
    private static boolean run = true;

    public static boolean runOnce(){
        if(run){
            run=false;
            return true;
        } else {
            return run;
        }
    }
}
