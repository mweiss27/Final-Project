#Author: Robert Reilly
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
		@music.requestName = current_user.username
	   		if @music.save
				redirect_to '/musics', notice: "Your entry has been successfully added to the playlist."
			else
				redirect_to '/musics', notice: "Your song already exists in the playist, no changes were made to the playlist."
	   		end
	end

	def music_params
		params.require(:music).permit(:band, :track, :requestName)
	end

	def destroy
		if current_user.username == @music.requestName
			@music.destroy
			redirect_to '/musics', notice:'Your song has been successfully removed from the playlist'
		else
			redirect_to '/musics', notice:'You did not add this song to the playlist, you can not remove it.'
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
