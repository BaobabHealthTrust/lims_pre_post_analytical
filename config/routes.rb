Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
# user controller routes 
  post '/login' => 'user#log_in_handler'
  get  '/home' => 'user#main_home'
  get  '/' => 'user#form_loader'


#patient controller routes
  get '/scan_patient_barcode' => 'patient#home_scan_patient_handler'


#specimen controller routes
 
#test_order controller routes
  get  '/sample_ordering' => 'sample_order#home'
  post '/capture_order_details' => 'sample_order#capture_order_details'
  get  '/confirm_order' => 'sample_order#confirm_order'

#sample order controller routes
  get  '/view_results' => 'sample_order#view_sample_test_results'
  get  '/view_individual_test_results' => 'sample_order#view_individual_sample_test_results'
  get  '/view_sample' => 'sample_order#view_sample_to_add_new_test_handler'
  get  '/sample_tests' => 'sample_order#view_sample_test_handler'
  get  '/draw_sample' => 'sample_order#draw_sample_handler'
  
#test controller routes
  get '/add_test' => 'test#add_test_handler'

#system point of starting
  root 'user#form_loader'

end
