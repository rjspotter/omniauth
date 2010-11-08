require 'omniauth/core'

module OmniAuth
  module Strategies
    autoload :OAuth,              'omniauth/strategies/oauth'
    autoload :OAuthWrap,          'omniauth/strategies/oauth_wrap'
    autoload :OAuth2,             'omniauth/strategies/oauth2'
    
    autoload :Twitter,            'omniauth/strategies/twitter'
    autoload :LinkedIn,           'omniauth/strategies/linked_in'
    autoload :Facebook,           'omniauth/strategies/facebook'
    autoload :GitHub,             'omniauth/strategies/github'
    autoload :ThirtySevenSignals, 'omniauth/strategies/thirty_seven_signals'
    autoload :Myspace,            'omniauth/strategies/myspace'
    autoload :Windows,            'omniauth/strategies/windows'

  end
end
