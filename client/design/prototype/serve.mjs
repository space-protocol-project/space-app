import { createServer } from "node:http";
import { readFile } from "node:fs/promises";
const types = {
  "index.html": "text/html; charset=utf-8",
  "styles.css": "text/css; charset=utf-8",
  "app.js": "text/javascript; charset=utf-8",
  "theme.js": "text/javascript; charset=utf-8",
};
createServer(async (request, response) => {
  const path = new URL(request.url, "http://127.0.0.1").pathname;
  const file = path === "/" ? "index.html" : path.slice(1);
  if (!types[file] || !["GET", "HEAD"].includes(request.method)) {
    response.writeHead(404);
    response.end();
    return;
  }
  try {
    const content = await readFile(new URL(file, import.meta.url));
    response.writeHead(200, { "Content-Type": types[file] });
    response.end(request.method === "HEAD" ? undefined : content);
  } catch {
    response.writeHead(500);
    response.end("Не удалось прочитать файл прототипа");
  }
}).listen(8765, "127.0.0.1", () =>
  process.stdout.write("Прототип: http://127.0.0.1:8765\n"),
);
