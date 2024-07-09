const {max} = require("pg/lib/defaults");
const fs = require('fs');
const Pool = require('pg').Pool;
const pool = new Pool({
  user: 'postgres',
  host: '192.168.1.62',
  database: 'postgres',
  password: 'postgres',
  port: 5433,
});

pool.query('SELECT orderid FROM public.result_1 ORDER BY orderid DESC LIMIT 1', function (error, results, fields) {
  if (error) console.log(error);
  const maxOrderID = results.rows[0].orderid
  console.log(results)
  console.log('Самое большое число из колонки orderid: ', maxOrderID);
  someOtherFunction(maxOrderID);

fs.readFile('data.json', 'utf8', (err, data) => {
  if (err) {
    console.error('Ошибка чтения файла: ' + err);
    return;
  }

  const jsonData = JSON.parse(data);

  const query = 'INSERT INTO result_1 (orderid, ordertypeid, descr, latitude, longitude, orderurl) VALUES ?';
  const value = jsonData.map(item => [item.value1, item.value2, item.value3, item.value4, item.value5, item.value6]);

  pool.query(query, [value], (error, results, fields) => {
    if (error) {
      console.error('Ошибка при вставке данных: ' + error);
      return;
    }
    console.log('Данные успешно вставлены в таблицу result_1.');
  });
});

function someOtherFunction(orderID) {
  console.log('Используем maxOrderID в другой функции: ', orderID);


}})

pool.end();



