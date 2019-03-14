/**
 * Configure the express server and node.js application
 * @author Andrew Jarombek
 * @since 3/13/2019
 */

const express = require('express');

const app = express();
const port = process.env.port || 3000;

app.get('/', (req, res) => {
    res.json({title: 'Dockerized Node.js App'});
});

module.exports = app.listen(port, () => {
    console.info(`Started Containerized App on Port ${port}`);
});