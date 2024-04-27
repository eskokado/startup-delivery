json.extract! product, :id, :name, :description, :long_description,
              :client_id, :created_at, :updated_at
json.url manager_product_url(product, format: :json)
