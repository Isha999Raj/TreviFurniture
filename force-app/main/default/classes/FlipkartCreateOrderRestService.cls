/**
 * Author: Isha Raaz
 */

global class FlipkartCreateOrderRestService {
    public static void postShipment(String shipmentId, String locationId, Datetime timestamp, List<OrderItem> orderItems) {
        String endpoint = 'https://example.com/api/flipkart/shipment';
        
        Map<String, Object> payload = new Map<String, Object>();
        payload.put('shipmentId', shipmentId);
        payload.put('eventType', 'shipment_created');
        payload.put('locationId', locationId);
        payload.put('source', 'flipkart');
        payload.put('timestamp', timestamp);
        
        Map<String, Object> attributes = new Map<String, Object>();
        attributes.put('dispatchByDate', Datetime.now());
        attributes.put('dispatchAfterDate', Datetime.now());
        attributes.put('hold', false);
        attributes.put('mps', false);
        attributes.put('packagingPolicy', 'GREEN_PACKAGE');
        attributes.put('orderItems', orderItems);
        
        List<Map<String, Object>> forms = new List<Map<String, Object>>();
        Map<String, Object> form = new Map<String, Object>();
        form.put('name', 'shipping_label');
        form.put('link', 'https://example.com/label.pdf');
        form.put('automated', true);
        forms.add(form);
        
        attributes.put('forms', forms);
        
        List<Map<String, Object>> subShipments = new List<Map<String, Object>>();
        Map<String, Object> subShipment = new Map<String, Object>();
        subShipment.put('subShipmentId', 'sub_shipment_123');
        
        List<Map<String, Object>> packages = new List<Map<String, Object>>();
        Map<String, Object> packageData = new Map<String, Object>();
        packageData.put('packageId', 'pkg_123');
        packageData.put('packageTitle', 'Package 1');
        packageData.put('packageSku', 'pkg_1');
        
        Map<String, Object> dimensions = new Map<String, Object>();
        dimensions.put('length', 10);
        dimensions.put('breadth', 20);
        dimensions.put('height', 30);
        dimensions.put('weight', 1);
        
        packageData.put('dimensions', dimensions);
        packages.add(packageData);
        
        subShipment.put('packages', packages);
        subShipments.add(subShipment);
        
        attributes.put('subShipments', subShipments);
        payload.put('attributes', attributes);
        system.debug('payload--->'+payload);
            
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        system.debug('JSON.serialize(payload)--->'+JSON.serialize(payload));
        req.setBody(JSON.serialize(payload));
        
        Http http = new Http();
        HttpResponse res = http.send(req);
        
        System.debug(res.getBody());
    }
    
    /*public class OrderItem {
        public String fsn;
        public Integer quantity;
        public String orderId;
        public String orderItemId;
        public String listingId;
        public String hsn;
        public String sku;
        public String title;
        public String paymentType;
        public String cancellationGroupId;
        public Boolean isReplacement;
        public PriceComponents priceComponents;
        public Datetime orderDate;
        public String status;
        public List<String> packageIds;
    }
    
    public class PriceComponents {
        public Double sellingPrice;
        public Double totalPrice;
        public Double shippingCharge;
        public Double customerPrice;
        public Double flipkartDiscount;
    }
*/
}