base_dir = File.expand_path(File.join(File.dirname(__FILE__), ".."))
lib_dir  = File.join(base_dir, "lib")
test_dir = File.join(base_dir, "test")
$LOAD_PATH.unshift(lib_dir)

require 'test/unit'

def build_xml_string(&block)
  xmlobj = Nokogiri::XML::Builder.new {|xml| yield(xml) }
  xmlobj.to_xml.to_s
end

exit Test::Unit::AutoRunner.run(true, test_dir)
