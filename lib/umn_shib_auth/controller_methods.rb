module UmnShibAuth
  module ControllerMethods
    def self.included(controller)
      controller.class_eval do
        helper_method :shib_login_and_redirect_url, :shib_logout_and_redirect_url, :shib_logout_url, :shib_umn_session
      end
      if UmnShibAuth.using_stub_internet_id?
        puts "[umn_shib_auth] ENV['STUB_INTERNET_ID'] detected, shib_umn_session will be stubbed with internet_id=#{UmnShibAuth.stub_internet_id} for all requests.
              You can also hit this in the console via UmnShibAuth.session_stub
        "
      end
    end
 
    def shib_umn_session
      if UmnShibAuth.using_stub_internet_id?
        UmnShibAuth.session_stub
      else
        # TODO: the implementation.
      end
    end

    ###############
    # URL HELPERS #
    ###############
    def shib_login_and_redirect_url(redirect_url=nil)
      url='TODO'
      return url
    end
 
    def shib_logout_url
      url='TODO'
      return url
    end

    def shib_logout_and_redirect_url(redirect_url=nil)
      url='TODO'
      return url
    end
    
    # BEFORE FILTER
    def shib_umn_auth_required
      return true if UmnShibAuth.using_stub_x500?
      # TODO: implementation
    end
  end
end
