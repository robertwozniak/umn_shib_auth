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
        @shib_umn_session ||= UmnShibAuth::Session.new(:eppn => UmnShibAuth.stub_internet_id)
      else
        if request.env['eppn'].blank?
          @shib_umn_session = nil
        else
          @shib_umn_session ||= UmnShibAuth::Session.new(:eppn => request.env['eppn'])
        end
      end
      @shib_umn_session
    end

    ###############
    # URL HELPERS #
    ###############
    def shib_login_and_redirect_url(redirect_url=nil)
      redirect_url ||= request.url
      encoded_redirect_url = ERB::Util.url_encode(redirect_url)
      "https://#{request.host}/Shibboleth.sso/Login?target=#{encoded_redirect_url}"
    end
 
    def shib_logout_url
      "https://#{request.host}/Shibboleth.sso/Logout"
    end

    def shib_logout_and_redirect_url(redirect_url=nil)
      redirect_url ||= request.url
      encoded_redirect_url = ERB::Util.url_encode(redirect_url)
      "https://#{request.host}/Shibboleth.sso/Logout?return=#{encoded_redirect_url}"
    end
    
    # Since we are expecting the web server to be propogating the logged in user variable
    # this simply tells the user that there was an error.
    #
    def shib_umn_auth_required
      return true if UmnShibAuth.using_stub_internet_id?
      if shib_umn_session.nil?
        render :text => "Sorry, an unexpected error has occurred (Shibboleth authentication credentials are not available).
                         Please contact the administer of this page if this error persists.", :status => 403 and return false
      else
        return true
      end
    end
  end
end
