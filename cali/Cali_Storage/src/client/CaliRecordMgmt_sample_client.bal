import ballerina/log;
import ballerina/grpc;

public function main (string... args) {

    CaliRecordMgmtBlockingClient blockingEp = new("http://localhost:9090");

    log:printInfo("-----------------------Create a new record-----------------------");
    recordInfo recordReq = {date: "100500", Artists:"XYZ", description:"Sample record.", band: "Mumford & sons", songs: "dunno", Id: "kabisldii"};
    var addResponse = CaliRecordMgmtBlockingClient->addRecord(recordReq);
    if (addResponse is error) {
        log:printError("Error from Connector: " + addResponse.reason() + " - "
                                                + <string>addResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = addResponse;
        log:printInfo("Response - " + result + "\n");
    }

    log:printInfo("--------------------Update an existing record--------------------");
    recordInfo updateReq = {date: "100500", Artists:"XYZ", description:"Sample record.", band: "Mumford & sons", songs: "dunno", Id: "kabisldii"};
    var updateResponse = CaliRecordMgmtBlockingClient->updateRecord(updateReq);
    if (updateResponse is error) {
        log:printError("Error from Connector: " + updateResponse.reason() + " - "
                                                + <string>updateResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = updateResponse;
        log:printInfo("Response - " + result + "\n");
    }

    log:printInfo("---------------------Read an existing record---------------------");
    var findResponse = CaliRecordMgmtBlockingClient->readRecord("100500");
    if (findResponse is error) {
        log:printError("Error from Connector: " + findResponse.reason() + " - "
                                                + <string>findResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = findResponse;
        log:printInfo("Response - " + result + "\n");
    }

    log:printInfo("-------------------------Delete a record------------------------");
    var cancelResponse = CaliRecordMgmtBlockingClient->deleteRecord("100500");
    if (cancelResponse is error) {
        log:printError("Error from Connector: " + cancelResponse.reason() + " - "
                + <string>cancelResponse.detail()["message"] + "\n");
    } else {
        string result;
        grpc:Headers resHeaders;
        [result, resHeaders] = cancelResponse;
        log:printInfo("Response - " + result + "\n");
    }
}


