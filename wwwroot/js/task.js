var worker = new Worker('/wwwroot/js/doWork.js');

worker.addEventListener('message', function (e) {
    console.log('Worker said: ', e.data);
}, false);

worker.postMessage('Hello World'); // Send data to our worker.