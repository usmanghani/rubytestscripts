require 'rubygems'
require 'active_record'
require 'yaml'
require 'logger'
require 'pp'

ActiveRecord::Base.establish_connection(YAML::load(File.open('database.yml')))
ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))                    

class Person < ActiveRecord::Base
  validates_presence_of :name
end

p = Person.find(:last)

person = Person.new
id = p.nil? ? 1 : p.id + 1
person.id = id
person.name = 'usman' + id.to_s
person.save

person2 = Person.new
person2.id = 40
person2.name = 'Hamed'
person2.save

puts person2

puts person
puts Person.count

Person.find(:all).each do |person|
  pp person
end






