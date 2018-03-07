require 'bundler'

module Api
  class <<self
    attr_reader :root, :env

    def require_files(dir, preload=[])
      (
        preload.map{|f| File.join(root, 'src', dir, "#{f}.rb")} +
        Dir[File.join(root, 'src', dir, '*.rb')]
      ).each {|f| require f}
    end

  end
  @root = File.expand_path(File.dirname(__FILE__))
  @env = ENV['RACK_ENV'] || 'development'
end

Bundler.require('default', Api.env)


Api.require_files('models')
Api.require_files('handlers/api', %w(handler))

map '/api/zombies' do
  run Api::ZombiesHandler
end