json.extract! category, :id, :name, :description, :image,
              :client_id, :created_at, :updated_at
json.url manager_category_url(category, format: :json)
