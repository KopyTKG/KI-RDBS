import * as mysql from 'mysql'
import * as fs from 'fs'
import { log } from 'console'

const connection = mysql.createConnection({
  host: '10.25.0.23',
  user: 'root',
  password: 'martin25921@',
  database: 'RFID',
})

const queries = fs.readFileSync('source/sql-insert.sql').toString().split('\n')

log(queries)

queries.map((query) => {
  connection.query(query, function (err, result) {
    if (err) throw err
    console.log(result)
  })
})
