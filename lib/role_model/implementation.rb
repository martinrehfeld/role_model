module RoleModel
  module Implementation

    # assign roles
    def roles=(*roles)
      self.send("#{self.class.roles_attribute_name}=", self.class.mask_for(*roles))
    end

    # query assigned roles
    def roles
      Roles.new(self, self.class.valid_roles.reject { |r| ((self.send(self.class.roles_attribute_name) || 0) & 2**self.class.valid_roles.index(r)).zero? })
    end

    # query assigned roles returning an Array for the
    # declarative_authorization gem
    def role_symbols
      roles.to_a
    end

    # :call-seq:
    #   has_all_roles?(:role)
    #   has_all_roles?('role')
    #   has_all_roles?(:role_1, ..., :role_n)
    #   has_all_roles?('role_1', ..., 'role_n')
    #   has_all_roles?([:role_1, ..., :role_n])
    #   has_all_roles?(['role_1', ..., 'role_n'])
    #
    # check if ALL of the given roles have been assigned
    # this method is aliased as #is? and #has_roles?
    def has_all_roles?(*roles)
      roles.flatten.map(&:to_sym).all? { |r| self.roles.include?(r) }
    end
    alias_method :is?, :has_all_roles?
    alias_method :has_roles?, :has_all_roles?

    # :call-seq:
    #   has_any_role?(:role)
    #   has_any_role?('role')
    #   has_any_role?(:role_1, ..., :role_n)
    #   has_any_role?('role_1', ..., 'role_n')
    #   has_any_role?([:role_1, ..., :role_n])
    #   has_any_role?(['role_1', ..., 'role_n'])
    #
    # check if any (at least ONE) of the given roles have been assigned
    # this method is aliased as #is_any_of? and #has_role?
    def has_any_role?(*roles)
      roles.flatten.map(&:to_sym).any? { |r| self.roles.include?(r) }
    end
    alias_method :is_any_of?, :has_any_role?
    alias_method :has_role?, :has_any_role?

    # :call-seq:
    #   has_only_roles?(:role)
    #   has_only_roles?('role')
    #   has_only_roles?(:role_1, ..., :role_n)
    #   has_only_roles?('role_1', ..., 'role_n')
    #   has_only_roles?([:role_1, ..., :role_n])
    #   has_only_roles?(['role_1', ..., 'role_n'])
    #
    # check if ONLY of the given roles have been assigned
    # this method is aliased as #is_exactly?
    def has_only_roles?(*roles)
      self.send("#{self.class.roles_attribute_name}") == self.class.mask_for(*roles)
    end
    alias_method :is_exactly?, :has_only_roles?

  end
end
