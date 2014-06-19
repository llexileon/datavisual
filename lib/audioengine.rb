module AudioEngine

  def audio_engine
    soundtrack
    foleyfx
  end

  def toggle_mute!
    @mute = !@mute
    if @song.paused?
      @song.play(looping = true)
    else
      @song.pause
    end
  end


  def soundtrack # Game Soundtrack
    @soundtrack = [] 
    @soundtrack << Gosu::Song.new("assets/audio/returningloop.mp3")
    @song = @soundtrack.first
    @song.play(looping = true)
  end

  def foleyfx # Game Foley
    @bounce_sample = Gosu::Sample.new(self, "assets/audio/bounce.mp3")
    @freeze_sample = Gosu::Sample.new(self, "assets/audio/freeze.mp3")
    # @login_sample = Gosu::Sample.new(self, "assets/audio/warp.mp3")
  end

end
