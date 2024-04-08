module ApplicationHelper
  def convert_to_id(resource)
    if resource.respond_to?(:name) && !resource.name.nil?
      resource.name.to_s.parameterize.concat("-#{resource.id}")
    else
      "#{resource}-#{resource.id}"
    end
  end
end
