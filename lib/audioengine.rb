module AudioEngine

  def audio_engine
    soundtrack
    foleyfx
  end

  def soundtrack # Game Soundtrack
    @soundtrack = [] 
    @soundtrack << Gosu::Song.new("assets/audio/loop.mp3")
    @song = @soundtrack.first
    @song.play(looping = true)
  end

  def foleyfx # Game Foley
    @bounce_sample = Gosu::Sample.new(self, "assets/audio/bounce.mp3")
    # @wall_sample = Gosu::Sample.new(self, "assets/audio/hit.mp3")
    # @login_sample = Gosu::Sample.new(self, "assets/audio/warp.mp3")
  end

end
