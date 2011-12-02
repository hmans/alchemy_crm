AlchemyCrm::Engine.routes.draw do

  match '/recipients/reads/:id' => 'recipients#reads',
    :as => 'recipient_reads'
  match '/recipients/reacts/:id' => 'recipients#reacts',
    :as => 'recipient_reacts'
  match '/contacts/verify/:sha1/:element_id' => 'contacts#verify',
    :as => 'verify_mailing'
  match '/contacts/destroy/:sha1/:element_id' => 'contacts#destroy',
    :as => 'destroy_contact'
  match '/subscriptions/destroy/:newsletter_id/:sha1/:element_id' => 'subscriptions#destroy',
    :as => 'signout_from_newsletter'
  match '/admin/elements/teasables' => 'admin/elements#teasables',
    :as => 'teasable_elements'

  resources :mailings, :only => :show

  resources :contacts, :except => [:index, :show, :new, :create, :edit, :update, :destroy] do
    collection do 
      post :signup
      get :signout, :verify
    end
  end

  resources :subscriptions

  namespace :admin do

    resources :contacts do
      collection do
        get :import
        get :autocomplete_tag_list
        post :import
      end
      member { get :export }
    end

    resources :contact_groups do
      collection { get :add_filter }
    end

    resources :tags, :newsletters

    resources :deliveries do
      member { get :pdf }
    end

    resources :mailings do
      resources :deliveries
      collection { get :signout }
      member do
        get :copy
        get :edit_content
      end
    end

  end

end
