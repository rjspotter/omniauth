
require 'omniauth/core'

module OmniAuth
  module Stores
    
    autoload :Base, 'omniauth/stores/base'
    autoload :Redis, 'omniauth/stores/redis'

  end
end
