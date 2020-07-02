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

def interrupt_unknown_exception(exception)
  p "interrupt_unknown_exception. #{exception.message}"
  p "#{exception.full_message}"
  raise exception.class
end

def try_to_find(xpath, delay, retry_number, parameters='')
  e = ''
  counter = retry_number
  while counter != 0
    e = ''
      begin
        step %(Ожидаем #{delay} секунд)
        if parameters!=''
          page.find(:xpath,"#{xpath}", parameters)
        else
          page.find(:xpath,"#{xpath}")
        end
        # puts "Элемент #{xpath} найден с #{retry_number + 1 - counter} попытки"
        counter = 0
        result = true
      rescue => e
        p "Элемент #{xpath} не найден с #{retry_number + 1 - counter} попытки"
        counter -= 1
        result = false
      rescue => e
        interrupt_unknown_exception(e)
      end
  end
  return result
end