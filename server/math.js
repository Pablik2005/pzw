bodyParser = require('body-parser'); 
const cors = require('cors');
const express = require('express');
const http = require('http');
const mysql = require("mysql");
const randomstring = require("randomstring");

const app = express();
app.use(bodyParser.json({limit: '20mb', extended: true}));
app.use(cors());

app.post("/math", async (req, res) => {
    var data = req.body;

    var objectsPoints = data['object'];
    objectsPoints = objectsPoints.split(';');
    var point = data['point']; 

    var episodes = generateEpisodes(objectsPoints);

    checkStraightIntersectsOneOfPointsInEpisode(point, episodes[0]);
    //console.log(objects[0]);
    //console.log(point);
    res.send("done");

});

function generateEpisodes(fObjectsPoints)
{
    var returnArray=[];
    for (let i = 0; i < fObjectsPoints.length; i++) 
    {
        if( (i) == fObjectsPoints.length-1)
            returnArray.push(fObjectsPoints[i] + ";" + fObjectsPoints[0]);
        else
            returnArray.push(fObjectsPoints[i] + ";" + fObjectsPoints[i+1]);       
    }

    return returnArray;
};

function checkStraightIntersectsOneOfPointsInEpisode(fStraight, fPoints)
{
    var B = -1 ;
    var A = fStraight.split('-')[0]; //latitude
    var C = fStraight.split('-')[1]; //longitude

    var pointA =  fPoints.split(';')[0];
    var pointB =  fPoints.split(';')[1];

    var Ax = pointA.split('-')[0];
    var Ay = pointA.split('-')[0];
    
    var Bx = pointB.split('-')[0];
    var By = pointB.split('-')[1];

    console.log(fStraight);
    console.log(fPoints);
}

const server = http.Server(app);
server.listen(3001);
