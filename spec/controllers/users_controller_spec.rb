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

require File.dirname(__FILE__) + '/../spec_helper'

describe UsersController do
  let(:admin) { FactoryGirl.build_stubbed(:admin) }

  before(:each) do
    @global_roles = [mock_model(GlobalRole), mock_model(GlobalRole)]
    GlobalRole.stub(:all).and_return(@global_roles)

    User.stub(:current).and_return(admin)

    disable_log_requesting_user
  end

  describe "get" do
    before :each do
      @params = {"id" => "1"}
      # disables testing the find_user method as this is tested within the core
      @controller.should_receive(:find_user)
    end

    describe :edit do
      before :each do

      end

      describe "RESULT" do
        before :each do

        end

        describe "html" do
          before :each do
            get "edit", @params
          end

          it { response.should be_success }
          it { assigns(:global_roles).should eql @global_roles }
          it { response.should render_template "users/edit"}
        end
      end

    end

  end
end
