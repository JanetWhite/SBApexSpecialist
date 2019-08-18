global class WarehouseCalloutServiceMock implements HttpCalloutMock{
    // implement http mock callout
        global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('[{"_id":"55d66226726b611100aaf748","replacement":false,"quantity":2,"name":"Test Product","maintenanceperiod":180,"lifespan":120,"cost":3000,"sku":"100010"}]');
        res.setStatusCode(200);
        return res;
    }
}