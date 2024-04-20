const express = require('express');
const os = require('os');
const fetch = require('node-fetch');

const app = express();
var IPAddress = 'Could not retrieve IP address - try refreshing';


app.get('/', (req, res) => {
  const url = 'https://api.ipify.org';
  fetch(url)
    .then(response => response.text())
    .then(content => {
      IPAddress = "Current IP: " + content;
    })
    .catch(error => {
      IPAddress = 'Could not retrieve IP address - try refreshing';
      console.error("Error obtaining IP: ",error);
    });

  const pageContent = `
  Hostname: ${os.hostname()}<br>
  ${IPAddress}<br>
  App version: ${process.env.APP_VERSION}<br>
  `;
  res.send(pageContent);
});

app.listen(8080, () => {
  console.log('Listening on port 8080');
});
