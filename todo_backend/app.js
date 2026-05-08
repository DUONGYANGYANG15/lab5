const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");

const userRoute = require("./routes/user.routes");
const todoRoute = require("./routes/todo.routes");

const app = express();

app.use(cors());
app.use(bodyParser.json());

app.use("/", userRoute);
app.use("/", todoRoute);

module.exports = app;