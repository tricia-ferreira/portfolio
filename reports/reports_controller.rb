class Backoffice::ReportsController < ApplicationController

  after_action :verify_authorized, except: [:index, :generate]
  before_action :set_date, except: [:index]
  before_action :set_report_type, except: [:index]

  def index; end

  def generate
    @records = send(@type) rescue []
    respond_to do |format|
      if @records.any?
        format.html
      else
        flash[:error] = 'No records found.'
        format.html { redirect_to [:backoffice, :reports] }
      end
    end
  end

  private

  def entities_report
    Views::BusinessEntityReportView.registering_and_beyond
  end

  def set_report_type
    @type = params[:form_report_filter][:type]
  end

  def set_date
    if params[:form_report_filter].has_key?('month_select(1i)') && params[:form_report_filter].has_key?('month_select(2i)') && params[:form_report_filter].has_key?('month_select(3i)')
      date = Date.parse("#{params[:form_report_filter]['month_select(1i)']}-#{params[:form_report_filter]['month_select(2i)']}-#{params[:form_report_filter]['month_select(3i)']}")
    else
      date = Date.today
    end
    @start_date = date.at_beginning_of_month.midnight
    @end_date = date.end_of_month.end_of_day
  end
end
