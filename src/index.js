require('newrelic')

if (process.env.NODE_ENV === 'prod') {
  require('@google-cloud/trace-agent').start()
}

const config = require('./config')
const server = require('./server')

server.listen(config.port, () => {
  console.log(`Started on port ${server.address().port}`)
})

// test
