workers Integer(3)  
threads_count = Integer(5)
threads 1, threads_count

  app_dir = '/home/deployer/barzy'
  port        9595
  environment 'production'

#bind "unix://#{app_dir}/tmp/sockets/puma_store.sock"
stdout_redirect 'log/puma.log', 'log/puma_error.log', true
preload_app!

rackup      DefaultRackup

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end
