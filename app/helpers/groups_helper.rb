module GroupsHelper

  def member_to_delete(group, user)
    Membership.where(group_id: group.id, user_id: user.id).first
  end
end
