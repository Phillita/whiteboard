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
    cols = $('#container').data("columns")
    rows = $('#container').data("rows")

    stage = new Kinetic.Stage({
      container: 'container',
      width: $('#container').width(),
      height: $('#container').width()/2
    })

    column_width = find_column_row_width_height(stage.getWidth(), cols)
    row_height = find_column_row_width_height(stage.getHeight(), rows)

    layer = new Kinetic.Layer()

    row_lines = []
    column_lines = []
    
    row_lines[num] = new Kinetic.Line({
      points: [{x:0,y:(row_height*(num+1))},{x:stage.getWidth(),y:(row_height*(num+1))}],
      stroke: 'black',
      strokeWidth: 1,
    }) for num in [0..rows]

    column_lines[num] = new Kinetic.Line({
      points: [{x:(column_width*(num+1)),y:0},{x:(column_width*(num+1)),y:stage.getHeight()}],
      stroke: 'black',
      strokeWidth: 1,
    }) for num in [0..cols]

    # tooltip = new Kinetic.Label({
    #   x: $('#container').width()/4,
    #   y: 40,
    #   opacity: 0.75
    # })

    # tooltip.add(new Kinetic.Tag({
    #   fill: 'black',
    #   pointerDirection: 'down',
    #   pointerWidth: 10,
    #   pointerHeight: 10,
    #   lineJoin: 'round',
    #   shadowColor: 'black',
    #   shadowBlur: 10,
    #   shadowOffset: 10,
    #   shadowOpacity: 0.5
    # }))
    
    # tooltip.add(new Kinetic.Text({
    #   text: 'Column 1',
    #   fontFamily: 'Calibri',
    #   fontSize: 18,
    #   padding: 5,
    #   fill: 'white'
    # }))

    # horizontalline = new Kinetic.Line({
    #   points: [{x:0,y:$('#container').width()/4},{x:$('#container').width(),y:$('#container').width()/4}],
    #   stroke: 'black',
    #   strokeWidth: 2,
    # })

    # verticalline = new Kinetic.Line({
    #   points: [{x:$('#container').width()/2,y:0},{x:$('#container').width()/2,y:$('#container').width()/2}],
    #   stroke: 'black',
    #   strokeWidth: 2,
    # })

    # Stage border
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
    layer.add(rect)
    layer.add(row_line) for row_line in row_lines
    layer.add(column_line) for column_line in column_lines
    # .add(horizontalline).add(verticalline)
    #.add(tooltip)

    # add the layer to the stage
    stage.add(layer)

@find_column_row_width_height = (stage_width_height, cols_rows) ->
  stage_width_height/cols_rows