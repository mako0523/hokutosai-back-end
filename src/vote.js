"use strict";

const express = require("express");
const requestIp = require("request-ip");
const cors = require("cors");
const mysql = require("mysql");
require("dotenv").config();

const isUndefined = (arg) => {
  if (typeof arg === "undefined") {
    return true;
  }
  return false;
};

const isEnvironmentVariableUndefined =
  isUndefined(process.env.MYSQL_CONNECTION_DATABASE) |
  isUndefined(process.env.MYSQL_CONNECTION_HOST) |
  isUndefined(process.env.MYSQL_CONNECTION_PASSWORD) |
  isUndefined(process.env.MYSQL_CONNECTION_USER) |
  isUndefined(process.env.PORT);

if (isEnvironmentVariableUndefined) {
  throw new ReferenceError("Environment variable is not defined");
}

const app = express();

const corsOptions = {
  origin: "http://127.0.0.1:3000",
  methods: ["GET", "POST", "PUT"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
};

app.use(cors(corsOptions));

const connection = mysql.createConnection({
  database: process.env.MYSQL_CONNECTION_DATABASE,
  host: process.env.MYSQL_CONNECTION_HOST,
  password: process.env.MYSQL_CONNECTION_PASSWORD,
  user: process.env.MYSQL_CONNECTION_USER,
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
  const ip = requestIp.getClientIp(req);

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

  connection.query(
    `INSERT INTO ip (ip) VALUES ('${ip}');`,
    (error, results) => {}
  );
});

app.listen(process.env.PORT);
