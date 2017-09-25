Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
# user controller routes 
  post '/login' => 'user#log_in_handler'
  get  '/home' => 'user#main_home'
  get  '/' => 'user#form_loader'
  get  '/view_settings' => 'user#settings_event_handler'
  get  '/add_user_page_loader' => 'user#add_user_page_loader_handler'
  post '/add_user' => 'user#add_user'
  get  '/view_user_page_loader' => 'user#view_user_page_loader_handler'


# ward controller routes
  get  '/ward_main_page_loader' => 'ward#ward_main_page_loader_handler'
  get  '/add_ward_page_loader' => 'ward#add_ward_page_loader_handler'


  post '/add_ward' => 'ward#add_ward'

#target lab controller routes
  get '/target_lab_main_page_loader' => 'target_lab#target_lab_main_page_loader_handler'
  get '/add_target_lab_page_loader' => 'target_lab#add_targer_lab_page_loader_handler'

  post '/add_target_lab' => 'target_lab#add_target_lab'  
  post '/delete_lab' => 'target_lab#delete_target_lab' 
  get "/get_labs" => 'target_lab#get_labs'


#patient controller routes
  get '/scan_patient_barcode' => 'patient#home_scan_patient_handler'

#roles controller routes
  get 'roles_page' => 'roles#roles_page_loader_handler'
  post '/system_roles' => 'roles#insert_update_user_roles'

#specimen controller routes
 
#test_order controller routes
  post '/remove_test' => 'test#remove_test_from_order'
  get '/remove_test' => 'test#remove_test_from_order'

#sample order controller routes
  get  '/sample_ordering' => 'sample_order#home'
  post '/capture_order_details' => 'sample_order#capture_order_details'
  get  '/confirm_order' => 'sample_order#confirm_order'
  get  '/view_results' => 'sample_order#view_sample_test_results'
  get  '/view_individual_test_results' => 'sample_order#view_individual_sample_test_results'
  get  '/view_sample' => 'sample_order#view_sample_to_add_new_test_handler'
  get  '/sample_tests' => 'sample_order#view_sample_test_handler'
  get  '/draw_sample' => 'sample_order#draw_sample_handler'
  post '/submite_order' => 'sample_order#submite_order'
  get  '/submite_order' => 'sample_order#submite_order'
  get  '/result_meausures' => 'sample_order#get_result_measures'
  get  '/request_order' => 'sample_order#order_request_page_loader_handler'
  post '/capture_order_request_details' => 'sample_order#capture_order_request_details'

#hitting remote resources
  post '/lab_samples' => 'sample_order#get_samples'
  get '/lab_samples' => 'sample_order#get_samples'
  get '/get_test_types' => 'sample_order#get_test_types'

  
#test controller routes
  get  '/add_test' => 'test#add_test_handler'
  post '/add_test_to_order' => 'test#add_test'
  get  '/orders' => 'test#add_test_loader_handler'
  get  '/adding_test' => 'test#add_test_to_sample_loader_handler'
  post '/add_test_to_sample' => 'test#add_test_to_sample'

#system point of starting
  root 'user#form_loader'

end
