// Generated by CoffeeScript 1.8.0
(function() {
  var canvas, ctx, direction, downloadEl, fireClick, getPixel, getRGBSum, image, init, loadImage, loadingEl, maxDist, saveButton, setPixel, start, startButton, state;

  canvas = document.getElementById('canvas');

  ctx = canvas.getContext('2d');

  loadingEl = document.getElementById('loading');

  saveButton = document.getElementById('save');

  startButton = document.getElementById('start');

  downloadEl = document.getElementById('download');

  state = 'loading';

  direction = 'horizontal';

  maxDist = 250;

  image = new Image;

  loadImage = function() {
    state = 'loading';
    image = new Image;
    image.addEventListener('load', function() {
      return init();
    });
    return image.src = canvas.querySelector('img').src;
  };

  loadImage();

  startButton.addEventListener('click', function() {
    if (state === 'ready') {
      return start();
    }
  });

  saveButton.addEventListener('click', function() {
    if (state === 'done') {
      downloadEl.href = canvas.toDataURL('image/png');
      return fireClick(download);
    }
  });

  init = function() {
    state = 'ready';
    canvas.width = image.width;
    canvas.height = image.height;
    return ctx.drawImage(image, 0, 0);
  };

  start = function() {
    var data, mustExchange, step, x, y;
    state = "sorting";
    data = ctx.getImageData(0, 0, canvas.width, canvas.height);
    mustExchange = function(prevPixel, pixel) {
      return getRGBSum(prevPixel) > getRGBSum(pixel);
    };
    if (direction === 'vertical') {
      x = 0;
      step = function() {
        var pixel, prevPixel, y;
        y = 1;
        console.log("Column " + x + " / " + data.width);
        while (y < data.height) {
          pixel = getPixel(data, x, y);
          prevPixel = getPixel(data, x, y - 1);
          if (y > 0 && mustExchange(prevPixel, pixel)) {
            setPixel(data, x, y, prevPixel);
            setPixel(data, x, y - 1, pixel);
            y--;
          } else {
            y++;
          }
        }
        x++;
        if (x < data.width) {
          ctx.putImageData(data, 0, 0);
          return requestAnimationFrame(step);
        } else {
          ctx.putImageData(data, 0, 0);
          return state = 'done';
        }
      };
      return step();
    } else if (direction === 'horizontal') {
      y = 0;
      step = function() {
        var dist, pixel, prevPixel;
        x = 1;
        console.log("Line " + y + " / " + data.height);
        while (x < data.width) {
          pixel = getPixel(data, x, y);
          prevPixel = getPixel(data, x - 1, y);
          if (x > 0 && mustExchange(prevPixel, pixel)) {
            setPixel(data, x, y, prevPixel);
            setPixel(data, x - 1, y, pixel);
            x--;
            dist++;
          } else {
            dist = 0;
            x++;
          }
        }
        y++;
        if (y < data.width) {
          ctx.putImageData(data, 0, 0);
          return requestAnimationFrame(step);
        } else {
          ctx.putImageData(data, 0, 0);
          return state = 'done';
        }
      };
      return step();
    }
  };

  getPixel = function(imageData, x, y) {
    var d, i;
    i = y * imageData.width * 4 + x * 4;
    d = imageData.data;
    return [d[i], d[i + 1], d[i + 2], d[i + 3]];
  };

  setPixel = function(imageData, x, y, pixel) {
    var d, i;
    i = y * imageData.width * 4 + x * 4;
    d = imageData.data;
    d[i] = pixel[0];
    d[i + 1] = pixel[1];
    d[i + 2] = pixel[2];
    return d[i + 3] = pixel[3];
  };

  fireClick = function(el) {
    var evObj;
    if (el.fireEvent) {
      return el.fireEvent('onclick');
    } else {
      evObj = document.createEvent('Events');
      evObj.initEvent('click', true, false);
      return el.dispatchEvent(evObj);
    }
  };

  getRGBSum = function(pixel) {
    return pixel[0] + pixel[1] + pixel[2];
  };

}).call(this);
