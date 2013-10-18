json.array!(@todos) do |todo|
  json.extract! todo, :name, :finished
  json.url todo_url(todo, format: :json)
end
