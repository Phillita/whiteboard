json.array!(@columns) do |column|
  json.extract! column, :board_id, :order, :label
  json.url column_url(column, format: :json)
end
