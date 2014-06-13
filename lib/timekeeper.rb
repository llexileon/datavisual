module TimeKeeper

  def jsonToRubyDate(stringDate)
    rubyDate = stringDate.split("T")[0].split("-").map do |dateUnit| dateUnit.to_i end
    Time.new(rubyDate[0], rubyDate[1], rubyDate[2])
  end

  def timeDiff(timeStart, timeEnd)
    timeEnd - timeStart
  end

  def timeUsed(start)
    Time.now - start
  end

  def timeUsedPercentage(deadline, start)
    (timeUsed(start)/timeDiff(start, deadline)).round(1)*100
  end

end
