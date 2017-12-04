Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
# user controller routes 
  post '/login' => 'user#log_in_handler'
  get  '/home' => 'user#main_home'
  get  '/' => 'user#device_selector'
  get  '/view_settings' => 'user#settings_event_handler'
  get  '/add_user_page_loader' => 'user#add_user_page_loader_handler'
  post '/add_user' => 'user#add_user'
  get  '/view_user_page_loader' => 'user#view_user_page_loader_handler'
  post '/search_by_username' => 'user#search_user_by_username'
  get  '/search_by_username' => 'user#search_user_by_username'
  get  '/delete_user' => 'user#delete_user'
  get  '/log_out' => 'user#log_out'
  get  'user/tab_home_page_loader'
  get  'user/tab_log_in'
  get  'user/form_loader'


#dispatch controller routes
  get '/un_dispatched_samples' => 'dispatch_sample#dispatch_sample_main_page_loader_handler'
  get '/undispatched_samples' => 'dispatch_sample#retrive_undispatched_samples'
  get '/view_undispatched_samples' => 'dispatch_sample#view_undispatched_sample'
  get '/capture_dispatcher' => 'dispatch_sample#capture_dispatcher'
  post '/save_dispatcher_details' => 'dispatch_sample#save_dispatcher_details'
  get  '/dispatch_sample' => 'dispatch_sample#dispatch_sample'

#undrawn samples routes
  post '/draw' => 'sample_order#draw_sample'
  get  '/draw' => 'sample_order#draw_sample'

# ward controller routes
  get  '/ward_main_page_loader' => 'ward#ward_main_page_loader_handler'
  get  '/add_ward_page_loader' => 'ward#add_ward_page_loader_handler'
  post '/delete_ward' => 'ward#delete_ward'
  post '/add_ward' => 'ward#add_ward'

# special roles routes
  get  '/special_role_page_loader' => 'special_roles#special_role_page_loader_handler'

#target lab controller routes
  get '/target_lab_main_page_loader' => 'target_lab#target_lab_main_page_loader_handler'
  get '/add_target_lab_page_loader' => 'target_lab#add_targer_lab_page_loader_handler'

  post '/add_target_lab' => 'target_lab#add_target_lab'  
  post '/delete_lab' => 'target_lab#delete_target_lab' 
  get "/get_labs" => 'target_lab#get_labs'
  get  '/get_lab' => 'target_lab#get_lab'


#patient controller routes
  get '/scan_patient_barcode' => 'patient#home_scan_patient_handler'
  get '/scan_patient' => 'patient#scan_patient'
  get '/search_patient_by_id' => 'patient#search_patient_by_id'
  get '/search_patient' => 'patient#search_patient_by_id_page_loader_handler'
  get '/tab_patient_search_option' => 'patient#tab_patient_search_option'
  get '/tab_search_patient_by_name' => 'patient#tab_search_patient_by_name'
  post '/get_patient_details' => 'patient#search_patient_by_name'
  get  '/search_patient_by_npid' => 'patient#tab_search_patient_by_npid_loader'
  get  '/search_patient_by_name' => 'patient#work_search_patient_by_name'
  get  '/work_search_pa_by_name' => 'patient#work_search_pa_by_name'
  get  '/patient_dashboard' => 'patient#patient_dashboard'
  get  '/patients_found' => 'patient#patients_found'
  get  '/tab_patient_dashboard' => 'patient#tab_patient_dashboard'

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
  get  '/print_tracking_number' => 'sample_order#print_tracking_number'
  get  '/print' => 'sample_order#print'
  get  '/get_patient_results' => "sample_order#tab_view_sample_results"
  get  '/tab_view_individual_results' => "sample_order#tab_view_individual_sample_test_results"
  get  '/tab_request_sample' => 'sample_order#tab_request_sample'
  get  '/retrive_sample' => 'sample_order#get_sample'
  post '/post_tab_request_order' => 'sample_order#tab_submite_order_request'
  get  '/print_barcode' => 'sample_order#print_barcode'
  get  '/print_sample_barcode' => 'sample_order#print_sample_barcode'
  get  '/get_samples_to_be_drawn' => 'sample_order#get_samples_to_be_drawn'
  get  '/print_sample' => 'sample_order#print_sample'
  get  '/order_request' => 'sample_order#submite_order_request'
  get  '/view_recent_result'  => 'sample_order#view_recent_result'
  get  '/scan_samples' => 'sample_order#scan_undrawn'
  get  '/save_try' => 'sample_order#save_try'
  get  '/tab_view_recent_result' => 'sample_order#tab_view_recent_result'

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
  get  '/tab_select_tests' => 'test#tab_select_test'



#system point of starting
  root 'user#form_loader'

end
