const { createDbPool } = require("./db");
const { createServer } = require("./server");

(async () => {
  const [app, server] = createServer();
  const pool = await createDbPool();
  const port = process.env.PORT || 3000;
  
  app.get("/", async (req, res) => {
    const haikus = await pool.query("SELECT * FROM haikus ORDER BY id");
    res.render("index", { haikus: haikus.rows });
  });
  
  app.post("/heart", async (req, res) => {
    await pool.query(
      "UPDATE haikus SET hearts = hearts + 1 WHERE id = $1",
      [req.body.idz]);
    res.send("Success")
  });
  
  server.listen(port, () =>
    console.log(`🚀  Server is now running on: http://localhost:${port}`)
  );  
})();
