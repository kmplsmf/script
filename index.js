const {Pool} = require('pg');
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'postgres',
  password: 'postgres',
  port: 5433,
});

pool.query('SELECT coalesce(max(orderid), 0) as max_id FROM public.result_1;', function (error, results, fields) {

  if (error) console.log(error);
  console.log(results)
  const maxOrderID = results.rows[0].max_id
  console.log(results)
  console.log('Самое большое число из колонки orderid: ', maxOrderID);
  someOtherFunction(maxOrderID);

});


async function someOtherFunction(orderID) {
  console.log('kek')
  const response = await fetch('http://gs.naukanet.ru/api/nextgis/orders/get-prorabotki-list');
  const data = await response.json();
  console.log(data)
  let stmt = 'INSERT INTO result_1 (orderid, ordertypeid, descr, lat, lon, orderurl) VALUES ($1, $2, $3, $4, $5, $6)';

  for (let i = 0; i < data.length; i++) {
    let row = data[i];
    await pool.query(stmt, [row.order_id, row.order_type_id, row.description, row.latitude, row.longitude, row.order_url]);
  }
}