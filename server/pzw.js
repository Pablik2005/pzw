bodyParser = require('body-parser'); 
const cors = require('cors');
const express = require('express');
const http = require('http');
const mysql = require("mysql");
const randomstring = require("randomstring");

const app = express();
app.use(bodyParser.json({limit: '20mb', extended: true}));
app.use(cors());

class Database {
    constructor() {
        this.connection = mysql.createConnection({
            host: '80.48.28.252',
            user: 'pzw',
            password: 'pzw',
            database: 'pzw'
        });
        this.connection.connect((err) => {
            if (err)
                throw err;
            else
                console.log("DB Connected..");
        })
    }
    query(sql, args) {
        return new Promise((resolve, reject) => {
            this.connection.query(sql, args, (err, rows) => {
                if (err)
                    return reject(err);
                resolve(rows);
            });
        });
    }
    query(sql) {
        return new Promise((resolve, reject) => {
            this.connection.query(sql, (err, rows) => {
                if (err)
                    return reject(err);
                resolve(rows);
            });
        });
    }
    close() {
        return new Promise((resolve, reject) => {
            this.connection.end(err => {
                if (err)
                    return reject(err);
                resolve();
            });
        });
    }
}
var db = new Database();


app.get('/',(req, res)=>{
    res.send("Server");  
});

app.post("/getFisheryList", async (req, res) => {
    var ret;
    await db.query("SELECT * FROM `fisheries`").
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    res.status(200).json(ret);
});

app.post("/getParkingPlaceList", async (req, res) => {
    var ret;
    await db.query("SELECT * FROM `parkingPlaces`").
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    res.status(200).json(ret);
});

app.post("/getFishList", async (req, res) => {
    var ret;
    await db.query("SELECT * FROM `fishes`").
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    res.status(200).json(ret);
});

app.post("/getFishListFromFishery", async (req, res) => {
    var data = req.body;
    //console.log(data);  
    var ret;
    await db.query("SELECT `idFish` FROM `fisheries_fishes` WHERE `idFishery`=" + data['idFishery']).
    	then(result => {
            ret = result;
        }).catch(err => {
       	    if (err) throw err;
        });
    res.json(ret);
    
});

app.post("/getAlertListFromFishery", async (req, res) => {
    var data = req.body;
    //console.log(data);
    var ret;
    await db.query("SELECT * FROM `alerts` WHERE `idFishery`=" + data['idFishery']).
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    res.json(ret);

});

app.post("/getTrophyListFromFishery", async (req, res) => {
    var data = req.body;
    //console.log(data);
    var ret;
    await db.query("SELECT * FROM `trophies` WHERE `idFishery`=" + data['idFishery']).
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });

    var i;
    for (i = 0; i < ret.length; i++) {
	var tUserName;
        await getUserNameByID(ret[i].idUser)
            .then((x)=>{
                tUserName = x;
            });
        ret[i].idUser = tUserName;
 
    }


    res.json(ret);

});

app.post("/tryLogin", async (req, res) => {
    var data = req.body;
    //console.log(data);
    var ret;
    await db.query("SELECT COUNT(*) as `count`,`id` FROM `users` WHERE `email`='"+data['email']+"' AND hash='"+data['hash']+"'").
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    if(ret[0].count)
	res.send({'id':ret[0].id});
    else
        res.send({'error':'Błędny emial lub hasło'});

});


app.post("/addTrophy", async (req, res) => {
    var data = req.body;
    //console.log(data);
    var ret;
    await db.query("INSERT INTO `trophies`(`idFishery`, `idUser`, `date`, `img`, `description`) "+
		   "VALUES (" +data['idFishery'] +", '"+ data['idUser'] +"', NOW(), '"+ data['img'] +"', '"+ data['description'] +"')").
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    res.send("done");

});

app.post("/addUser", async (req, res) => {
    var data = req.body;
    if ( await checkUserExist(data['email']) )
        res.json({ error: 'User Exist' });
    else {

        var randId = randomstring.generate();
        while ( await checkUserIdExist(randId) )
            randId = randomstring.generate();

	db.query("INSERT INTO `users`(`id`, `email`, `hash`, `name`, `surname`, `address`, `postOffice`, `mobilePhone`, `landlinePhone`, `fishingCardNumber`, `registrationDate`, `isActive`) "+ 
		 "VALUES ('" +randId + "', '" +data['email']+ "', '" +data['password']+ "', '"  +data['name']+ "', '" +data['surname']+ "', '" +data['address']+ "', '"+ data['postOffice']+ "', '" +data['mobilePhone']+ "', '" +data['landlinePhone']+ "', '" +data['fishingCardNumber']+ "', NOW(), 0)").
        catch(err => {
            if (err) throw err;
        });

	res.json({"id" : randId});
    }
});

app.post("/addNotification", async (req, res) => {
    var data = req.body;
    //console.log(data);
    var ret;
    await db.query("INSERT INTO `notifications`(`idFishery`, `idUser`, `date`, `type`, `latitude`, `longitude`, `content`, `img`, `isReaded`) "+
		   "VALUES (" +data['idFishery']+ ", '" +data['idUser']+ "', NOW(), '" +data['type']+ "', '" +data['latitude']+ "', '" +data['longitude']+ "', '" +data['content']+ "', '" +data['img'] +"',0)").
        then(result => {
            ret = result;
        }).catch(err => {
            if (err) throw err;
        });
    res.send("done");

});

async function getUserNameByID(fId) {
    var ret;
    await db.query("SELECT `name`,`surname` FROM `users` WHERE `id`='" + fId + "'").
        then(results => {
            ret = results[0].name + " " + results[0].surname;
        }).catch(err => {
            if (err) throw err;
        });
    return ret;
}

async function checkUserExist(fEmail) {
    var ret;
    await db.query("SELECT COUNT(*) as `count` FROM `users` WHERE `email`='"+fEmail+"'").
        then(results => {
            ret = results;
        }).catch(err => {
            if (err) throw err;
        });

 	return ret[0].count;
}

async function checkUserIdExist(fId) {
    var count;
    await db.query("SELECT COUNT(*) as count FROM `users` WHERE `id`='" + fId + "'").
        then(results => {
            count = results[0].count
        }).catch(err => {
            if (err) throw err;
        });
    return count;
}

app.get("/keepSessionAlive",  (req, res) => {
    db.query("SHOW TABLES", (err, result) => {
            if (err) throw err;
            console.log(result);
        });

    res.status(200).send({ 'status': "done" });
});


const server = http.Server(app);
server.listen(3001);
