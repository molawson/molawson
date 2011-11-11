Molawson::Application.routes.draw do

  scope "/admin" do
    resources :posts
  end
  
  get "/blog"  => "posts#blog", :as => "blog"
  get "/blog/:slug" => "posts#show", :as => "blog_post"

  match "/admin" => redirect("/admin/posts")

  match "/clients" => "pages#clients", :as => "clients"

  root :to => "pages#home"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
