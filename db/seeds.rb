# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             designated_work_start_time: "9:00",
             designated_work_end_time: "18:00",
             admin: true)
             
2.times do |n|
  name = "上長#{n+1}"
  email = "superior-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               designated_work_start_time: "9:00",
               designated_work_end_time: "18:00",
               superior: true)
end
             
10.times do |n|
  name = Gimei.name.kanji
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               designated_work_start_time: "9:00",
               designated_work_end_time: "18:00",)
end