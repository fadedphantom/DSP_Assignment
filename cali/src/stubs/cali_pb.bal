import ballerina/grpc;

public type CaliRecordMgmtBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function addRecord(recordInfo req, grpc:Headers? headers = ()) returns ([string, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.CaliRecordMgmt/addRecord", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    public remote function readRecord(string req, grpc:Headers? headers = ()) returns ([string, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.CaliRecordMgmt/readRecord", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    public remote function updateRecord(recordInfo req, grpc:Headers? headers = ()) returns ([string, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.CaliRecordMgmt/updateRecord", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

    public remote function deleteRecord(string req, grpc:Headers? headers = ()) returns ([string, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("grpc_service.CaliRecordMgmt/deleteRecord", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        return [result.toString(), resHeaders];
    }

};

public type CaliRecordMgmtClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function addRecord(recordInfo req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.CaliRecordMgmt/addRecord", req, msgListener, headers);
    }

    public remote function readRecord(string req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.CaliRecordMgmt/readRecord", req, msgListener, headers);
    }

    public remote function updateRecord(recordInfo req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.CaliRecordMgmt/updateRecord", req, msgListener, headers);
    }

    public remote function deleteRecord(string req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("grpc_service.CaliRecordMgmt/deleteRecord", req, msgListener, headers);
    }

};

public type recordInfo record {|
    string date = "";
    string Artists = "";
    string description = "";
    string band = "";
    string songs = "";
    string Id = "";
    
|};



const string ROOT_DESCRIPTOR = "0A0A63616C692E70726F746F120C677270635F736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F2296010A0A7265636F7264496E666F12120A046461746518012001280952046461746512180A074172746973747318022001280952074172746973747312200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12120A0462616E64180420012809520462616E6412140A05736F6E67731805200128095205736F6E6773120E0A0249641806200128095202496432B3020A0E43616C695265636F72644D676D7412430A096164645265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512480A0A726561645265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512460A0C7570646174655265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124A0A0C64656C6574655265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "cali.proto":"0A0A63616C692E70726F746F120C677270635F736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F2296010A0A7265636F7264496E666F12120A046461746518012001280952046461746512180A074172746973747318022001280952074172746973747312200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12120A0462616E64180420012809520462616E6412140A05736F6E67731805200128095205736F6E6773120E0A0249641806200128095202496432B3020A0E43616C695265636F72644D676D7412430A096164645265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512480A0A726561645265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512460A0C7570646174655265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124A0A0C64656C6574655265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"
        
    };
}

