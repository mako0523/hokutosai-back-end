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

app.get("/api", (req, res) => {
  res.send("Hokutofes vote api.");
});

app.get("/api/vote", (req, res) => {
  connection.query("SELECT * FROM stall", (error, results) => {
    res.send(results);
  });
});

app.put("/api/vote/:name", (req, res) => {
  const ip = req.ip;

  connection.query(
    `
    UPDATE
        stall
    SET
        count = count + 1
    WHERE
        name = '${req.params.name}'
        AND NOT EXISTS (
            SELECT
                1
            FROM
                ip
            WHERE
                ip.ip = '${ip}'
        );
   `,
    (error, results) => {
      res.send(results);
    }
  );

  // TODO: IPアドレスを元に投票回数を制限する処理を実装
  // connection.query(
  //   `INSERT INTO ip (ip) VALUES ('${ip}');`,
  //   (error, results) => {}
  // );
});

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`Listening on port ${port}...`));
