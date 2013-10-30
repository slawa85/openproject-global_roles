#-- copyright
# OpenProject is a project management system.
#
# Copyright (C) 2010-2013 the OpenProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

class OpenProject::GlobalRoles::PrincipalAllowanceEvaluator::Global < ChiliProject::PrincipalAllowanceEvaluator::Base

  def applicable?(action, project)
    project.nil?
  end

  def joins(action, project)
    users = User.arel_table
    principal_roles = principal_roles_table
    roles = roles_table

    on_principal_roles = users[:id].eq(principal_roles[:principal_id])
    on_roles = principal_roles[:role_id].eq(roles[:id])

    scope = users.join(principal_roles, Arel::Nodes::OuterJoin)
                 .on(on_principal_roles)
                 .join(roles, Arel::Nodes::OuterJoin)
                 .on(on_roles)

    User.joins(scope.join_sources)
  end

  def condition(action, project)
    roles_table[:permissions].matches("%#{action}%")
  end

  private

  def principal_roles_table
    PrincipalRole.arel_table.alias("principal_roles_#{ alias_suffix }")
  end

  def roles_table
    Role.arel_table.alias("roles_#{ alias_suffix }")
  end

  def alias_suffix
    "global"
  end
end
