class TimeTrackersController < ApplicationController
    unloadable

    def start
        if current.nil?
            @issue = Issue.find(:first, :conditions => { :id => params[:issue_id] })

            new_tracker = TimeTracker.new({ :issue_id => @issue.id })
            if new_tracker.save
                render_menu
            else
                flash[:error] = l(:start_time_tracker_error)
            end
        else
            flash[:error] = l(:time_tracker_already_running_error)
        end
    end

    def stop
        @time_tracker = current
        if @time_tracker.nil?
            flash[:error] = l(:no_time_tracker_running_error)
            redirect_to :back
        else
            issue_id = @time_tracker.issue_id
            hours = @time_tracker.hours_spent
            @time_tracker.destroy

            redirect_to :controller => 'timelog', :action => 'edit', :issue_id => issue_id, :time_entry => { :hours => hours }
        end
    end
 
    def render_menu
        @project = Project.find(:first, :conditions => { :id => params[:project_id] })
        @issue = Issue.find(:first, :conditions => { :id => params[:issue_id] })
        render :partial => 'embed_menu'
    end

    protected

    def current
        TimeTracker.find(:first, :conditions => { :user_id => User.current.id })
    end
end
