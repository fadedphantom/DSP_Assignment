import ballerina/crypto;
import ballerina/io;
import ballerina/lang.'int;


type Artist record {
    string name;
    string member;

};

type Song record {
    string title;
    string genre;
    string platform;
};

type Record record {
    string date;
    string band;
    Artist[] artists;
    Song[] songs;
};

type AddingResponse record {
    int record_version;
    string hash;
};

map<map<Record>> storage = {};


public function main() {
    json rr = {
        "date": "22/10/2020",
        "artists": [
                {
                    "name": "wins",
                    "member": "yes"
                }
            ],
        "band": "some band",
        "songs": [
                {
                    "title": "titttttttle",
                    "genre": "genreeeee",
                    "platform": "deez nutz"
                }
            ]
    };
    Record|error first = Record.constructFrom(rr);
    if (first is Record) {
        var xx = add_record(first);
        var xa = add_record(first);
        var xza = add_record(first);
        map<Record>? mapResult = storage["vVt7FHtyN4WY0IWkx23iKJgBRvQ="];
        if (mapResult is map<Record>) {
            io:println(mapResult.keys());
        }
    } else {
        io:println(first.detail());
    }
}

function add_record(Record r) returns AddingResponse? {
    string hashValue = get_hash(r.toString());
    var latest_version = get_latest_version(hashValue);
    if (latest_version is int) {
        // Save if no hash duplicate
        if (hash_exists(hashValue) == false) {
            // Save to record of this version storage
            storage[hashValue][latest_version.toString()] = r;
            return {hash: hashValue, record_version: latest_version};
        } else {
            // Hash exists, so set to a new version where new version is
            // current version + 1
            int new_version = latest_version + 1;
            // Save to record of this version storage
            storage[hashValue][new_version.toString()] = r;
            return {hash: hashValue, record_version: new_version};
        }
    }
}

function hash_exists(string hash) returns boolean {
    return storage.hasKey(hash);
}

function get_hash(string s) returns string {
    byte[] inputArr = s.toBytes();
    byte[] output = crypto:hashSha1(inputArr);
    return output.toBase64();
}

function get_latest_version(string hash) returns int? {
    map<Record>? mapResult = storage[hash];
    if (mapResult is map<Record>) {
        // Compare the keys (versions) and get the largest in value
        int|error highest = 'int:fromString(mapResult.keys()[0]);
        if (highest is int) {
            foreach string k in mapResult.keys() {
                int|error curr = 'int:fromString(k);
                if (curr is int) {
                    if (curr > highest) {
                        highest = curr;
                    }
                }
            }
            return highest;
        }
    }
    return 1;
}
