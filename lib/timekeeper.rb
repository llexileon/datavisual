module TimeKeeper

  def jsonToRubyDate(stringDate)
    DateTime.parse(stringDate)
  end

  def timeDiff(timeStart, timeEnd)
    (timeEnd - timeStart).to_f
  end

  def timeUsed(start)
    (DateTime.now - start).to_f
  end

  def time_remaining(deadline)
  	(deadline - DateTime.now).to_f
  end

  def timeUsedPercentage(deadline, start)
  	puts "........"
  	puts "time used #{timeUsed(start)}"
  	puts "time diff #{timeDiff(start, deadline)}"
  	puts "#{(timeUsed(start)/timeDiff(start, deadline)).round(1)*100}"

    if time_remaining(deadline) < 0
    	return -1
    else
    	(timeUsed(start)/timeDiff(start, deadline)).round(1)*100
    end
  end

end
