class PagesController < ApplicationController
  def index
  end

  def backend_error
    raise StandardError, "This is a test backend error."
  end

  def frontend_error
  end
end
