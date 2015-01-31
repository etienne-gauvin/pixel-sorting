canvas = document.getElementById('canvas')
ctx = canvas.getContext('2d')
loadingEl = document.getElementById('loading')
saveButton = document.getElementById('save')
startButton = document.getElementById('start')
downloadEl = document.getElementById('download')
state = 'loading'
direction = 'horizontal' # vertical|horizontal
maxDist = 250
image = new Image

# Charger une image
loadImage = ->
    state = 'loading'
    image = new Image
    image.addEventListener('load', -> init())
    image.src = canvas.querySelector('img').src

loadImage()

# A button to start pixel sorting
startButton.addEventListener('click', -> start() if state == 'ready')

# A button to save the image
saveButton.addEventListener 'click', ->
    if state == 'done'
        downloadEl.href = canvas.toDataURL('image/png')
        fireClick(download)

# Initialize the canvas
init = ->
    state = 'ready'
    
    # Application de la taille du canvas
    canvas.width = image.width
    canvas.height = image.height
    
    # Afficher l'image
    ctx.drawImage(image, 0, 0)

# Start pixel sorting
start = ->
    state = "sorting"
    
    # Get ImageData
    data = ctx.getImageData(0, 0, canvas.width, canvas.height)
    
    
    mustExchange = (prevPixel, pixel) ->
        getRGBSum(prevPixel) > getRGBSum(pixel) # lighter -> darker pixels
        #prevPixel[2] > pixel[2] # lighter -> darker pixels
    
    if direction == 'vertical'
        x = 0
        step = ->
            y = 1
            console.log "Column #{x} / #{data.width}"
            while y < data.height
                
                #console.log "Line #{y} / #{data.height}"
                # The pixel and the previous pixel
                pixel =     getPixel(data, x, y)
                prevPixel = getPixel(data, x, y-1)

                if y > 0 and mustExchange(prevPixel, pixel)
                    setPixel(data, x, y, prevPixel)
                    setPixel(data, x, y-1, pixel)
                    y--
                else
                    y++
            
            x++
            if x < data.width
                ctx.putImageData(data, 0, 0)
                requestAnimationFrame(step)
            else
                # Application
                ctx.putImageData(data, 0, 0)
                state = 'done'
        
        step()

    else if direction == 'horizontal'
        y = 0
        step = ->
            x = 1
            console.log "Line #{y} / #{data.height}"
            while x < data.width

                # The pixel and the previous pixel
                pixel =     getPixel(data, x, y)
                prevPixel = getPixel(data, x-1, y)

                if x > 0  and mustExchange(prevPixel, pixel)
                #if x > 0 and dist < maxDist and mustExchange(prevPixel, pixel)
                    setPixel(data, x, y, prevPixel)
                    setPixel(data, x-1, y, pixel)
                    x--
                    dist++
                else
                    dist = 0
                    x++
            
            y++
            if y < data.width
                ctx.putImageData(data, 0, 0)
                requestAnimationFrame(step)
            else
                # Application
                ctx.putImageData(data, 0, 0)
                state = 'done'

        step()

    

    
# Get a pixel on the image data in a Array[4]
getPixel = (imageData, x, y) ->
    i = y * imageData.width * 4 + x * 4
    d = imageData.data
    [d[i], d[i+1], d[i+2], d[i+3]]


# Apply a pixel on the image
setPixel = (imageData, x, y, pixel) ->
    i = y * imageData.width * 4 + x * 4
    d = imageData.data
    d[i] =   pixel[0]
    d[i+1] = pixel[1]
    d[i+2] = pixel[2]
    d[i+3] = pixel[3]

# Simulate a click
fireClick = (el) ->
    if el.fireEvent
        el.fireEvent('onclick')
    else
        evObj = document.createEvent('Events')
        evObj.initEvent('click', true, false)
        el.dispatchEvent(evObj)

# Calculate sum of rgb components
getRGBSum = (pixel) ->
    pixel[0] + pixel[1] + pixel[2]
