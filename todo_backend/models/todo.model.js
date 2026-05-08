const mongoose = require('mongoose');

const schema = new mongoose.Schema({
    userId: String,
    title: String,
    desc: String
});

module.exports = mongoose.model("Todo", schema);