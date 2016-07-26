class MusicsController < ApplicationController
 before_action :define_object, only: [:show, :edit, :update, :destroy]
 before_action :require_login
	def index
		@music = Music.all
	end

	def show
	end

	def create
		@music = Music.new(music_params)
		respond_to do |format|
	   		if @music.save
				format.html{redirect_to @music, notice: "Entry successfully added to playlist"}
				format.json { render :index, status: :created, location: @music}
	   		end
		end
	end

	def music_params
		params.require(:music).permit(:band, :track)
	end

	def destroy
		@music.destroy
		respond_to do |format|
			
				format.html{redirect_to @music, notice: "Entry successfully removed from playlist"}
				format.json {render :index, status: created, location: @music}
		end
	end

	def define_object
		@music = Music.find(params[:id])
	end
	
	def require_login
		if current_user == nil
			redirect_to :controller => 'landing' 
		end
	end


end
