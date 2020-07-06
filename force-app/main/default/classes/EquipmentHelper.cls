public with sharing class EquipmentHelper {
    public EquipmentHelper() {
    }

    public static void importEquipment(List<WarehouseEquipment> objs) {

        List<Product2> eqts = new List<Product2>();
        Product2 eq;
        for (WarehouseEquipment obj: objs) {
            eq = EquipmentHelper.objToEquipment(obj);
            eqts.add(eq);
        }
        try {
            upsert eqts Product2.Fields.Warehouse_SKU__c;
        } catch (DmlException e) {
            System.debug('A DML exception has occurred: ' + e.getMessage());
        }
    }

    public static Product2 objToEquipment(WarehouseEquipment obj) {
        
        Product2 eq = new Product2(
            Replacement_Part__c = obj.replacement,
            Cost__c = obj.cost,
            Current_Inventory__c = obj.quantity,
            Lifespan_Months__c = obj.lifespan,
            Maintenance_Cycle__c = obj.maintenanceperiod,
            Name = obj.name,
            Warehouse_SKU__c = obj.sku
        );
        return eq;
    }
}
