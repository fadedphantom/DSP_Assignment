import ballerina/grpc;
import ballerina/log;
import ballerina/io;
import ballerina/crypto;
import ballerina/file;

listener grpc:Listener ep = new (9090);

@tainted map<recordInfo> recordMap = {};

service CaliRecordMgmt on ep {

//Function to write to JSON record
    resource function addRecord(grpc:Caller caller, recordInfo recordReq) {

        json|error j1 = json.constructFrom(recordReq);
        //Type casts JSON|error to JSON for crypto
        json recordDetails = <json>j1;
        string ID = IDhash(recordDetails);

        string filePath = "./src/"+ID+".json";

        var wResult = write(recordDetails, filePath);
        if (wResult is error) {
        log:printError("Error occurred while writing json: ", wResult);
        }

        // Create response message.
        string payload = "Status : Record created; Record ID : " + ID + "/n Version Number: ";

        // Send response to the caller.
        error? result = caller->send(payload);
        result = caller->complete();
        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }

    //Function to Read Record JSON file and reply to client
    resource function readRecord(grpc:Caller caller, string recordId) {

        string filePath = "./src/"+recordId+".json";
        string payload;

        io:println("Preparing to read the content written");

        var rResult = read(<@untained>  filePath);
        if (rResult is error) {
            log:printError("Error occurred while reading json: ",
                            err = rResult);
        } else {
            payload = rResult.toJsonString();
        }


        error? result = ();

        // Find the requested record from the map.
        if (recordMap.hasKey(recordId)) {
            var jsonValue = typedesc<json>.constructFrom(recordMap[recordId]);
            if (jsonValue is error) {
                // Send casting error as internal error.
                result = caller->sendError(grpc:INTERNAL, <string>jsonValue.detail()["message"]);
            } else {
                json recordDetails = jsonValue;
                payload = recordDetails.toString();
                // Send response to the caller.
                result = caller->send(payload);
                result = caller->complete();
            }
        } else {
            // Send entity not found error.
            payload = "Record ID : '" + recordId + "' cannot be found.";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }

        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }

    //Function to update json record
    //TODO JSON Implementation
    resource function updateRecord(grpc:Caller caller, recordInfo updateRecord) {
        
        string payload;
        error? result = ();
        // Find the record that needs to be updated.
        string recordId = updateRecord.Id;
        if (recordMap.hasKey(recordId)) {
            // Update the existing record.
            recordMap[recordId] = updateRecord;
            payload = "Record ID : '" + recordId + "' updated.";
            // Send response to the caller.
            result = caller->send(payload);
            result = caller->complete();
        } else {
            // Send entity not found error.
            payload = "Record ID : '" + recordId + "' cannot be found.";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }

        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }

    }

    //Function to delete JSON records
    resource function deleteRecord(grpc:Caller caller, string recordId) {
        
        boolean fileExists = file:exists(<@untained> (recordId + ".json"));
        string payload;

        if (fileExists == true) {
            error? removeResults = file:remove(<@untained> ("./src/"+recordId+".json"));
            if (removeResults is ()) {
                payload = "Removed file at /src/"+recordId+".json";
            }
        }
        else {
            payload = "File does not exist at /src/"+recordId+".json";
        }
        
        
        
        error? result = ();
        if (recordMap.hasKey(recordId)) {
            // Remove the requested record from the map.
            _ = recordMap.remove(recordId);
            payload = "Record ID : '" + recordId + "' removed.";
            // Send response to the caller.
            result = caller->send(payload);
            result = caller->complete();
        } else {
            // Send entity not found error.
            payload = "Record : '" + recordId + "' cannot be found.";
            result = caller->sendError(grpc:NOT_FOUND, payload);
        }
        if (result is error) {
            log:printError("Error from Connector: " + result.reason() + " - "
                    + <string>result.detail()["message"] + "\n");
        }
    }
}

//Closes read channel
function closeRc(io:ReadableCharacterChannel rc) {
    var result = rc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}

//Closes write channel
function closeWc(io:WritableCharacterChannel wc) {
    var result = wc.close();
    if (result is error) {
        log:printError("Error occurred while closing character stream",
                        err = result);
    }
}


//Function to hash JSon files ths creating ID
function IDhash(json recordDetails) returns string {

        byte[] output = crypto:hashSha256(recordDetails.toJsonString().toString().toBytes());
        string hash = output.toBase64();

        return hash;
        
}

//Function to write JSOn file
function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    closeWc(wch);
    return result;
}

//Function to read JSON file
function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    closeRc(rch);
    return result;
}

public type recordInfo record {|
    string date = "";
    string Artists = "";
    string description = "";
    string band = "";
    string songs = "";
    string Id = "";
    
|};



const string ROOT_DESCRIPTOR = "0A0A63616C692E70726F746F120C677270635F736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F2286010A0A7265636F7264496E666F12120A046461746518012001280952046461746512180A074172746973747318022001280952074172746973747312200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12120A0462616E64180420012809520462616E6412140A05736F6E67731805200128095205736F6E677332B3020A0E43616C695265636F72644D676D7412430A096164645265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512480A0A726561645265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512460A0C7570646174655265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124A0A0C64656C6574655265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33";
function getDescriptorMap() returns map<string> {
    return {
        "cali.proto":"0A0A63616C692E70726F746F120C677270635F736572766963651A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F2286010A0A7265636F7264496E666F12120A046461746518012001280952046461746512180A074172746973747318022001280952074172746973747312200A0B6465736372697074696F6E180320012809520B6465736372697074696F6E12120A0462616E64180420012809520462616E6412140A05736F6E67731805200128095205736F6E677332B3020A0E43616C695265636F72644D676D7412430A096164645265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512480A0A726561645265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C756512460A0C7570646174655265636F726412182E677270635F736572766963652E7265636F7264496E666F1A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565124A0A0C64656C6574655265636F7264121C2E676F6F676C652E70726F746F6275662E537472696E6756616C75651A1C2E676F6F676C652E70726F746F6275662E537472696E6756616C7565620670726F746F33",
        "google/protobuf/wrappers.proto":"0A1E676F6F676C652F70726F746F6275662F77726170706572732E70726F746F120F676F6F676C652E70726F746F62756622230A0B446F75626C6556616C756512140A0576616C7565180120012801520576616C756522220A0A466C6F617456616C756512140A0576616C7565180120012802520576616C756522220A0A496E74363456616C756512140A0576616C7565180120012803520576616C756522230A0B55496E74363456616C756512140A0576616C7565180120012804520576616C756522220A0A496E74333256616C756512140A0576616C7565180120012805520576616C756522230A0B55496E74333256616C756512140A0576616C756518012001280D520576616C756522210A09426F6F6C56616C756512140A0576616C7565180120012808520576616C756522230A0B537472696E6756616C756512140A0576616C7565180120012809520576616C756522220A0A427974657356616C756512140A0576616C756518012001280C520576616C756542570A13636F6D2E676F6F676C652E70726F746F627566420D577261707065727350726F746F50015A057479706573F80101A20203475042AA021E476F6F676C652E50726F746F6275662E57656C6C4B6E6F776E5479706573620670726F746F33"
        
    };
}
