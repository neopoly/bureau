def include_engine?
  defined?(Rails) && Rails.version.scan(/(^\d)/).flatten[0].to_i >= 3
end

if include_engine?
  module Bureau
    class Engine < Rails::Engine
      isolate_namespace Bureau
    end
  end
end
