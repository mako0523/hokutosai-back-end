"use strict";

const express = require("express");
const requestIp = require("request-ip");
const cors = require("cors");
const mysql = require("mysql");
require("dotenv").config();

const voteNames = [
  "stall",
  "exhibition",
  "voice",
  "cosplay",
  "muscle",
  "karaoke",
];

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
  isUndefined(process.env.SCHOOL_IP) |
  isUndefined(process.env.PORT);

if (isEnvironmentVariableUndefined) {
  throw new ReferenceError("Environment variable is not defined");
}

const app = express();

const corsOptions = {
  origin: ["http://127.0.0.1:3000", "https://hokutosai-manager.vercel.app"],
  methods: ["GET", "PUT"],
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
    throw error;
  }
});

app.get("/api", (req, res) => {
  res.send("Hokutofes vote api.");
});

const fetch = (voteName) => {
  app.get(`/api/vote/${voteName}`, (req, res) => {
    connection.query(`SELECT * FROM ${voteName}`, (error, results) => {
      res.send(results);
    });
  });
};

const post = (voteName) => {
  app.put(`/api/vote/${voteName}/:name`, (req, res) => {
    const ip = requestIp.getClientIp(req);

    connection.query(
      `
    UPDATE
        ${voteName}
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
  });
};

for (const voteName of voteNames) {
  fetch(voteName);
  post(voteName);
}

app.listen(process.env.PORT);
