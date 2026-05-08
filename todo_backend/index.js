const app = require("./app");
require('./config/db.js');

app.listen(3000, () => {
    console.log("Server running at http://localhost:3000");
});