class StaticController < ApplicationController
    def landing 
        puts("HER")
        render "static/landing"
    end
end
