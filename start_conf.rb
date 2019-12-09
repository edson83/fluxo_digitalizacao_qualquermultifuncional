require 'rubygems'
require 'sinatra'
require 'haml'
require 'socket'
require 'rexml/document'
require './views/userdata'
require './views/server'


 def local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

      UDPSocket.open do |s|
        s.connect '192.168.1.1', 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end

    ip=local_ip
    puts ip

$ip_server = ip

puts "\nO DigitalFlux foi ativado no IP #{$ip_server} com a porta 808!"

puts "\nDigitalFlux iniciado, não feche essa janela!\n\n"