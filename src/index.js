require('newrelic')

// const config = require('./config')
// const server = require('./server')
// const logger = require('./logger')

const express = require('express')
const app = express()
const port = 8080

app.get('/', (req, res) => res.send('Hello world!'))

app.post('/', (req, res) => res.send('Get POST req'))

app.listen(port, () => console.log(`Greetings App is listening op port ${port} ...`))

// server.listen(process.env.PORT || config.port, () => {
//     logger.info(`Started on port ${server.address().port}`)
//   })