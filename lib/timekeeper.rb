module TimeKeeper

  def jsonToRubyDate(stringDate)
    DateTime.parse(stringDate)
  end

  def timeDiff(timeStart, timeEnd)
    timeEnd - timeStart
  end

  def timeUsed(start)
    DateTime.now - start
  end

  def timeUsedPercentage(deadline, start)
    (timeUsed(start)/timeDiff(start, deadline)).round(1)*100
  end

end

# 2.1.1 :072 >   x
#  => "2014-06-13T15:11:08.718Z" 
# 2.1.1 :073 > y = x.scan(/([0-9]{4})-([0-9]{1,2})-([0-9]{1,2})T([0-9]{1,2}):([0-9]{1,2}):([0-9]{1,2})/)
#  => [["2014", "06", "13", "15", "11", "08"]] 