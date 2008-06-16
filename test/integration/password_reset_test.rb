require "#{File.dirname(__FILE__)}/../test_helper"

class PasswordResetTest < ActionController::IntegrationTest
  def test_random_stuff
    dude = session_dude
    dude.visits_index
    dude.shows_login
    dude.fails_to_log_in
    dude.asks_for_password_reset
  end
  
  private
  
  def session_dude
    open_session do |session|
      class << session
        def visits_index
          get "/"
          assert_response :success
          assert_template "index/index"
        end
        
        def shows_login
          get "/login"
          assert_response :success
        end
        
        def fails_to_log_in
          post "/sessions/create", :user => {:username => "august", :password => "wrooong"}
          assert_template 'sessions/new'
        end
        
        def asks_for_password_reset
          user = users(:august)
          old_password = user.password_hash.dup
          
          put "/profile/reset_password", :user => {:identification => 'august'}
          assert_response :redirect
          assert_not_equal old_password, user.reload.password_hash
        end
      end
    end
  end
end