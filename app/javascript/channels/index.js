// Load all the channels within this directory and all subdirectories.
// Channel files must be named *_channel.js.

// NEW VERSION WITH IMPORTMAP
import "./consumer"

// OLD WEBPACKER VERSION
// const channels = require.context('.', true, /_channel\.js$/)
// channels.keys().forEach(channels)
