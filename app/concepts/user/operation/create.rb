require 'reform/form/dry'

class User < ActiveRecord::Base
  class Create < Trailblazer::Operation
    include Model

    model User, :create

    contract Contract::Create do
      feature Reform::Form::Dry
      property :confirm_password, virtual: true
      
      
      validation do
        configure do
          config.messages_file = 'config/error_messages.yml'
        end
        
        required(:confirm_password).filled

        rule(must_be_equal?: [:password, :confirm_password]) do |a, b|
          a.eql?(b) 
        end
      end
    end

    def process(params)
      validate(params) do
        update!
        contract.save
      end
    end

  private
    def update!
      auth = Tyrant::Authenticatable.new(contract.model)
      auth.digest!(contract.password) # contract.auth_meta_data.password_digest = ..
      auth.confirmed!
      auth.sync
    end

  end
end