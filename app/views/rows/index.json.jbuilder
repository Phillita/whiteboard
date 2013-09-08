json.array!(@rows) do |row|
  json.extract! row, :board_id, :order, :label
  json.url row_url(row, format: :json)
end
