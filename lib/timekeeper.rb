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

  def overdue(deadline)
    oseconds = Time.now.to_i - deadline.to_time.to_i
    od,oh = oseconds.divmod(24*60*60)
    oh,om = oh.divmod(60*60)
    om,os = om.divmod(60)
    [od,oh,om,os]
    if od == 0
      "Overdue by #{oh}:#{om}:#{os}"
    elsif od == 1
      "Overdue by #{od} day #{oh}:#{om}:#{os}"
    else
      "Overdue by #{od} days #{oh}:#{om}:#{os}"
    end    
  end  

  def due_in(deadline)
    seconds = deadline.to_time.to_i - Time.now.to_i
    dd,hh = seconds.divmod(24*60*60)
    hh,mm = hh.divmod(60*60)
    mm,ss = mm.divmod(60)
    if dd == 0
      "Due today in #{hh}:#{mm}:#{ss}"
    elsif dd == 1
      "Due in #{dd} day #{hh}:#{mm}:#{ss}"
    elsif dd > 1
      "Due in #{dd} days #{hh}:#{mm}:#{ss}"      
    else
      overdue(deadline)
    end
  end

  def timeUsedPercentage(deadline, start)
    if time_remaining(deadline) < 0
    	return -1
    else
    	(timeUsed(start)/timeDiff(start, deadline)).round(1)*100
    end
  end

end
