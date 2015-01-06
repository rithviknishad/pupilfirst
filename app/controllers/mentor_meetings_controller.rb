class MentorMeetingsController < ApplicationController
  
  def live
    @mentor_meeting = MentorMeeting.find(params[:id])
  end

  def new
  	mentor = Mentor.find params[:mentor_id]
  	@mentor_meeting = mentor.mentor_meetings.new
  end

  def create
    raise_not_found unless current_user.startup.present?
  	mentor = Mentor.find params[:mentor_id]
  	@mentor_meeting = mentor.mentor_meetings.new(meeting_params)
  	@mentor_meeting.user = current_user
  	if @mentor_meeting.save
  		UserMailer.meeting_request_to_mentor(@mentor_meeting).deliver
  		redirect_to mentoring_path(current_user)
  	else
  		flash[:alert]="Failed to create new meeting request"
  		render 'new'
  	end
  end

  def index
  	@mentor_meetings = MentorMeeting.all
  end

  def update
    mentor_meeting = current_user.mentor.mentor_meetings.find(params[:id])
    mentor_meeting.status = params[:commit] == "Approve" ? MentorMeeting::STATUS_ACCEPTED : MentorMeeting::STATUS_REJECTED
    mentor_meeting.meeting_at = mentor_meeting.suggested_meeting_at if params[:commit] == "Approve"   
    mentor_meeting.save
    flash[:notice] = "Meeting status has been updated"
    redirect_to mentoring_url 
  end


  private
  	def meeting_params
  		params.require(:mentor_meeting).permit(:purpose,:suggested_meeting_at,:suggested_meeting_time,:duration)
  	end
end
