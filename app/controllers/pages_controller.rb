class PagesController < ApplicationController
  def blank
    head 200, content_type: "text/html"
  end
end