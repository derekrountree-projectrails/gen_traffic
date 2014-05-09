require "#{Dir::pwd}/support/env"

def debug
  nil; debugger; nil
end

def click(the_selector, text='')
  if the_selector.is_a?(Capybara::Node::Element)
    the_selector.click
  else
    find(the_selector, :text => text).click
  end
end

def url_encode(val)
  val.gsub(/[,'.]/, '').gsub(/[\s&\/]/, '-').gsub(/-+/, '-').downcase
end

def load_search(city='covina-ca', term='antiques')
  visit("/#{url_encode(city)}/#{url_encode(term)}")
end

def pmp_ad
  attempt, the_link = 0, false
  until the_link do
    candidate = all('.pmp')
    unless candidate.count == 0
      the_link = candidate[rand(candidate.count-1)].find('h3 a')
      puts "[ Using: #{the_link.text} ]"
      return the_link
    else
      visit current_path
      attempt += 1
      raise "Couldn't find a PMP ad after 10 tries" if attempt >= 10
    end
  end
end

load_search
click pmp_ad
load_search('Los Angeles, CA', 'Plumbers')
click pmp_ad