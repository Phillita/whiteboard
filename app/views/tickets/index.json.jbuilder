json.array!(@tickets) do |ticket|
  json.extract! ticket, :story, :pithy_tag, :description, :requirements_points, :development_points, :board_id, :column_id, :row_id
  json.url ticket_url(ticket, format: :json)
end
