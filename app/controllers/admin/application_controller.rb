# All Administrate controllers inherit from this
# `Administrate::ApplicationController`, making it the ideal place to put
# authentication logic or other before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    # before_action :authenticate_admin
    # def authenticate_admin
    #   # TODO Add authentication logic here.
    # end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end

    before_action :require_basic_auth, if: -> { Rails.env.production? }

    private

    def require_basic_auth
      if ENV["ADMIN_USERNAME"].blank? || ENV["ADMIN_PASSWORD"].blank?
        render plain: "Authentication not configured", status: :forbidden
        return
      end

      authenticate_or_request_with_http_basic do |username, password|
        ActiveSupport::SecurityUtils.secure_compare(username, ENV["ADMIN_USERNAME"]) &&
          ActiveSupport::SecurityUtils.secure_compare(password, ENV["ADMIN_PASSWORD"])
      end
    end
  end
end
