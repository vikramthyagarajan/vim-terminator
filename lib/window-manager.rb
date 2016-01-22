class TerminatorWindow
  def initialize(windowName = nil)
    @windowName = windowName
    @location = 'belowright'
    @orientation = 'v'
    @length = 0
  end

  def runWindowCreation()
    VIM::command(@location + ' ' + @length.to_s + @orientation +'new ' + @windowName)
  end

  def fullscreen()
    columns = WindowManager.columns
    lines = WindowManager.lines
    VIM::command('vertical res ' + columns.to_s)
    VIM::command('res ' + lines.to_s)
  end

  def hide()
    VIM::command('vertical res 0')
  end
end

class WindowManager
  @@terminatorName = 'terminator-genisys'
  @@savedState = nil
  def self.initialize(columns, lines)
    @@columns = columns
    @@lines = lines
  end

  #getters and setters
  def self.columns
    @@columns
  end
  def self.lines
    @@lines
  end

  def self.createTerminatorWindow(windowName = @@terminatorName)
    #check if any window or buffer of the same already exists
    alTerm = findTerminator(windowName)
    if alTerm.nil?
      #Terminator session doesn't exist, create one
      termWindow = TerminatorWindow.new windowName
      termWindow.runWindowCreation()
    else
      puts windowName + ' already exists. Not creating window'
      return
    end
    #creating a new TerminatorWindow
  end

  def self.findTerminator(windowName)
    window = VIM::Window
    length = window.count
    for ind in 0...length
      windowObj = window[ind]
      name = windowObj.buffer.name
      if !name.match(windowName).nil?
        return windowObj
      end
    end
    return nil
  end

  def self.switchToWindow(windowObj)
    currentWindow = VIM::Window.current
    currentNumber = currentWindow.buffer.number
    targetNumber = windowObj.buffer.number
    #keep going to next window until you get to windowObj The way it finds if 
    #the windows are same are by checking the buffer numbers open in them
    while currentNumber != targetNumber
      VIM::command('wincmd w')
      currentNumber = VIM::Window.current.buffer.number
    end
  end

  def self.saveState()
    #saves state so that it can be got again
    @@savedState = VIM::Window.current
  end

  def self.showTerminator(windowName = @@terminatorName)
    window = self.findTerminator(windowName)
    switchToWindow(window)
    saveState()
    terminator = TerminatorWindow.new window.buffer.name
    terminator.fullscreen()
  end

  def self.hideTerminator(windowName = @@terminatorName)
    window = self.findTerminator(windowName)
    switchToWindow(window)
    terminator = TerminatorWindow.new window.buffer.name
    terminator.hide()
    switchToWindow(@@savedState)
  end

  def self.windows()
    window = VIM::Window
    length = window.count
    for ind in 0...length
      windowObj = window[ind]
      puts 'window has buffer' + windowObj.buffer.name
    end
  end
end
