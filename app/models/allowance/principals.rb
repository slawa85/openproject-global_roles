#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2010-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

Allowance.scope(:principals) do
  table :principal_roles
  table :global_roles, Allowance::Table::GlobalRoles

  condition :principal_role_id_equal_principal, Allowance::Condition::PrincipalRoleIdEqualPrincipal
  condition :role_id_equal_principal_role, Allowance::Condition::RoleIdEqualPrincipalRole

  principals.left_join(principal_roles, :before => roles)
            .on(principal_role_id_equal_principal)

  member_in_project.or(role_id_equal_principal_role)
end
