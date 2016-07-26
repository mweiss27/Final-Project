class MusicsController < ApplicationController
 before_action :define_object, only: [:show, :edit, :update, :destroy]
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
		format.json { render :show, status: :created, location: @music}
	   end
	end
end

def music_params
	params.require(:music).permit(:band, :track)
end

def destroy
	Music.find(params[:id]).destroy
end

def define_object
	@music = Music.find(params[:id])
end

end
