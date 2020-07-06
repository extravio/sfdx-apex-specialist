public with sharing class WarehouseCalloutService {
    //public WarehouseCalloutService() {
    //}

    @future(callout=true)
    public static void runWarehouseEquipmentSync() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            // Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            // Cast the values in the 'animals' key as a list
            List<WarehouseEquipment> eqts = (List<WarehouseEquipment>)JSON.deserialize(response.getBody(), List<WarehouseEquipment>.class);

            // System.debug('Received the following pieces of equipment:');
            // for (WarehouseEquipment eqt: eqts) {
            //    System.debug(eqt);
            // }

            EquipmentHelper.importEquipment(eqts);
        }
    }
}
