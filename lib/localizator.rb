module Localizator

  class Railtie < Rails::Railtie

    rake_tasks do
      load "tasks/localizator.rake"
    end
  end

end

