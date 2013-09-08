# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  if $('#container').length > 0
    document.addEventListener("page:change", draw);
    draw()
    window.onresize = (e) ->
      draw()

@draw = () ->
  if $('#container').length > 0
    stage = new Kinetic.Stage({
      container: 'container',
      width: $('#container').width(),
      height: $('#container').width()/2
    })

    layer = new Kinetic.Layer()

    tooltip = new Kinetic.Label({
      x: $('#container').width()/4,
      y: 40,
      opacity: 0.75
    })

    tooltip.add(new Kinetic.Tag({
      fill: 'black',
      pointerDirection: 'down',
      pointerWidth: 10,
      pointerHeight: 10,
      lineJoin: 'round',
      shadowColor: 'black',
      shadowBlur: 10,
      shadowOffset: 10,
      shadowOpacity: 0.5
    }))
    
    tooltip.add(new Kinetic.Text({
      text: 'Column 1',
      fontFamily: 'Calibri',
      fontSize: 18,
      padding: 5,
      fill: 'white'
    }))

    horizontalline = new Kinetic.Line({
      points: [{x:0,y:$('#container').width()/4},{x:$('#container').width(),y:$('#container').width()/4}],
      stroke: 'black',
      strokeWidth: 2,
    })

    verticalline = new Kinetic.Line({
      points: [{x:$('#container').width()/2,y:0},{x:$('#container').width()/2,y:$('#container').width()/2}],
      stroke: 'black',
      strokeWidth: 2,
    })

    rect = new Kinetic.Rect({
      x: 0,
      y: 0,
      width: stage.getWidth(),
      height: stage.getHeight(),
      fill: 'white',
      stroke: 'black',
      strokeWidth: 2
    })

    # add the shape to the layer
    layer.add(rect).add(horizontalline).add(verticalline).add(tooltip)

    # add the layer to the stage
    stage.add(layer)

  