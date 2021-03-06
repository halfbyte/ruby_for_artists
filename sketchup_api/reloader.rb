require 'sketchup'
module Halfbyte
  module Reloader
    include Sketchup
    def self.reload!
      Dir[File.expand_path(File.dirname(__FILE__)) + "/*.rb"].map do |datei|
        puts "reloading #{datei}."
        load datei
      end.inject(true) {|memo, entry| memo && entry}
    end
  end
end

unless file_loaded? File.basename(__FILE__)
  UI.menu("Plug-Ins").add_separator
  UI.menu("Plug-Ins").add_item("Reload Pixelfont Scripts") do
    Halfbyte::Reloader::reload!
  end
end
file_loaded File.basename(__FILE__)
