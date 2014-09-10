class ReportsController < ApplicationController

  def total_by_group
    @user = current_user
    @groups = current_user.groups
  end

  def overall_total
    @user = current_user
    @groups = current_user.groups
  end

end
