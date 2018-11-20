require('newrelic')

const config = require('./config')
const server = require('./server')

server.listen(config.port, () => {
  console.log(`Started on port ${server.address().port}`)
})
