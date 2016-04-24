'use strict';

module.exports = {};

//Should be only invoked using node CLI
if (require.main !== module) {
	return;
}

var cliArgs = require('minimist')(process.argv.slice(2));

if (cliArgs['_'].length === 0) {
	throw new Error('USAGE: `node stt.js fileName`');
}

let util = require('util'),
  path = require('path'),
  fs = require('fs'),
  ps = require('pocketsphinx').ps,
  config = new ps.Decoder.defaultConfig(),
  modeldir = "../deps/pocketsphinx/model/en-us/";

config.setString("-hmm", modeldir + "en-us");
config.setString("-dict", modeldir + "cmudict-en-us.dict");
config.setString("-lm", modeldir + "en-us.lm.bin");

//console.info('cliArgs:', cliArgs);

let allArgs = cliArgs['_'];

for (let cliArgIndex = 0; cliArgIndex < allArgs.length; cliArgIndex++) {
	allArgs[cliArgIndex] = "../deps/pocketsphinx/test/data/goforward.raw";
	var data = fs.readFileSync(allArgs[cliArgIndex]);
	let decoder = new ps.Decoder(config);
	decoder.startUtt();
	decoder.processRaw(data, false, false);
	decoder.endUtt();
	console.log('=====================' + allArgs[cliArgIndex] + '=======================');
	console.log(decoder.hyp());
	console.log('========================================================================');
}
