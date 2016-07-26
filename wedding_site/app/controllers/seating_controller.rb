class SeatingController < ApplicationController
  def show
    @tables = Table.all
    @users = User.all
  end

  def edit
  end

  def update
  end
end
