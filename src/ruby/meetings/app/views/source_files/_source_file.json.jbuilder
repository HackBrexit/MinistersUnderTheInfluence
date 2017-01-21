json.extract! source_file, :id, :location, :uri, :created_at, :updated_at
json.url source_file_url(source_file, format: :json)