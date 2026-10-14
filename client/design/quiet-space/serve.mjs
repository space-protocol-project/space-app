import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
const files = {
  "/": "index.html",
  "/index.html": "index.html",
  "/styles.css": "styles.css",
  "/app.js": "app.js",
  "/assets/logo.png": "assets/logo.png",
  "/assets/Nunito-Variable.ttf": "assets/Nunito-Variable.ttf",
  "/assets/NunitoSans-Variable.ttf": "assets/NunitoSans-Variable.ttf",
};
const types = {
  html: "text/html; charset=utf-8",
  css: "text/css; charset=utf-8",
  js: "text/javascript; charset=utf-8",
  ttf: "font/ttf",
  png: "image/png",
};
createServer(async (req, res) => {
  const file = files[new URL(req.url, "http://localhost").pathname];
  if (!file || !["GET", "HEAD"].includes(req.method)) {
    res.writeHead(404).end();
    return;
  }
  try {
    const data = await readFile(new URL(file, import.meta.url));
    res.writeHead(200, { "Content-Type": types[file.split(".").pop()] });
    res.end(req.method === "HEAD" ? undefined : data);
  } catch {
    res.writeHead(500).end();
  }
}).listen(8790, "127.0.0.1", () => console.log("http://127.0.0.1:8790"));
