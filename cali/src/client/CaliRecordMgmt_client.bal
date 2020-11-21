import ballerina/grpc;
import ballerina/io;
import ballerina/log;

public function main (string... args) {

CaliRecordMgmtBlockingClient blockingEp = new("http://localhost:9090");

io:println("Choose Task To Perform: \n1. Write a Record: \n2. Update a Record: \n3. Read a Record: \n4. Delete a Record ");
    
string answer = io:readln("Enter choice");    

boolean action_1 = answer.equalsIgnoreCaseAscii("1");
boolean action_2 = answer.equalsIgnoreCaseAscii("2");
boolean action_3 = answer.equalsIgnoreCaseAscii("3");
boolean action_4 = answer.equalsIgnoreCaseAscii("4");

    if (action_1 == true){

        string record_Name = io:readln("Enter Record name: ");
        string date_Created = io:readln("Enter date Record is being created: ");

        //Artist
        string artist_Name = io:readln("Enter artists Name: ");
        string band_member = io:readln("If artist is a member enter yes, else enter no: ");
        
        //Band
        string band_Name = io:readln("Enter band name: ");

        //Songs
        string song_Title = io:readln("Enter title of the song: ");
        string song_Genre= io:readln("Enter genre of the song: ");
        string song_Platform = io:readln("Enter platform of the song: ");

        json recordInformation = {
	        "date": date_Created,
	        "artists":
		        {
			        "Member Names": artist_Name,
			        "member": band_member
		        },
	        "band name": band_Name,
	        "songs": 
		        {
			        "title": song_Title,
			        "genre": song_Genre,
			        "platform": song_Platform
		        }
        };
        
        
        log:printInfo("-----------------------Creating new record-----------------------");

        recordInfo recordReq = {date: date_Created , Artists: artist_Name, description: song_Platform, band: band_Name, songs: song_Title};
        
        var addResponse = blockingEp->addRecord(recordReq);
        if (addResponse is error) {
            log:printError("Error from Connector: " + addResponse.reason() + " - "
                                                    + <string>addResponse.detail()["message"] + "\n");
        } else {
            string result;
            grpc:Headers resHeaders;
            [result, resHeaders] = addResponse;
            log:printInfo("Response - " + result + "\n");
        }
    }

    if(action_2 == true){
        log:printInfo("--------------------Updating an existing record--------------------");
        recordInfo updateReq = {date: "100500", Artists:"XYZ", description:"Sample record.", band: "Mumford & sons", songs: "dunno", Id: "kabisldii"};
        [string, grpc:Headers]|grpc:Error updateResponse = blockingEp->updateRecord(updateReq);
        if (updateResponse is error) {
            log:printError("Error from Connector: " + updateResponse.reason() + " - "
                                                    + <string>updateResponse.detail()["message"] + "\n");
        } else {
            string result;
            grpc:Headers resHeaders;
            [result, resHeaders] = updateResponse;
            log:printInfo("Response - " + result + "\n");
        }
    }


    if(action_3 == true){

        log:printInfo("---------------------Read an existing record---------------------");
        [string, grpc:Headers]|grpc:Error findResponse = blockingEp->readRecord("100500");
        if (findResponse is error) {
            log:printError("Error from Connector: " + findResponse.reason() + " - "
                                                    + <string>findResponse.detail()["message"] + "\n");
        } else {
            string result;
            grpc:Headers resHeaders;
            [result, resHeaders] = findResponse;
            log:printInfo("Response - " + result + "\n");
        }
    }


    if(action_4 == true){
        log:printInfo("-------------------------Delete a record------------------------");
        [string, grpc:Headers]|grpc:Error deleteResponse = blockingEp->deleteRecord("100500");
        if (deleteResponse is error) {
            log:printError("Error from Connector: " + deleteResponse.reason() + " - "
                    + <string>deleteResponse.detail()["message"] + "\n");
        } else {
            string result;
            grpc:Headers resHeaders;
            [result, resHeaders] = deleteResponse;
            log:printInfo("Response - " + result + "\n");
        }
    }
    
}
