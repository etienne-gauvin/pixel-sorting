canvas = document.getElementById('canvas')
ctx = canvas.getContext('2d')
loadingEl = document.getElementById('loading')

image = new Image
image.addEventListener('load', -> start())
image.src = canvas.querySelector('img').src

start = ->
    # Application de la taille du canvas
    canvas.width = image.width
    canvas.height = image.height
    
    # Afficher l'image
    ctx.drawImage(image, 0, 0)
    
    # Pour chaque ligne
    for y in [0 .. image.height]
        
        console.log "#{y} / #{image.height} lines"
        
        # ImageData de la ligne
        line = ctx.getImageData(0, y, image.width, 1)
        
        x = 1
        while x < line.width
            
            #console.log x, y
            
            # Tri des deux pixels
            pixel1 = getPixel(line, x, 0)
            pixel2 = getPixel(line, x - 1, 0)
            
            if x > 0 and pixel1[0] + pixel1[1] + pixel1[2] > pixel2[0] + pixel2[1] + pixel2[2]
                setPixel(line, x, 0, pixel2)
                setPixel(line, x-1, 0, pixel1)
                #console.log("Échange #{x-1} avec #{x} sur #{y}")
                x--
            else
                x++
        
        # Application
        ctx.putImageData(line, 0, y)
        
    

getPixel = (imageData, x, y) ->
    i = y * imageData.width * 4 + x * 4
    d = imageData.data
    [d[i], d[i+1], d[i+2], d[i+3]]

setPixel = (imageData, x, y, pixel) ->
    i = y * imageData.width * 4 + x * 4
    d = imageData.data
    d[i] =   pixel[0]
    d[i+1] = pixel[1]
    d[i+2] = pixel[2]
    d[i+3] = pixel[3]
    

