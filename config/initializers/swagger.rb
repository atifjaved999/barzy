# config/initializers/swagger.rb

# if Rails.env  == "staging"
#    path = "https://barzy.herokuapp.com"
# elsif Rails.env == "development"
#    path = "http://localhost:3000"
# else
#   path = "https://barzy.herokuapp.com"
# end

  # path = "http://192.168.88.168:3000"
  path = "https://barzy.herokuapp.com"
  

class ActiveSupport::TimeWithZone
    def as_json(options = {})
        strftime('%Y-%m-%d %H:%M:%S %Z')
    end
end
class Swagger::Docs::Config
  def self.transform_path(path, api_version)
    # Make a distinction between the APIs and API documentation paths.
    "assets/apidocs/#{path}"
  end
end

Swagger::Docs::Config.register_apis({
  '2.0' => {
    controller_base_path: '',
    api_file_path: 'vendor/assets/vswagger/apidocs',
    base_path: path,
    clean_directory: true
  }
})