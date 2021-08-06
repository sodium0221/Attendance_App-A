class StaticPagesController < ApplicationController
  def top
    @condition = logged_in?
  end
end
