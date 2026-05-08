const mongoose = require('mongoose');

const url = "mongodb://admin:Duong15042004%40@ac-swhqsb2-shard-00-00.lwrkewp.mongodb.net:27017,ac-swhqsb2-shard-00-01.lwrkewp.mongodb.net:27017,ac-swhqsb2-shard-00-02.lwrkewp.mongodb.net:27017/?ssl=true&replicaSet=atlas-soqbni-shard-0&authSource=admin&appName=ToDoApp";

mongoose.connect(url)
    .then(() => console.log("MongoDB Atlas connected"))
    .catch(err => console.log(err));

module.exports = mongoose;