# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

jQuery ->
  setup_container()
  document.addEventListener("page:load", setup_container)
  
@setup_container = ->
  if $('#container').length > 0
    tickets = []
    $.ajax document.URL + '/tickets.json',
      type: 'GET'
      dataType: 'html'
      async: false
      error: (jqXHR, textStatus, errorThrown) ->
        $('body').prepend "Failed to process tickets."
      success: (data, textStatus, jqXHR) ->
        tickets = JSON.parse data
    draw(tickets)
    resize_table()
    window.onresize = (e) ->
      draw(tickets)
      resize_table()

@draw = (tickets) ->
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
    labels = []
    ticket_groups = []
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

    imageObj.onload = ->
      set_up_tickets(grid, tickets, ticket_images, labels, ticket_groups, column_width, row_height, imageObj, layer, stage)

    imageObj.src = $('#container').data('stickey')

@set_up_tickets = (grid, tickets, ticket_images, labels, ticket_groups, column_width, row_height, imageObj, layer, stage) ->
  if tickets.length > 0
    for ticket_number in [0..tickets.length-1 ]
      do ->
        t = tickets[ticket_number]

        row_offset = Math.floor(grid[t.row.order][t.column.order]/6.0)
        col_offset = grid[t.row.order][t.column.order] - (row_offset*6)
        x_val = (column_width * t.column.order) + (col_offset*(column_width/6.0))
        y_val = (row_height * t.row.order) + (row_offset * (row_height/3.0))

        ticket_groups[ticket_number] = new Kinetic.Group({
          x: x_val,
          y: y_val,
          draggable: true
        })

        labels[ticket_number] = new Kinetic.Label({
          # x: x_val+3,
          # y: y_val+3,
          opacity: 0.75
        })
        
        labels[ticket_number].add(new Kinetic.Text({
          text: t.id,
          fontFamily: 'Calibri',
          fontSize: 12,
          padding: 5,
          fill: 'black'
        }))

        ticket_images[ticket_number] = new Kinetic.Image({
          # x: x_val,
          # y: y_val,
          image: imageObj,
          width: column_width/6.0,
          height: row_height/3.0
        })

        ticket_groups[ticket_number].add ticket_images[ticket_number]
        ticket_groups[ticket_number].add labels[ticket_number]

        # the number of tickets in a cell (helps with ticket offsets)
        grid[t.row.order][t.column.order] = grid[t.row.order][t.column.order] + 1

        # click method to send off to ticket detail
        ticket_groups[ticket_number].on 'click', ->
          window.location = document.domain + "/tickets/" + t.id

        # drag method to update ticket
        ticket_groups[ticket_number].on 'dragend', ->
          update_ticket_cols_and_rows(this, t, column_width, row_height)

        # pointer styles
        ticket_groups[ticket_number].on 'mouseover', ->
          document.body.style.cursor = 'pointer'
        ticket_groups[ticket_number].on 'mouseout', ->
          document.body.style.cursor = 'default'
  layer.add(group) for group in ticket_groups

  stage.add(layer)

@update_ticket_cols_and_rows = (obj, t, column_width, row_height) ->
  c = parseInt obj.getX()/column_width
  r = parseInt obj.getY()/row_height
  if t.row.order != r || t.column.order != c
    $.ajax document.URL + '/tickets/' + t.id + '/update_cols_and_rows?row=' + r + '&column=' + c,
      type: 'POST'
      timeout:8000
      dataType: 'json'
      async: true
      error: (jqXHR, textStatus, errorThrown) ->
        if $("#status").length
          $("#status-msg")[0].innerHTML = "Failed to update ticket."
          $("#status").toggleClass( "alert-error", true )
          $("#status").toggleClass( "alert-success", false )
          $("#status").show
        else
          $('body').prepend '<div id="status" class="alert alert-error">
            <a class="close" data-dismiss="alert">&#215;</a>
            <div id="status-msg">Failed to update ticket ' + t.id + '.</div>
          </div>'
      success: (data, textStatus, jqXHR) ->
        if $("#status").length
          $("#status-msg")[0].innerHTML = 'Successfully updated ticket ' + data.id + '!'
          $("#status").toggleClass( "alert-error", false )
          $("#status").toggleClass( "alert-success", true )
          $("#status").show
        else
          $('body').prepend '<div id="status" class="alert alert-success">
            <a class="close" data-dismiss="alert">&#215;</a>
            <div id="status-msg">Successfully updated ticket ' + data.id + '!</div>
          </div>'
        t.row.order = r 
        t.column.order = c

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