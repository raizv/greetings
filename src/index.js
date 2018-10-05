require('newrelic');

const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const { version } = require('../package.json');

const port = 8080;
const app = express();

app.use(morgan('combined'));
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

app.get('/', (req, res) => res.send('Hello world!'));
app.get('/version', (req, res) => res.json({ version }));

app.post('/', (req, res) => {
  res.send(`Hello ${req.body.name} World!`);
});

app.listen(port, () => {
  console.log(`Started on port ${port}`);
});
