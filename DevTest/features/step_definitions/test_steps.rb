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
  counter = retry_number
  
  while counter != 0
    begin
      step %(Ожидаем #{delay} секунд)
      if parameters != ''
        page.find(:xpath, "#{xpath}", parameters)
      else
        page.find(:xpath, "#{xpath}")
      end
      # puts "Элемент #{xpath} найден с #{retry_number + 1 - counter} попытки"
      return true
    rescue Capybara::ElementNotFound => e
      p "Элемент #{xpath} не найден с #{retry_number + 1 - counter} попытки"
      counter -= 1
      # Если это последняя попытка, возвращаем false
      return false if counter == 0
    rescue => e
      # Обработка неожиданных исключений
      p "Неожиданная ошибка при поиске элемента #{xpath}: #{e.class} - #{e.message}"
      interrupt_unknown_exception(e)
    end
  end
  
  false
end

def try_to_find_improved(xpath, delay, retry_number, parameters = {})
  retry_number.times do |attempt|
    begin
      sleep(delay) if delay > 0
      
      element = if parameters.empty?
                  page.find(:xpath, xpath)
                else
                  page.find(:xpath, xpath, **parameters)
                end
      
      puts "Элемент #{xpath} найден с #{attempt + 1} попытки" if ENV['DEBUG']
      return true
      
    rescue Capybara::ElementNotFound
      puts "Элемент #{xpath} не найден. Попытка #{attempt + 1} из #{retry_number}"
      next # переходим к следующей итерации
    rescue StandardError => e
      puts "Критическая ошибка при поиске #{xpath}: #{e.class} - #{e.message}"
      puts e.backtrace.first(5).join("\n") if ENV['DEBUG']
      raise e # Reraise критических ошибок немедленно
    end
  end
  
  false
end

def wait_for_element(xpath, timeout: 10, **options)
  begin
    page.find(:xpath, xpath, wait: timeout, **options)
    true
  rescue Capybara::ElementNotFound
    false
  end
end
