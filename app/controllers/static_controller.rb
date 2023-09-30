class StaticController < ApplicationController
    def landing 
        @sidebar_state = "login"
        render "static/landing"
    end
end
