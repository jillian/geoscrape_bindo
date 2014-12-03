class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end





    when "N" then [@coordinates[0], @coordinates[1]+1 ]
    when "S" then [@coordinates[0], @coordinates[1]-1 ]
    when "E" then [@coordinates[0]+1, @coordinates[1]]
    when "W" then [@coordinates[0]-1, @coordinates[1]]