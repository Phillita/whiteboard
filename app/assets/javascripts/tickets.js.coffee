# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
jQuery ->
  document.addEventListener("page:load", setup_ticket_form)
  setup_ticket_form()
@setup_ticket_form = ->
  if $("#tickets-form").length > 0
    if $('select#ticket_board_id').length > 0
      $('select#ticket_board_id').change ->
        board_id = $('option:selected',this).val()
        $('select#ticket_column_id').empty()
        $('select#ticket_row_id').empty()

        host = window.location.host
        $.get "http://" + host + '/boards/' + board_id + '/columns.json', ( data ) ->
          $('select#ticket_column_id').append('<option value="Select a Column">Select a Column</option>')
          $('select#ticket_column_id').append('<option value="' + col.id + '">' + col.label + '</option>') for col in data

        $.get "http://" + host + '/boards/' + board_id + '/rows.json', ( data ) ->
          $('select#ticket_row_id').append('<option value="Select a Row">Select a Row</option>')
          $('select#ticket_row_id').append('<option value="' + row.id + '">' + row.label + '</option>') for row in data