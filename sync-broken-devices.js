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

  const brokenDeviceList = await (await fetch(`http://gs.naukanet.ru/api/nextgis/devices/get-broken`)).json();
  console.log(`${new Date().toISOString()} ### Получено сломанного оборудования: ${brokenDeviceList.length}.`);
  const brokenDeviceListStringify = JSON.stringify(brokenDeviceList);

  let stmt = "SELECT * FROM nextgis.broken_devices_create_jsonb_replace($1::jsonb)";

  const rowsInserted = (await pool.query(stmt, [brokenDeviceListStringify])).rows[0].broken_devices_create_jsonb_replace;
  console.log(`${new Date().toISOString()} ### Создано новых записей: ${rowsInserted}. Старые записи очищены.`);

  console.log(`${new Date().toISOString()} ### Завершаю работу.`);
  process.exit(0);
}

main();
