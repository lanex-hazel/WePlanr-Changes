Rails.application.routes.draw do
  # handle js.map gracefully with 404
  get '/maps/scripts/*', to: 'pages#not_found'

  scope :api do
    resources :pages, only: :index

    scope module: :client do
      post 'register', to: 'registrations#create'
      post 'register/vendor', to: 'vendor_registrations#create'
      post 'register/vendor/:invite_token', to: 'vendor_registrations#create_from_invite'
      get  'verify_invite_token/:invite_token', to: 'vendor_registrations#verify_invite_token'

      patch 'users/forgot_password', to: 'users#forgot_password'
      patch 'users/reset_password', to: 'users#reset_password'
      get 'users/verify_reset_token', to: 'users#verify_reset_token'
      get 'users/bookings', to: 'users#bookings'
      get 'weddings/profile/:uid', to: 'weddings#profile'

      get 'organisr', to: 'organisr#index'
      resources :categories, only: %i(index show)

      namespace :organisr do
        resources :outside_vendors, only: %i(create update)
        patch ':type/:todo_id/bookings/:id/link', to: 'bookings#link'
      end
      post 'organisr/:type', to: 'organisr#create'
      patch 'organisr/:type/:id', to: 'organisr#update'
      patch 'organisr/:type/:id/restore', to: 'organisr#restore'
      delete 'organisr/:type/:id', to: 'organisr#destroy'

      resource :auth_tokens, only: %i(create destroy) do
        collection do
          patch :confirm
        end
      end
      resource :profile, only: %i(show update destroy) do
        get :favorites
        get :calendar

        resources :bank_accounts, only: %i(index create destroy)
        resources :bank_cards, only: %i(index create destroy)
      end

      resource :wedding, only: %i(show update)
      resources :messages, only: %i(index create show) do
        get :snippets, on: :collection
      end
      resources :referrals, only: %i(index create)
      resource :reward, only: %i(show)
      resources :invoices, only: [:index, :show]
      resources :transactions, only: :index
      resources :my_vendors, only: %i(index show create update) do
        get :earnings, on: :collection
        get :statistics, on: :member

        resources :quotes, only: %i(create show index) do
          get 'draft', on: :collection

          member do
            patch :accept
            patch :fulfill
            patch :reject
          end
        end

        resources :pricing_and_packages, only: %i(index create update destroy)
        resources :unavailable_dates, only: %i(index create destroy)
        resources :photos, only: %i(create destroy)
        resources :messages, only: %i(index create show), module: :my_vendors do
          get :snippets, on: :collection
        end
        resources :bookings, only: %i(index create update destroy)
        resources :referrals, only: %i(index create), module: :my_vendors
      end

      resources :vendors, only: %i(index show) do
        get :featured, on: :collection

        member do
          post :favorite
          delete :unfavorite
          get :events
          patch :cover_photo
        end
      end

      resources :services, only: :index
      resources :tags, only: :index
      resources :locations, only: :index
      resources :todos, only: :index do
        get :dashboard, on: :collection
        resources :notes, only: :create, controller: 'todos/notes'
      end
      resources :custom_todos, only: %i(create update destroy)
      resources :outside_vendors, only: %i(create update)
      resources :features, only: :show
    end

    namespace :admin do
      #constraints subdomain: 'api' do
        resource :auth_tokens, only: %i(create destroy)
        post 'login_as/:id', to: 'auth_tokens#login_as'

        get :dashboard, to: 'dashboard#index'
        get :generate_sitemap, to: 'dashboard#generate_sitemap'

        post 'vendors/csv_upload', to: 'uploads#vendor_csv'
        post 'vendors/:id/photos', to: 'uploads#vendor_photos'

        resources :features, only: %i(index show update)
        resources :conversations, only: %i(index show)
        resources :reward_transactions, only: %i(index update) do
          get :csv, on: :collection
        end
        resources :referrals, only: %i(index update) do
          get :csv, on: :collection
        end
        resources :quotes, only: %i(index show) do
          collection do
            get :csv
            get :csv_booked
            get :bookings
          end
        end
        resources :todos, only: %i(index show update)
        resources :users, only: %i(index show) do
          get :csv, on: :collection
        end
        resources :vendors do
          get :csv, on: :collection
          resources :photos, module: :vendors, only: %(index)

          member do
            post :invite
            patch :profile_photo
            patch :cover_photo
          end
        end
        resources :photos
      #end
    end
  end
end
