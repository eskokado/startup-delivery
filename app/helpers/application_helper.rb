module ApplicationHelper
  def convert_to_id(resource)
    resource.name.to_s.parameterize.concat("-#{resource.id}")
  end
end
