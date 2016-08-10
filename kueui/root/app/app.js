var kue = require('kue'),
    express = require('express'),
    ui = require('kue-ui'),
    app = express(),
    jobQueue = kue.createQueue({
        prefix: process.env.KUE_PREFIX,
        redis: process.env.CACHE_URL
    });

ui.setup({
    apiURL: '/api', // IMPORTANT: specify the api url
    baseURL: '/kue', // IMPORTANT: specify the base url
    updateInterval: 5000 // Optional: Fetches new data every 5000 ms
});

// Mount kue JSON api
app.use('/api', kue.app);

// Mount UI
app.use('/kue', ui.app);

app.listen(process.env.APP_PORT);

console.log(`Kue admin UI started on port ${process.env.APP_PORT}`);

// catch error or exception
process.on('uncaughtException', function (e) {

    console.log(e.stack);

    jobQueue.shutdown(5000, function(err) {
        if (err) {
            console.log(err.stack);
        }

        console.log('Kue shutdown');

        process.exit(0);

    });

});
