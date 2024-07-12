const {Pool} = require("pg");
require("dotenv").config({path: __dirname + "/.env"});

async function main() {
  const pool = new Pool({
    host: process.env.PG_HOST,
    database: process.env.PG_DATABASE,
    user: process.env.PG_USER,
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT,
  });


  const maxId = (await pool.query(`SELECT COALESCE(MAX(orderid), 0) AS max_id FROM public.${process.env.TARGET_TABLE};`)).rows[0].max_id;
  console.log(`Последний order_id: ${maxId}`);

  const orderList = await (await fetch(`http://gs.naukanet.ru/api/nextgis/orders/get-prorabotki-list?last_order_id=${maxId}`)).json();
  const data = JSON.stringify(orderList)

  let stmt = `SELECT * FROM public.order_create_jsonb($1::jsonb)`;

  pool.query(stmt, [data])
}

main();
