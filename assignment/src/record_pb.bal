import ballerina/grpc;

public type greetingBlockingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function replyWrite(Record req, grpc:Headers? headers = ()) returns ([Identity, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyWrite", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Identity>result, resHeaders];
        
    }

    public remote function replyUpdate(updateRequest req, grpc:Headers? headers = ()) returns ([Identity, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyUpdate", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Identity>result, resHeaders];
        
    }

    public remote function replyRead_1(Key req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyRead_1", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

    public remote function replyRead_2(Identity req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyRead_2", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

    public remote function replyRead_3(Artist req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyRead_3", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

    public remote function replyRead_4(Band req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyRead_4", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

    public remote function replyRead_5(Songs req, grpc:Headers? headers = ()) returns ([Record, grpc:Headers]|grpc:Error) {
        
        var payload = check self.grpcClient->blockingExecute("greeting/replyRead_5", req, headers);
        grpc:Headers resHeaders = new;
        anydata result = ();
        [result, resHeaders] = payload;
        
        return [<Record>result, resHeaders];
        
    }

};

public type greetingClient client object {

    *grpc:AbstractClientEndpoint;

    private grpc:Client grpcClient;

    public function __init(string url, grpc:ClientConfiguration? config = ()) {
        // initialize client endpoint.
        self.grpcClient = new(url, config);
        checkpanic self.grpcClient.initStub(self, "non-blocking", ROOT_DESCRIPTOR, getDescriptorMap());
    }

    public remote function replyWrite(Record req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyWrite", req, msgListener, headers);
    }

    public remote function replyUpdate(updateRequest req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyUpdate", req, msgListener, headers);
    }

    public remote function replyRead_1(Key req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyRead_1", req, msgListener, headers);
    }

    public remote function replyRead_2(Identity req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyRead_2", req, msgListener, headers);
    }

    public remote function replyRead_3(Artist req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyRead_3", req, msgListener, headers);
    }

    public remote function replyRead_4(Band req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyRead_4", req, msgListener, headers);
    }

    public remote function replyRead_5(Songs req, service msgListener, grpc:Headers? headers = ()) returns (grpc:Error?) {
        
        return self.grpcClient->nonBlockingExecute("greeting/replyRead_5", req, msgListener, headers);
    }

};

public type Artist record {|
    string name = "";
    string member = "";
    
|};


public type Band record {|
    string bandName = "";
    
|};


public type Songs record {|
    string title = "";
    string genre = "";
    string platform = "";
    
|};


public type Record record {|
    string recordName = "";
    string date = "";
    Artist? artists = ();
    Band? band = ();
    Songs? song = ();
    
|};


public type Identity record {|
    string hash_Key = "";
    int versionNum = 0;
    
|};


public type updateRequest record {|
    string hash_Key = "";
    int versionNum = 0;
    string recordName = "";
    string date = "";
    Artist? artists = ();
    Band? band = ();
    Songs? song = ();
    
|};


public type Key record {|
    string hash_Key = "";
    
|};



const string ROOT_DESCRIPTOR = "0A0C7265636F72642E70726F746F22340A0641727469737412120A046E616D6518012001280952046E616D6512160A066D656D62657218022001280952066D656D62657222220A0442616E64121A0A0862616E644E616D65180120012809520862616E644E616D65224F0A05536F6E677312140A057469746C6518012001280952057469746C6512140A0567656E7265180220012809520567656E7265121A0A08706C6174666F726D1803200128095208706C6174666F726D2296010A065265636F7264121E0A0A7265636F72644E616D65180120012809520A7265636F72644E616D6512120A046461746518022001280952046461746512210A076172746973747318032001280B32072E41727469737452076172746973747312190A0462616E6418042001280B32052E42616E64520462616E64121A0A04736F6E6718052001280B32062E536F6E67735204736F6E6722450A084964656E7469747912190A08686173685F4B65791801200128095207686173684B6579121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D22D8010A0D7570646174655265717565737412190A08686173685F4B65791801200128095207686173684B6579121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D121E0A0A7265636F72644E616D65180320012809520A7265636F72644E616D6512120A046461746518042001280952046461746512210A076172746973747318052001280B32072E41727469737452076172746973747312190A0462616E6418062001280B32052E42616E64520462616E64121A0A04736F6E6718072001280B32062E536F6E67735204736F6E6722200A034B657912190A08686173685F4B65791801200128095207686173684B657932F7010A086772656574696E6712200A0A7265706C79577269746512072E5265636F72641A092E4964656E7469747912280A0B7265706C79557064617465120E2E757064617465526571756573741A092E4964656E74697479121C0A0B7265706C79526561645F3112042E4B65791A072E5265636F726412210A0B7265706C79526561645F3212092E4964656E746974791A072E5265636F7264121F0A0B7265706C79526561645F3312072E4172746973741A072E5265636F7264121D0A0B7265706C79526561645F3412052E42616E641A072E5265636F7264121E0A0B7265706C79526561645F3512062E536F6E67731A072E5265636F7264620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "record.proto":"0A0C7265636F72642E70726F746F22340A0641727469737412120A046E616D6518012001280952046E616D6512160A066D656D62657218022001280952066D656D62657222220A0442616E64121A0A0862616E644E616D65180120012809520862616E644E616D65224F0A05536F6E677312140A057469746C6518012001280952057469746C6512140A0567656E7265180220012809520567656E7265121A0A08706C6174666F726D1803200128095208706C6174666F726D2296010A065265636F7264121E0A0A7265636F72644E616D65180120012809520A7265636F72644E616D6512120A046461746518022001280952046461746512210A076172746973747318032001280B32072E41727469737452076172746973747312190A0462616E6418042001280B32052E42616E64520462616E64121A0A04736F6E6718052001280B32062E536F6E67735204736F6E6722450A084964656E7469747912190A08686173685F4B65791801200128095207686173684B6579121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D22D8010A0D7570646174655265717565737412190A08686173685F4B65791801200128095207686173684B6579121E0A0A76657273696F6E4E756D180220012805520A76657273696F6E4E756D121E0A0A7265636F72644E616D65180320012809520A7265636F72644E616D6512120A046461746518042001280952046461746512210A076172746973747318052001280B32072E41727469737452076172746973747312190A0462616E6418062001280B32052E42616E64520462616E64121A0A04736F6E6718072001280B32062E536F6E67735204736F6E6722200A034B657912190A08686173685F4B65791801200128095207686173684B657932F7010A086772656574696E6712200A0A7265706C79577269746512072E5265636F72641A092E4964656E7469747912280A0B7265706C79557064617465120E2E757064617465526571756573741A092E4964656E74697479121C0A0B7265706C79526561645F3112042E4B65791A072E5265636F726412210A0B7265706C79526561645F3212092E4964656E746974791A072E5265636F7264121F0A0B7265706C79526561645F3312072E4172746973741A072E5265636F7264121D0A0B7265706C79526561645F3412052E42616E641A072E5265636F7264121E0A0B7265706C79526561645F3512062E536F6E67731A072E5265636F7264620670726F746F33"
        
    };
}

