import ballerina/grpc;
import ballerina/io;
import ballerina/log;
import ballerina/crypto;

//function to write to a jason file
function write(json content, string path) returns @tainted error? {

    io:WritableByteChannel wbc = check io:openWritableFile(path);

    io:WritableCharacterChannel wch = new (wbc, "UTF8");
    var result = wch.writeJson(content);
    
    return result;
}

//function that enables us to read to a json file
function read(string path) returns @tainted json|error {

    io:ReadableByteChannel rbc = check io:openReadableFile(path);

    io:ReadableCharacterChannel rch = new (rbc, "UTF8");
    var result = rch.readJson();
    
    return result;
}

listener grpc:Listener ep = new (9090);

service greeting on ep {

    resource function replyWrite(grpc:Caller caller, Record value) returns error?{
       
        //Allows one to enter the name of the jason file
        string path = value.recordName;

        //file path in which to save the information
        string filePath = "./src/"+path+".json";    

        io:println("Recieved from client: \nRecord Name: ",value.recordName,"\nDate: ",value.date,"\nArtists: ",value.artists,"\nBand: ",value.band,"\nSongs: ",value.song);

        //Map     
                
        //Store as a single record        
         Record record_Information = {

            recordName: value.recordName,
            date: value.date,          
            artists: value.artists,
            band: value.band,
            song: value.song               

        };

        
        json|error j = json.constructFrom(record_Information);
         if (j is json) {
       
        var wResult = write(j, <@untained>  filePath);
    
            if (wResult is error) {
                    log:printError("Error occurred while writing json: ", wResult);    
                } 
            else {
                    log:printError("File successfully written: ", wResult);
                 }     
        }

        //Hashing the Record
        string info = j.toString();

        byte[]hashIn = info.toBytes();

        byte[]hashOut = crypto:hashMd5(hashIn);

        string Key = hashOut.toBase16();
        int versionNumber = 0;


        // You should return a Identity
        Identity reply = {hash_Key: Key, versionNum: versionNumber+1};
        check caller->send(reply);
        check caller->complete(); 
                  
    }


    resource function replyUpdate(grpc:Caller caller, updateRequest value) returns error?{

        // Implementation goes here.

        string path = value.recordName;

        //file path in which information is saved
        string filePath_2 = "./src/"+path+".json";  

        string info = filePath_2.toString();

        byte[]hashIn = info.toBytes();

        byte[]hashOut = crypto:hashMd5(hashIn);

        string Key_2 = hashOut.toBase16();
        

        updateRequest recieved = {
            
            hash_Key: value.hash_Key,
            versionNum: value.versionNum, 
            recordName: value.recordName,            
            date: value.date,          
            artists: value.artists,
            band: value.band,
            song: value.song
            };

            boolean up = value.hash_Key.equalsIgnoreCaseAscii(Key_2);

        if (up == true){

            Record record_Information = {

            recordName: value.recordName,
            date: value.date,          
            artists: value.artists,
            band: value.band,
            song: value.song               

        };

        
        json|error j = json.constructFrom(record_Information);
         
         if (j is json) {
       
        var wResult = write(j, <@untained>  filePath_2);
            
            if (wResult is error) {
                log:printError("Error occurred while writing json: ", wResult);
          } else {

        log:printError("File successfully written: ", wResult);

           }

        string info_2 = j.toString();

        byte[]hashInside = info.toBytes();

        byte[]hashOutside = crypto:hashMd5(hashInside);

        string Key_3 = hashOutside.toBase16();
        

            Identity identity = {hash_Key: Key_3, versionNum: value.versionNum+1};

            check caller->send(identity);
            check caller->complete(); 
        }

       

        }
    }       

        // You should return a Identity
    
    resource function replyRead_1(grpc:Caller caller, Key value) {
        // Implementation goes here.

        string h_Key = value.hash_Key;

        string filePath_3 = "./src/"+h_Key+".json";

        var rResult = read(<@untained> filePath_3);
        if (rResult is error) {
            log:printError("Error occurred while reading json: ",
                            err = rResult);
        } else {
            io:println(rResult.toJsonString());
        }

        

        

        // You should return a Record
    }
    resource function replyRead_2(grpc:Caller caller, Identity value) {
        // Implementation goes here.

        // You should return a Record
    }
    resource function replyRead_3(grpc:Caller caller, Artist value) {
        // Implementation goes here.

        // You should return a Record
    }
    resource function replyRead_4(grpc:Caller caller, Band value) {
        // Implementation goes here.

        // You should return a Record
    }
    resource function replyRead_5(grpc:Caller caller, Songs value) {
        // Implementation goes here.

        // You should return a Record
    }
}

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

