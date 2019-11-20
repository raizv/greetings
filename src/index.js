require('newrelic')

require('@google-cloud/trace-agent').start({
  ignoreUrls: ['/health'],
  serviceContext: {
    service: 'greetings'
    // version: string
    // minorVersion: string
  }
})

// if (process.env.NODE_ENV === 'prod') {
// }

const config = require('./config')
const server = require('./server')

server.listen(config.port, () => {
  console.log(`Started on port ${server.address().port}`)
})

// test
