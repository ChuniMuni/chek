# encoding: UTF-8
# language: ru

Given(/^Активируем чекбокс с текстом "(.*?)"$/) do |text|
  find("//span/following::span[contains(text(), '#{text}')]").click
end

Given(/^Вводим текст "(.*?)" в поле "(.*?)"$/) do |text, field_id|
  find("//input[contains(@aria-label,'#{field_id}')]").set(text)
end

Given(/^Выбираем текст "(.*?)" в выпадающем списке$/) do |text|
  find("//span[@class='quantumWizMenuPaperselectContent exportContent'][contains(.,'Выбрать')]").click
  find("//span[@class='quantumWizMenuPaperselectContent exportContent'][contains(.,'#{text}')]").click
end

Given(/^Отправляем отчет в ЦК$/) do
  find("//span[@class='appsMaterialWizButtonPaperbuttonLabel quantumWizButtonPaperbuttonLabel exportLabel'][contains(.,'Отправить')]").click
  xpath_opened_message = "//div[@class='freebirdFormviewerViewResponseConfirmationMessage']"
  if try_to_find(xpath_opened_message, 1, 3)
    puts "Ваш ответ записан."
  else
    p "Ответ не был записан."
  end
end
