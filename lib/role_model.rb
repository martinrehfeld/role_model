require 'role_model/implementation'
require 'role_model/class_methods'
require 'role_model/roles'

module RoleModel

  INHERITABLE_CLASS_ATTRIBUTES = [:roles_attribute_name, :valid_roles]

  include Implementation

  def self.included(base) # :nodoc:
    base.extend ClassMethods
    base.class_eval do
      class << self
        attr_accessor(*::RoleModel::INHERITABLE_CLASS_ATTRIBUTES)
      end
      roles_attribute :roles_mask # set default bitmask attribute
      self.valid_roles = []
    end
  end

end
