UnserializerTest = require 'tests/util/unserializer.coffee'

if not (new UnserializerTest()).runTests() then console.error "Unserializer test failed"
