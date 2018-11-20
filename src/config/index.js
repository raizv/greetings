const env = process.env.APP_ENV || 'development'
const config = require(`./${env}`)
const port = process.env.NODE_PORT || '8080'
config.env = env
config.port = port

module.exports = config
