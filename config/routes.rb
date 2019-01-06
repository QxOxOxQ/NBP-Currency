Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do
    scope module: :v1 do
         get '/nbp_currencies', to: 'nbp_currencies#index'
       end
    end
end
