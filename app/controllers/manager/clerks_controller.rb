module Manager
  class ClerksController < InternalController
    def index
      @clerks = Clerk.all
    end
  end
end
