# name: discourse-course-progress
# about: Returns true historical read progress for categories configured with Docs index topics.
# version: 0.1
# authors: Zsolt

enabled_site_setting :course_progress_enabled

after_initialize do
  # Load the controller
  load File.expand_path('../app/controllers/course_progress_controller.rb', __FILE__)

  # Create the custom route
  Discourse::Application.routes.append do
    get '/course-progress' => 'course_progress#index', constraints: { format: 'json' }
  end
end
