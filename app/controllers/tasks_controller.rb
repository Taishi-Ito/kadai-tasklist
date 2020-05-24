class TasksController < ApplicationController
  
   before_action :require_user_logged_in
    before_action :correct_user, only: [:destroy,:update, :edit, :show]
  
  def index
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
  end

  def show
  set_task
  end

  def new
    @task = current_user.tasks.build
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = 'メッセージを投稿しました。'
      redirect_to root_url
    else
      @tasks = current_user.tasks.order(id: :desc).page(params[:page])
      flash.now[:danger] = 'メッセージの投稿に失敗しました。'
      render :new
    end
  end

  def edit
     set_task
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'タスクは正常に保存されました。'
      redirect_to @task
    else flash.now[:danger] = 'タスクは更新されませんでした。'
      render :edit
    end
  end

  def destroy
   set_task
    @task.destroy

    flash[:success] = 'Task は正常に削除されました'
    redirect_to root_url
  end
  
  private

  def set_task
    @task = @task = current_user.tasks.find_by(id: params[:id])
  end

  def correct_user
   set_task
   
    unless @task
      redirect_to root_url
    end
  end



  # Strong Parameter
  def task_params
    params.require(:task).permit(:content,:status)
  end
  
end
