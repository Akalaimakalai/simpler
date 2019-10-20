class TestsController < Simpler::Controller

  def index
    @time = Time.now
  end

  def new
  end

  def create

  end

  def show
    @params = params
  end

end
