class PageController < ApplicationController
  LAYOUT_ACTIONS = %i[integrations team billing notifications settings
                      activity profile people calendar assignments
                      message messages project projects dashboard].freeze

  LAYOUT_ACTIONS.each do |action|
    define_method(action) do
      render layout: 'admin'
    end
  end

  def pricing; end

  def about; end
end
