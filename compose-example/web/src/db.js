const { Pool } = require("pg");

exports.createDbPool = async () => {
  const pool = new Pool({
    user: process.env.POSTGRES_USER || "postgres",
    database: process.env.POSTGRES_DB || "postgres",
    password: process.env.POSTGRES_PASSWORD || "postgres",
    host: process.env.POSTGRES_HOST || "localhost",
    port: process.env.POSTGRES_PORT || 5432,
    connectionTimeoutMillis: 10000
  });

  console.log("Testing database connection...");
  const client = await pool.connect()
  console.log("Connected.");
  const time = await client.query('SELECT NOW()')
  console.log("Verified: " + time.rows[0].now);
  client.release();

  return pool;
};
