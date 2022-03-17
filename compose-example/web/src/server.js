const express = require("express");
const http = require("http");
const io = require("socket.io");

exports.createServer = () => {
  const app = express();

  app.use(express.json());
  app.use(express.urlencoded({ extended: true }));
  app.use(express.static("public"));
  app.set("view engine", "ejs");

  const server = http.createServer(app);
  io(server);

  return [app, server];
};
