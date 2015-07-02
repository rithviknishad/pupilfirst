module ActiveAdmin::ActiveAdminHelper
  def sv_id_link(user)
    if user.present?
      link_to "#{user.email} - #{user.fullname} #{user.phone.present? ? "(#{user.phone}" : ''})", admin_user_path(user)
    else
      '<em>Missing, probably deleted.</em>'.html_safe
    end
  end

  def availability_as_string(availability)
    day = case availability["days"]
      when Date::DAYNAMES then "Everyday"
      when Date::DAYNAMES[1..5] then "Weekdays"
      when Date::DAYNAMES - Date::DAYNAMES[1..5] then "Weekends"
      else availability["days"]
    end
    time = "#{availability["time"]["after"]}:00 to #{availability["time"]["before"]}:00 hrs"
    "#{day} , #{time}"
  end

  def mentor_skills_as_string(mentor_skills)
    mentor_skills.map do |mentor_skill|
      "#{mentor_skill.skill.name} (#{mentor_skill.expertise})"
    end.join ', '
  end
end
