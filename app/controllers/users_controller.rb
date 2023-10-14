class UsersController < ApplicationController
    before_action :authorized?

    def get
        @user = current_user
        @sidebar_state = @user.permission_level
    end
end
