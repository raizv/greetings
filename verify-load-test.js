let expect = require('expect')
let results = require('./artillery_report.json')

expect(results.aggregate.codes).toHaveProperty('200', results.aggregate.scenariosCreated)
expect(results.aggregate.latency.median).toBeLessThan(50)
expect(results.aggregate.scenarioDuration.median).toBeLessThan(100)
