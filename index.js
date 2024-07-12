const {Pool} = require("pg");
require("dotenv").config({path: __dirname + "/.env"});

async function main() {
  console.log(`${new Date().toISOString()} ### Скрипт запускается.`);
  const pool = new Pool({
    host: process.env.PG_HOST,
    database: process.env.PG_DATABASE,
    user: process.env.PG_USER,
    password: process.env.PG_PASSWORD,
    port: process.env.PG_PORT,
  });


  const maxId = (await pool.query(`SELECT COALESCE(MAX(id), 0) AS max_id
                                   FROM nextgis.order;`)).rows[0].max_id;
  console.log(`${new Date().toISOString()} ### Последний order_id: ${maxId}.`);

  const orderList = await (await fetch(`http://gs.naukanet.ru/api/nextgis/orders/get-prorabotki-list?last_order_id=${maxId}`)).json();
  console.log(`${new Date().toISOString()} ### Получено новых заявок: ${orderList.length}.`);
  const orderListStringify = JSON.stringify(orderList);

  let stmt = "SELECT * FROM nextgis.order_create_jsonb($1::jsonb)";

  const rowsInserted = (await pool.query(stmt, [orderListStringify])).rows[0].order_create_jsonb;
  console.log(`${new Date().toISOString()} ### Создано новых записей: ${rowsInserted}.`);

  console.log(`${new Date().toISOString()} ### Завершаю работу.`);
  process.exit(0);
}

main();
