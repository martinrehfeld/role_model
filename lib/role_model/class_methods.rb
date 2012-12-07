module RoleModel
  module ClassMethods
    def inherited(subclass) # :nodoc:
      ::RoleModel::INHERITABLE_CLASS_ATTRIBUTES.each do |attribute|
        instance_var = "@#{attribute}"
        subclass.instance_variable_set(instance_var, instance_variable_get(instance_var))
      end
      super
    end

    # set the bitmask attribute role assignments will be stored in
    def roles_attribute(name)
      self.roles_attribute = name
    end

    # alternative method signature: set the bitmask attribute role assignments will be stored in
    def roles_attribute=(name)
      self.roles_attribute_name = name.to_sym
    end

    def mask_for(*roles)
      sanitized_roles = roles.map { |role| Array(role) }.flatten.map(&:to_sym)

      (valid_roles & sanitized_roles).inject(0) { |sum, role| sum + 2**valid_roles.index(role) }
    end

    # generated all available mask combination for mentioned roles
    def available_masks_for(*roles)
      roles.flatten!
      result = roles.map { |role| self.mask_for role }

      for i in 2..(self.valid_roles.size)
        self.valid_roles.combination(i).each do |c|
          result << self.mask_for(c) unless roles.&(c).empty?
        end
      end

      result
    end

    # generate combination only with mentioned roles
    def masks_only_for(*roles)
      roles.flatten!
      result = roles.map { |role| self.mask_for role }

      for i in 2..(roles.size)
        result += roles.combination(i).map { |c| self.mask_for c }
      end

      result.uniq
    end

    protected

    # :call-seq:
    #   roles(:role_1, ..., :role_n)
    #   roles('role_1', ..., 'role_n')
    #   roles([:role_1, ..., :role_n])
    #   roles(['role_1', ..., 'role_n'])
    #
    # declare valid roles
    def roles(*roles)
      opts = roles.last.is_a?(Hash) ? roles.pop : {}
      self.valid_roles = roles.flatten.map(&:to_sym)
      unless (opts[:dynamic] == false)
        self.define_dynamic_queries(self.valid_roles)
      end
    end
    
    # Defines dynamic queries for :role
    #   #is_<:role>?
    #   #<:role>?
    #
    # Defines new methods which call #is?(:role)
    def define_dynamic_queries(roles)
      dynamic_module = Module.new do
        roles.each do |role|
          ["#{role}?".to_sym, "is_#{role}?".to_sym].each do |method|
            define_method(method) { is? role }
          end
        end
      end
      include dynamic_module
    end
  end
end
