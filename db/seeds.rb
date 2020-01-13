# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

stories = 10.times.map { Story.create name: Faker::Company.name }

100.times { Article.create name: Faker::Company.name, type: Article::TYPES.sample.to_s, text: Faker::Lorem.paragraphs.join("\n"), story: stories.sample }
