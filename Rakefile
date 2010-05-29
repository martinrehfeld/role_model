require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "role_model"
    gem.summary = %Q{Declare, assign and query roles with ease}
    gem.description = %Q{Ever needed to assign roles to a model, say a User, and build conditional behaviour on top of that? Enter RoleModel -- roles have never been easier! Just declare your roles and you are done. Assigned roles will be stored as a bitmask.}
    gem.email = "martin.rehfeld@glnetworks.de"
    gem.homepage = "http://github.com/martinrehfeld/role_model"
    gem.authors = ["Martin Rehfeld"]
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
  spec.rcov_opts.concat ['--exclude', 'rcov.rb']
  spec.rcov_opts.concat ['--exclude', '.*_spec.rb']
  spec.rcov_opts.concat ['--exclude', 'spec_helper.rb']
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "role_model #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
