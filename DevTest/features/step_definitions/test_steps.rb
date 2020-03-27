# encoding: UTF-8
# language: ru

Given(/^Переходим на страницу "(.*?)"$/) do |page|
  visit page
end

Given(/^Вводим текст "(.*?)" в поле c id "(.*?)"$/) do |text, field_id|
  find("//input[@id='#{field_id}']").set(text)
end

Given(/^Выбираем текст "(.*?)" в выпадающем списке с id "(.*?)"$/) do |text, select_id|
  find("//select[@id='#{select_id}']/option[text()='#{text}']").click
end

Given(/^Нажимаем кнопку с текстом "(.*?)"$/) do |text|
  find("//*[contains(@role, 'button')][.//span[contains(text(), '#{text}')]]").click
end

Given(/^Нажимаем кнопку "(.*?)"$/) do |text|
  find("//*[contains(@type, 'submit')][.//span[contains(text(), '#{text}')]]").click
end

Given(/^Нажимаем клавишу с id "(.*?)"$/) do |text|
  find("//*[@id='#{text}']").click
end

Given(/^Ожидаем (\d+) секунд(?:|ы)$/) do |sec|
  sleep sec.to_i
end
