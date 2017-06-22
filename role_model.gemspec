Gem::Specification.new do |s|
  s.name = "role_model"
  s.version = "0.8.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Martin Rehfeld"]
  s.date = "2015-02-12"
  s.description = "Ever needed to assign roles to a model, say a User, and build conditional behaviour on top of that? Enter RoleModel -- roles have never been easier! Just declare your roles and you are done. Assigned roles will be stored as a bitmask."
  s.email = "martin.rehfeld@glnetworks.de"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "LICENSE",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "lib/role_model.rb",
    "lib/role_model/class_methods.rb",
    "lib/role_model/implementation.rb",
    "lib/role_model/roles.rb",
    "role_model.gemspec",
    "spec/custom_matchers.rb",
    "spec/custom_matchers_spec.rb",
    "spec/role_model_spec.rb",
    "spec/roles_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/martinrehfeld/role_model"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Declare, assign and query roles with ease"

  s.add_development_dependency(%q<rake>, ["< 11.0.1"])
  s.add_development_dependency(%q<rspec>, ["2.99.0"])
  s.add_development_dependency(%q<rdoc>, [">= 2.4.2"])
end

