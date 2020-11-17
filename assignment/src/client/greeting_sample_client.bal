import ballerina/grpc;
import ballerina/io;
import ballerina/file;

//import ballerina/crypto;

public function main (string... args) {

    greetingBlockingClient blockingEp = new("http://localhost:9090");

    io:println("Choose Task To Perform: \n1. Write a Record: \n2. Update a Record: \n3. Read a Record: ");
    
    string answer = io:readln("Enter choice");    

    boolean action_1 = answer.equalsIgnoreCaseAscii("1");
    boolean action_2 = answer.equalsIgnoreCaseAscii("2");
    boolean action_3 = answer.equalsIgnoreCaseAscii("3");




//Write
    //------------------------------------------------------------------------------------

    if (action_1 == true){

    string record_Name = io:readln("Enter Record name: ");
    string date_Created = io:readln("Enter date Record is being created: ");

    //Artist
    string artist_Name = io:readln("Enter artists Name: ");
    string band_member = io:readln("If artist is a member enter yes, else enter no: ");
    Artist artist_Info = {name: artist_Name, member: band_member};

    //Band
    string band_Name = io:readln("Enter band name: ");
    Band band_Info = {bandName: band_Name};

    //Songs
    string song_Title = io:readln("Enter title of the song: ");
    string song_Genre= io:readln("Enter genre of the song: ");
    string song_Platform = io:readln("Enter platform of the song: ");
    Songs song_Info = {title: song_Title, genre: song_Genre, platform: song_Platform};


    //Create Record
    Record record_Info = {recordName: record_Name, date: date_Created, artists: artist_Info, band:band_Info, song: song_Info};

    var clientUnion = blockingEp->replyWrite(record_Info);

    
    if (clientUnion is grpc:Error) {

        io:println("grpc error");
        
    }

    else {

        io:println("Recieved from the server: ", clientUnion);
    }    



}



    //Update
    //----------------------------------------------------------------------------------------------

    if(action_2 == true){        

    string record_Update = io:readln("Enter name of Record to be updated: ");

    string filePath = "./src/"+record_Update+".json";
    
    boolean fileExists = file:exists(<@untained>  filePath);

        
        string date_Updated= io:readln("Enter date Record is being created: ");

        //Artist
        string artist_Update = io:readln("Enter artists Name: ");
        string band_Update = io:readln("If artist is a member enter yes, else enter no: ");
        Artist update_Artist_Info = {name: artist_Update, member: band_Update};

        //Band
        string band_Name_Update = io:readln("Enter band name: ");
        Band band_Info_Update = {bandName: band_Name_Update};

        //Songs
        string song_Title_Update = io:readln("Enter title of the song: ");
        string song_Genre_Update= io:readln("Enter genre of the song: ");
        string song_Platform_Update = io:readln("Enter platform of the song: ");
        Songs song_Info_Update = {title: song_Title_Update, genre: song_Genre_Update, platform: song_Platform_Update};
        
        Record record_Information = {

            recordName: record_Update,
            date: date_Updated,          
            artists: update_Artist_Info,
            band: band_Info_Update,
            song: song_Info_Update               

        };              
        

        string Key = io:readln("Enter key: ");
        
        int versionNumber = 1;          

            updateRequest recUpdate = {
            
            hash_Key: Key,
            versionNum: versionNumber, 
            recordName: record_Update,            
            date: date_Updated,          
            artists: update_Artist_Info,
            band: band_Info_Update,
            song: song_Info_Update   };

            var clientUnion_2 = blockingEp->replyUpdate(recUpdate);

    
    if (clientUnion_2 is grpc:Error) {

        io:println("grpc error");
        
    }

    else {

        io:println("Recieved from the server: ", clientUnion_2);
         }    


    } 

    if(action_3 == true){ 

        string read = io:readln("Enter the name of the file to read: ");

        Key k = {hash_Key: read};

         var clientUnion_3 = blockingEp->replyRead_1(k);
    } 


       
    }   
      


     
    
    
