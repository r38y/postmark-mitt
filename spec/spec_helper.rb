$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'postmark_mitt'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

SPEC_ROOT = Pathname.new(File.dirname(__FILE__))

def read_fixture(file='email.json')
  File.read(File.join(SPEC_ROOT, 'fixtures', file))
end

RSpec.configure do |config|

end
