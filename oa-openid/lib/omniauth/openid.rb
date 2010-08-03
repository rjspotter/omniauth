require 'omniauth/core'

module OmniAuth
  module Strategies
    autoload :OpenID, 'omniauth/strategies/open_id'
    autoload :Google, 'omniauth/strategies/google'
    autoload :Yahoo,  'omniauth/strategies/yahoo'
    autoload :Aol,    'omniauth/strategies/aol'
  end
end
