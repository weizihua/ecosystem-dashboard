class RepositoriesController < ApplicationController
  def index
    @scope = Repository.protocol
    @scope = @scope.org(params[:org]) if params[:org].present?
    @scope = @scope.language(params[:language]) if params[:language].present?
    @scope = @scope.fork(params[:fork]) if params[:fork].present?
    @scope = @scope.archived(params[:archived]) if params[:archived].present?
    @pagy, @repositories = pagy(@scope.order('pushed_at DESC'))

    @orgs = @scope.unscope(where: :org).protocol.group(:org).count
    @languages = @scope.unscope(where: :language).group(:language).count
  end

  def events
    @scope = Event.includes(:repository)
    @scope = @scope.org(params[:org]) if params[:org].present?
    @scope = @scope.user(params[:user]) if params[:user].present?
    @scope = @scope.event_type(params[:event_type]) if params[:event_type].present?
    @pagy, @events = pagy(@scope.order('created_at DESC'))

    @orgs = @scope.unscope(where: :org).protocol.group(:org).count
    @users = @scope.unscope(where: :actor).group(:actor).count
    @event_types = @scope.unscope(where: :event_type).group(:event_type).count
  end
end