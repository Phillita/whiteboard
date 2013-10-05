# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  setup_container()
  document.addEventListener("page:load", setup_container)
  
@setup_container = ->
  draw()
  resize_table()
  window.onresize = (e) ->
    draw()
    resize_table()

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
    ticket_images = []
    grid = []
    imageObj = new Image()

    grid[num] = [] for num in [0..rows]
    for arr in grid 
      do ->
        arr[n] = 0 for n in [0..cols]

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

    # add rows
    layer.add(row_line) for row_line in row_lines

    # add columns
    layer.add(column_line) for column_line in column_lines

    $.ajax document.URL + '/tickets.json',
        type: 'GET'
        dataType: 'html'
        async: false
        error: (jqXHR, textStatus, errorThrown) ->
          $('body').prepend "Failed to process tickets."
        success: (data, textStatus, jqXHR) ->
          tickets = JSON.parse data
          imageObj.onload = ->
            # for ticket_number in [0..tickets.length-1 ]
            #   do ->
            #     t = tickets[ticket_number]
            #     grid[t.row.order-1][t.column.order-1] = grid[t.row.order-1][t.column.order-1] + 1
                
            #     ticket_images[ticket_number] = new Kinetic.Image({
            #       x: (column_width * t.column.order) + (grid[t.row.order-1][t.column.order-1]*5),
            #       y: (row_height * t.row.order) + (grid[t.row.order-1][t.column.order-1]*5),
            #       image: imageObj,
            #       width: 30,
            #       height: 30
            #     })

            # layer.add(ticket) for ticket in ticket_images

            # stage.add(layer)
            set_up_tickets(grid, tickets, ticket_images, column_width, row_height, imageObj, layer, stage)

    imageObj.src = $('#container').data('stickey')

@set_up_tickets = (grid, tickets, ticket_images, column_width, row_height, imageObj, layer, stage) ->
  if tickets.length > 0
    for ticket_number in [0..tickets.length-1 ]
      do ->
        t = tickets[ticket_number]
        row_offset = Math.floor(grid[t.row.order-1][t.column.order-1]/6.0)
        col_offset = grid[t.row.order-1][t.column.order-1] - (row_offset*6)
        ticket_images[ticket_number] = new Kinetic.Image({
          x: (column_width * t.column.order) + (col_offset*(column_width/6.0)),
          y: (row_height * t.row.order) + (row_offset * (row_height/3.0)),
          image: imageObj,
          width: column_width/6.0,
          height: row_height/3.0 
        })
        grid[t.row.order-1][t.column.order-1] = grid[t.row.order-1][t.column.order-1] + 1

        ticket_images[ticket_number].on('click', ->
          window.location = document.domain + "/tickets/" + t.id
        )

  layer.add(ticket) for ticket in ticket_images

  stage.add(layer)

@find_column_row_width_height = (stage_width_height, cols_rows) ->
  stage_width_height/cols_rows

@resize_table = () ->
  if $("#container").length > 0
    init_height = $("#container").height()
    rows = $('#container').data("rows")
    $(".row_header").each(
      () ->
        $(this).height(init_height/rows)
    )

    init_width = $("#container").width()
    cols = $('#container').data("columns")
    $(".column_header").each(
      () ->
        $(this).width(init_width/cols)
    )