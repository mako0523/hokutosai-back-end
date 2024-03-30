const express = require("express");
const mysql = require("mysql");

const app = express();

const connection = mysql.createConnection({
  host: "localhost",
  user: "hokutofes_user",
  password: "ZUq8UDoMp6",
  database: "hokutofes_vote",
});

connection.connect((err) => {
  if (err) {
    console.log("error connecting: " + err.stack);
    return;
  }
  console.log("success");
});

const port = 3000;

app.get("/", (req, res) => {
  res.send("Hello World!\n");
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
