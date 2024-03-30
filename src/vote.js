"use strict";

const express = require("express");
const mysql = require("mysql");

const app = express();

const connection = mysql.createConnection({
  database: "hokutofes_vote",
  host: "localhost",
  password: "ZUq8UDoMp6",
  user: "hokutofes_user",
});

connection.connect((error) => {
  if (error) {
    console.log("error connecting: " + error.stack);
    return;
  }

  console.log("success");
});

app.get("/", (req, res) => {
  res.send("Hokutofes vote api.");
});

app.get("/vote", (req, res) => {
  connection.query("SELECT * FROM stall", (error, results) => {
    res.send(results);
  });
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on port ${port}...`));
