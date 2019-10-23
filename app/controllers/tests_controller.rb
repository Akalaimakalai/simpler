class TestsController < Simpler::Controller

  def index
    render 'tests/list', headers: {"New header" => "just for test"}
  end

  def new
  end

  def create

  end

  def show
    @params = params
  end

end
