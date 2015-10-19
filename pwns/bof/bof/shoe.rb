require 'socket'
require 'timeout'
require 'rolling_timeout'

class Shoe < TCPSocket
  def recv_until str
    buf = ""
    until buf.end_with? str do
      buf << self.recv(1)
    end
    buf
  end

  def recv_until_re regex
    buf = ""
    while not regex.match buf
      buf << self.recv(1)
    end
    buf
  end

  def say str
    self.send str, 0
  end

  def read_n_seconds secs
    # requires native threads.
    # doesn't work with ruby 1.8.x or lower
    buf = ""
    begin
      timeout(secs) do
        loop {
          buf << self.recv(1)
        }
      end
    rescue Timeout::Error
    end
    buf
  end

  def read_til_end timeout
    # timeout is time between chars
    buf = ""
    begin
      RollingTimeout.new(timeout) { |timer|
        loop {
          buf << self.recv(1)
          timer.reset
        }
      }
    rescue Timeout::Error
    end
    buf
  end

  def tie!
    # kick off a thread just reading forever
    Thread.new { loop { $stdout.write(self.recv(4096)) } }
    str = ""
    loop {
      ch = $stdin.read_nonblock(1) rescue nil
      if ch == nil
        next
      end
      self.send ch, 0
    }
  end
end
