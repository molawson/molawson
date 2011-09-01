Molawson::Application.routes.draw do

  scope "/admin" do
    resources :posts
    get "/invoices" => "invoices#index", :as => "invoices"
    get "/invoices/:id" => "invoices#show", :as => "invoice"
  end
  
  get "/blog"  => "posts#blog", :as => "blog"
  get "/blog/:slug" => "posts#show", :as => "blog_post"

  match "/admin" => redirect("/admin/posts")
  
  scope "/clients" do
    get "/invoices/:client_key" => "invoices#show", :as => "client_invoice"
  end

  root :to => "pages#home"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
