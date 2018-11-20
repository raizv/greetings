const express = require('express')
const http = require('http')
const bodyParser = require('body-parser')
const morgan = require('morgan')

const { version } = require('../package.json')

const app = express()

app.use(morgan('combined'))
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

app.set('view engine', 'ejs')

app.get('/', (req, res) => res.send('Hello Nodemon!'))
app.get('/version', (req, res) => res.json({ version }))
app.get('/about', (req, res) => res.render('about'))

app.post('/', (req, res) => {
  res.send(`Hello ${req.body.name} World!`)
})

module.exports = http.createServer(app)
