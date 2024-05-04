json.extract! clerk, :id, :name, :document, :phone,
              :person, :client_id, :created_at, :updated_at
json.url manager_clerk_url(clerk, format: :json)
