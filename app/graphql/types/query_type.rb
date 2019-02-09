module Types
    class QueryType < BaseObject
      # ---- User ----
      field :me, UserType, null: true
      def me(demo: false)
        context[:current_user]
      end

      # Use this if you want to enable a demo feature in your product
      # create a static json file under graphql/models
    #   def me(demo: false)
    #     if demo || !context[:current_user] 
    #       JSON.parse(File.read(File.join(Rails.root, 'app', 'graphql', 'models', 'demoprofile.json')))
    #     else
    #       context[:current_user]
    #     end
    #   end
  
    end
  end
  