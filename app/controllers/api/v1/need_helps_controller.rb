class Api::V1::NeedHelpsController < Api::V1::BaseController

  swagger_controller :need_helps, "NeedHelp"

  swagger_api :create do |api|
    api.param :form, "need_help[email]", :string, :required, "Email"
    api.param :form, "need_help[description]", :string, :required, "Description"
    response :not_acceptable
    response :requested_range_not_satisfiable
  end

  def create
    @need_help = NeedHelp.new(need_help_params)
    unless @need_help.save
      render :json =>{:success => false, :error => "#{@need_help.errors.full_messages}"}, :status => 400
    end
  end

  private

  def need_help_params
    params.require(:need_help).permit(:id, :email, :description)
  end

end
