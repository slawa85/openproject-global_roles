#-- copyright
# OpenProject is a project management system.
# Copyright (C) 2012-2013 the OpenProject Foundation (OPF)
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 3.
#
# OpenProject is a fork of ChiliProject, which is a fork of Redmine. The copyright follows:
# Copyright (C) 2006-2013 Jean-Philippe Lang
# Copyright (C) 2010-2013 the ChiliProject Team
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# See doc/COPYRIGHT.rdoc for more details.
#++

require 'spec_helper'

describe User, "allowed_to?" do
  let(:user) { FactoryGirl.build(:user) }
  let(:user2) { FactoryGirl.build(:user) }
  let(:project) { FactoryGirl.create(:project, is_public: false) }
  let(:role) { FactoryGirl.build(:global_role) }
  let(:anonymous_role) { FactoryGirl.build(:anonymous_role) }
  let(:principal_role) { FactoryGirl.build(:principal_role,
                                           :role => role,
                                           :principal => user) }

  before do
    user.save!
  end

  describe "w/ inquiring for projects" do

    describe "w/ the user having a global_role
              w/ the role having the necessary permission" do

      before do
        role.permissions << :add_work_packages
        role.save!
        principal_role.save!
      end

      it "should be false" do
        user.allowed_to?(:add_work_packages, project, global: false).should be_false
      end
    end
  end

  describe "w/ inquiring globally" do

    describe "w/ the user having a global_role
              w/ the role having the necessary permission" do

      before do
        role.permissions << :add_work_packages
        role.save!
        principal_role.save!
      end

      it "should be true" do
        user.allowed_to?(:add_work_packages, nil, global: true).should be_true
      end
    end

    describe "w/ the user having a global_role
              w/o the role having the necessary permission" do

      before do
        principal_role.save!
      end

      it "should be false" do
        user.allowed_to?(:add_work_packages, nil, global: true).should be_false
      end
    end

    describe "w/ a global role existing
              w/ the role having the necessary permission
              w/o the user having this role" do

      before do
        role.permissions << :add_work_packages
        role.save!
      end

      it "should be false" do
        user.allowed_to?(:add_work_packages, nil, global: true).should be_false
      end
    end

    describe "w/ another user having a global_role
              w/ the role having the necessary permission" do

      before do
        role.permissions << :add_work_packages
        role.save!
        principal_role.principal = user2
        principal_role.save
      end

      it "should be false" do
        user.allowed_to?(:add_work_packages, nil, global: true).should be_false
      end
    end
  end
end

