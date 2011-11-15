require 'usb'
require 'lib/stdout_light'

class DelcomLight < StdoutLight
  VENDOR_ID = 0x0fc5
  PRODUCT_ID = 0xb080
  INTERFACE_ID = 0

  OFF = "\x00"
  GREEN = "\x01"
  RED = "\x02"
  YELLOW = "\x04"
  
  def self.delcom?(device)
    device.idVendor == VENDOR_ID && device.idProduct == PRODUCT_ID
  end
  
  def self.devices
    USB.devices.select { |d| delcom? d }.sort { |d1, d2| d1.filename <=> d1.filename }
  end
  
  def initialize(device)
    @device = device
  end
  
  def identify
    puts "device '#{@device.filename}' with projects #{@projects}"
    green
    sleep 2
    off
  end

  def green
    msg(GREEN)
  end

  def yellow
    msg(YELLOW)
  end

  def red
    msg(RED)
  end

  def off
    msg(OFF)
  end

  def close
    handle.release_interface(INTERFACE_ID)
    handle.usb_close
    @handle = nil
  end

private
  def msg(data)
    handle.usb_control_msg(0x21, 0x09, 0x0635, 0x000, "\x65\x0C#{data}\xFF\x00\x00\x00\x00", 0)
  end

  def handle
    return @handle if @handle
    @handle = @device.usb_open
    unless RUBY_PLATFORM =~ /darwin/ # mac os x
      begin
        # ruby-usb bug: the arity of rusb_detach_kernel_driver_np isn't defined correctly, it should only accept a single argument.
        if USB::DevHandle.instance_method(:usb_detach_kernel_driver_np).arity == 2
          puts "arity 2"
          @handle.usb_detach_kernel_driver_np(INTERFACE_ID, INTERFACE_ID)
        else
          puts "arity 1"
          @handle.usb_detach_kernel_driver_np(INTERFACE_ID)
        end
      rescue Errno::ENODATA => e
        # Already detached
      end
    end
    @handle.set_configuration(@device.configurations.first)
    #@handle.claim_interface(INTERFACE_ID) not required??
    @handle
  end
end
